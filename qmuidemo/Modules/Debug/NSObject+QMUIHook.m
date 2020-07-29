//
//  NSObject+QMUIHook.m
//  qmuidemo
//
//  Created by ziezheng on 2020/6/12.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "NSObject+QMUIHook.h"
#import <objc/message.h>

@interface QMUIHookContext()
@property(nonatomic, strong) NSInvocation *originalInvocation;
@property(nonatomic, copy) dispatch_block_t invokeBlock;
@property(nonatomic, copy) void (^getReturnValueBlock)(void *retLoc);
@property(nonatomic, copy) void (^setReturnValueBlock)(void *retLoc);
@property(nonatomic, copy) void (^getArgumentBlock)(void *argumentLocation, NSInteger idx);
@property(nonatomic, copy) void (^setArgumentBlock)(void *argumentLocation, NSInteger idx);
@end

@implementation QMUIHookContext

+ (instancetype)contextWithInstance:(id)instance invocation:(NSInvocation *)invocation {
    QMUIHookContext *context = [[self alloc] init];
    context.instance = instance;
    context.originalInvocation = invocation;
    return context;
}

- (void)getReturnValue:(void *)retLoc {
    if (self.originalInvocation) {
        [self.originalInvocation getReturnValue:retLoc];
    } else if (self.getReturnValueBlock) {
        self.getReturnValueBlock(retLoc);
    }
}
- (void)setReturnValue:(void *)retLoc {
    if (self.originalInvocation) {
        [self.originalInvocation setReturnValue:retLoc];
    } else if (self.setReturnValueBlock) {
        self.setReturnValueBlock(retLoc);
    }
}

- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx {
    if (self.originalInvocation) {
        [self.originalInvocation getArgument:argumentLocation atIndex:idx];
    } else if (self.getArgumentBlock) {
        self.getArgumentBlock(argumentLocation, idx);
    }
}
- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx {
    if (self.originalInvocation) {
        [self.originalInvocation setArgument:argumentLocation atIndex:idx];
    } else if (self.setArgumentBlock) {
        self.setArgumentBlock(argumentLocation, idx);
    }
}

- (void)invoke {
    if (self.invokeBlock) {
        self.invokeBlock();
    }
}

@end


@implementation QMUIHookToken

+ (instancetype)tokenWithSelector:(SEL)selector object:(id)object options:(QMUIHookOption)options block:(id)block {
    NSCParameterAssert(block);
    NSCParameterAssert(selector);
    QMUIHookToken *token = [[QMUIHookToken alloc] init];
    token.selector = selector;
    token.block = block;
    token.options = options;
    token.object = object;
    return token;
}

@end


@interface QMUIHookTokenContainer : NSObject

- (void)addToken:(QMUIHookToken *)token withOptions:(QMUIHookOption)hookOption;
- (void)removeToken:(QMUIHookToken *)token;
- (BOOL)hasTokens;

@property(nonatomic, strong) NSMethodSignature *methodSignature;
@property (atomic, copy) NSArray *beforeTokens;
@property (atomic, copy) NSArray *afterTokens;
@property (atomic, copy) NSArray *insteadTokens;

@end

@implementation QMUIHookTokenContainer

- (void)addToken:(QMUIHookToken *)token withOptions:(QMUIHookOption)hookOption {
    switch (hookOption) {
        case QMUIHookOptionBefore:
            self.beforeTokens  = [(self.beforeTokens  ? : @[]) arrayByAddingObject:token];
            break;
        case QMUIHookOptionAfter:
            self.afterTokens   = [(self.afterTokens   ? : @[]) arrayByAddingObject:token];
            break;
        case QMUIHookOptionInstead:
            self.insteadTokens = [(self.insteadTokens ? : @[]) arrayByAddingObject:token];
            break;
    }
}

- (void)removeToken:(QMUIHookToken *)token {
    switch (token.options) {
        case QMUIHookOptionBefore: {
            NSMutableArray *beforeTokens = [self.beforeTokens mutableCopy];
            [beforeTokens removeObject:token];
            self.beforeTokens = beforeTokens.copy;
        }
            break;
        case QMUIHookOptionAfter: {
            NSMutableArray *afterTokens = [self.afterTokens mutableCopy];
            [afterTokens removeObject:token];
            self.afterTokens = afterTokens.copy;
        }
            break;
        case QMUIHookOptionInstead: {
            NSMutableArray *insteadTokens = [self.insteadTokens mutableCopy];
            [insteadTokens removeObject:token];
            self.insteadTokens = insteadTokens.copy;
        }
            break;
    }
}

- (BOOL)hasTokens {
    return self.beforeTokens.count > 0 || self.insteadTokens.count > 0 || self.afterTokens.count > 0;
}

@end


@interface QMUIHookTemple : NSObject

+ (BOOL)hasTempleWithMethodSignature:(NSString *)methodSignature;

+ (id)getOverrideImplementationBlockWithOriginalIMPProvider:(IMP (^)(void))originalIMPProvider selector:(SEL)selector methodSignature:(NSString *)methodSignature;

@end

@implementation NSObject (QMUIHook)

static void __QMUIDidHookClass(Class class, SEL selector);
static NSString * __QMUIHookSelectorNameRecognizer(NSString *oriSelectorName);

static IMP qmui_getMsgForwardIMP(Class class, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
    #if !defined(__arm64__)
        Method method = class_getInstanceMethod(class, selector);
        const char *typeDescription = method_getTypeEncoding(method);
        if (typeDescription[0] == '{') {
            // 以下代码参考 JSPatch 的实现：
            //In some cases that returns struct, we should use the '_stret' API:
            //http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
            //NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
            NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:typeDescription];
            if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
                msgForwardIMP = (IMP)_objc_msgForward_stret;
            }
        }
    #endif
    return msgForwardIMP;
}

static SEL QMUI_backupSelectorFromOriginSelector(Class class, SEL originSel) {
    NSString *originSelName = NSStringFromSelector(originSel);
    NSString *originClassName = NSStringFromClass(class);
    if (!originSelName || !originClassName) {
        // 未注册过的 selector 是拿不到 String 的
        return NULL;
    }
    return NSSelectorFromString([NSString stringWithFormat:@"qmui_backup_%@_%@", originClassName , originSelName]);
}

static QMUIHookTokenContainer *QMUI_getContainerForObject(NSObject *self, SEL selector, BOOL create) {
    NSCParameterAssert(self);
    NSString *key = [NSString stringWithFormat:@"QMUIHookContainerKey_%@", NSStringFromSelector(selector)];
    QMUIHookTokenContainer *container = [self qmui_getBoundObjectForKey:key];
    if (!container && create) {
        container = [QMUIHookTokenContainer new];
        container.methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
        [self qmui_bindObject:container forKey:key];
    }
    return container;
}


static SEL QMUI_originalSelectorFromForwardInvocation(NSInvocation *invocation) {
    NSString *originalSelectorName = __QMUIHookSelectorNameRecognizer(NSStringFromSelector(invocation.selector));
    return NSSelectorFromString(originalSelectorName);
}

CG_INLINE void QMUI_hookedMethodWillCall(QMUIHookTokenContainer *container, QMUIHookContext *context) {
    if (!container) return;
    for (QMUIHookToken *toekn in container.beforeTokens) {
        QMUIHookContextBlock block = toekn.block;
        block(context);
    }
}

CG_INLINE void QMUI_hookedMethodCall(QMUIHookTokenContainer *container, QMUIHookContext *context, dispatch_block_t oriInvokeBlock) {
    if (container.insteadTokens > 0) {
        context.invokeBlock = oriInvokeBlock;
         for (QMUIHookToken *toekn in container.insteadTokens) {
             QMUIHookContextBlock block = toekn.block;
             block(context);
         }
    } else {
        oriInvokeBlock();
    }
}

CG_INLINE void QMUI_hookedMethodDidCall(QMUIHookTokenContainer *container, QMUIHookContext *context) {
    if (!container) return;
    for (QMUIHookToken *toekn in container.afterTokens) {
        QMUIHookContextBlock block = toekn.block;
        block(context);
    }
}

static void QMUIForwardInvocation(__unsafe_unretained id self, SEL selector, NSInvocation *invocation) {
//    NSLog(@"💎 QMUIForwardInvocation! 111 %@", NSStringFromSelector(invocation.selector));
    IMP (^originalIMPProvider)(void) = nil;
    Class forwardingClass = object_getClass(self);
    while (forwardingClass) {
        originalIMPProvider = [(id)forwardingClass qmui_getBoundObjectForKey:@"forwardInvocationOriginalIMPProvider"];
        if (originalIMPProvider) break;
        // 走到这里说明当前实例对象被使用了 object_setClass 修改 isa，导致 class 找不到原始的 forwardInvocation，此时应该用向 super class 寻找（比如先被 QMUI hook 再被 aspect hook）
        forwardingClass = class_getSuperclass(forwardingClass);
    }
    
    SEL originalSelector = QMUI_originalSelectorFromForwardInvocation(invocation);
    QMUIHookTokenContainer *container = QMUI_getContainerForObject(self, originalSelector, NO);
    QMUIHookContext *context = nil;
    if (container) {
        context = [QMUIHookContext contextWithInstance:self invocation:invocation];
    }

    SEL backupSelector = QMUI_backupSelectorFromOriginSelector(forwardingClass, originalSelector);
    IMP imp = class_getMethodImplementation(forwardingClass, backupSelector);
    dispatch_block_t invokeBlock = nil;
    if (imp == qmui_getMsgForwardIMP(forwardingClass, selector)) {
        // 来到这有两个可能：
        // 1. 业务本身没有实现该方法，但是重写了 reponse：可以响应该方法
        // 2. 先使用了 aspect hook 掉这个方法，然后再被 QMUI hook
        // 上述两种都需要调用被 QMUI hook 之前保存的那个 forwardInvocation: ，由原始的 forwardInvocation: 去处理
        invokeBlock = ^{
            ((void (*)(id, SEL, id))originalIMPProvider())(invocation.target, selector, invocation);
        };
    } else {
        // 使用 backupSelector 调用原始实现，这里会修改 _cmd
        invocation.selector = backupSelector;
        invokeBlock =  ^{
             [invocation invoke];
         };
    }
    QMUI_hookedMethodWillCall(container, context);
    QMUI_hookedMethodCall(container, context, invokeBlock);
    QMUI_hookedMethodDidCall(container, context);
}

static void QMUI_swizzleForwardInvocation(Class class) {
   [QMUIHelper executeBlock:^{
       OverrideImplementation(class, @selector(forwardInvocation:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
           [class qmui_bindObject:originalIMPProvider forKey:@"forwardInvocationOriginalIMPProvider"];
           return ^(id selfObject, NSInvocation *invocation) {
               QMUIForwardInvocation(selfObject, originCMD, invocation);
           };
       });
   } oncePerIdentifier:[NSString stringWithFormat:@"QMUI_swizzleForwardInvocation_%@", NSStringFromClass(class)]];
}

static bool QMUI_isClassHooked(Class class, SEL selector) {
    SEL backupSelector = QMUI_backupSelectorFromOriginSelector(class, selector);
    return HasOverrideSuperclassMethod(class, backupSelector);
}

static bool QMUI_hookClass(Class class, SEL selector) {
    // 1. swizzle Class 的 forwardInvocation:
    QMUI_swizzleForwardInvocation(class);
    // 2. 保存原始 IMP
    SEL backupSelector = QMUI_backupSelectorFromOriginSelector(class, selector);
    const char * typeEncoding = (char *)method_getTypeEncoding(class_getInstanceMethod(class, selector));
    if(!HasOverrideSuperclassMethod(class, backupSelector)) {
        IMP originalImp = class_getMethodImplementation(class, selector);
        class_addMethod(class, backupSelector, originalImp, typeEncoding);
    }
    // 3.把 selector 指向 _objc_msgForward
    IMP msgForwardIMP = qmui_getMsgForwardIMP(class, selector);
    class_replaceMethod(class, selector, msgForwardIMP, typeEncoding);
    __QMUIDidHookClass(class, selector);
    return true;
}

- (NSString *)typeEncodingStringByRemovingDigit:(const char *)typeEncoding {
    size_t strLength = strlen(typeEncoding);
    NSMutableString *typeEncodingString = [NSMutableString stringWithCapacity:strLength];
    for (NSInteger i = 0; i < strLength; i++) {
        unichar c = typeEncoding[i];
        if (!isdigit(c)) {
            [typeEncodingString appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    return typeEncodingString;
}

- (void)qmui_hookClassWithSelector:(SEL)selector {
    Class statedClass = self.class;
    const char *typeEncoding = (char *)method_getTypeEncoding(class_getInstanceMethod(statedClass, selector));
    NSString *qmuiSignature = [self typeEncodingStringByRemovingDigit:typeEncoding];
    if ([QMUIHookTemple hasTempleWithMethodSignature:qmuiSignature]) {
        // 有模板用模板 hook
        // TODO: Aspect Hook 后用模板 HOOK 只能生效一次
        NSString *key = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(statedClass), NSStringFromSelector(selector)];
        [QMUIHelper executeBlock:^{
            OverrideImplementation(statedClass, selector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return [QMUIHookTemple getOverrideImplementationBlockWithOriginalIMPProvider:originalIMPProvider selector:originCMD methodSignature:qmuiSignature];
            });
        } oncePerIdentifier:key];
        return;
    }
    
    // 没有模板 用消息转发
    if (!QMUI_isClassHooked(statedClass, selector)) {
        QMUI_hookClass(statedClass, selector);
        Class realClass = object_getClass(self);
        if (realClass != statedClass) {
            BOOL isKVOing = [NSStringFromClass(realClass) hasPrefix:@"NSKVONotifying_"];
            BOOL shouldHookRealClass = !isKVOing;
            if (shouldHookRealClass) {
                // 一般请下 realClass == statedClass，除非使用 object_setClass 改变 isa，这里为了兼容 Aspect，也需要 hook realClass（也就是带有 _Aspects_ 前缀的类）
                // 如果是 KVO 对象，则不能 hook realClass，否则 _NSSetObjectValueAndNotify 调用时 _cmd 被提前改变，会使用 KVO 失效
                // Aspect 本身不兼容 KVO ，所以一个对象如果被 KVO 了就不用去考虑兼容 Aspect 了
                QMUI_hookClass(realClass, selector);
            }
        }
    }
}

- (QMUIHookToken *)qmui_hookSelector:(SEL)selector beforeBlock:(QMUIHookContextBlock)block {
    return [self qmui_hookSelector:selector withOption:QMUIHookOptionBefore block:block];
}
- (QMUIHookToken *)qmui_hookSelector:(SEL)selector afterBlock:(QMUIHookContextBlock)block {
    return [self qmui_hookSelector:selector withOption:QMUIHookOptionAfter block:block];
}

- (QMUIHookToken *)qmui_hookSelector:(SEL)selector insteadBlock:(QMUIHookContextBlock)block {
    return [self qmui_hookSelector:selector withOption:QMUIHookOptionInstead block:block];
}

- (QMUIHookToken *)qmui_hookSelector:(SEL)selector withOption:(QMUIHookOption)option block:(QMUIHookContextBlock)block{
    if (![self respondsToSelector:selector]) {
        return nil;
    }
    [self qmui_hookClassWithSelector:selector];
    QMUIHookToken *token = [QMUIHookToken tokenWithSelector:selector object:self options:QMUIHookOptionAfter block:block];
    QMUIHookTokenContainer *container = QMUI_getContainerForObject(self, selector, YES);
    [container addToken:token withOptions:option];
    return token;
}


@end

#pragma mark - 兼容其他 Hook

static NSString * const AspectsForwardInvocationSelectorName = @"__aspects_forwardInvocation:";
static NSString * const AspectsMessagePrefix = @"aspects__";

static void __QMUIDidHookClass(Class class, SEL selector) {
    class_addMethod(class, NSSelectorFromString(AspectsForwardInvocationSelectorName), (IMP)QMUIForwardInvocation, "v@:@@");
    SEL aliasSelector = NSSelectorFromString([AspectsMessagePrefix stringByAppendingFormat:@"%@", NSStringFromSelector(selector)]);
    if (![class instancesRespondToSelector:aliasSelector]) {
        const char * typeEncoding = (char *)method_getTypeEncoding(class_getInstanceMethod(class, selector));
        class_addMethod(class, aliasSelector, qmui_getMsgForwardIMP(class, selector), typeEncoding);
    }
}

static NSString * __QMUIHookSelectorNameRecognizer(NSString *oriSelectorName) {
    if ([oriSelectorName hasPrefix:AspectsMessagePrefix]) {
        return [oriSelectorName stringByReplacingOccurrencesOfString:AspectsMessagePrefix withString:@""];
    }
    return oriSelectorName;
}


#pragma mark - Template


@implementation QMUIHookTemple

+ (BOOL)hasTempleWithMethodSignature:(NSString *)methodSignature {
    NSSet *set = [NSSet setWithObjects:@"v@:", @"vB:", @"@@:", @"v@:@", @"@@:@", nil];
    return !![set containsObject:methodSignature];
}

#define QMUIVoidArg1(_Type1) ^(id selfObject, _Type1 arg1) {\
     QMUIHookTokenContainer *container = QMUI_getContainerForObject(selfObject, selector, NO);\
     if (!container) {\
         return ((void (*)(id, SEL, _Type1))originalIMPProvider())(selfObject, selector, arg1);\
     }\
     __block id _selfObject = selfObject;\
     __block SEL _selector = selector;\
     __block _Type1 _arg1 = arg1;\
     QMUIHookContext *context = nil;\
    [self setInalInvocationBlockForContext:&context container:container selfObject:_selfObject selfObjectPtr:&_selfObject selector:_selector selectorPtr:&_selector returnPtr:NULL arg1:&_arg1];\
     QMUI_hookedMethodWillCall(container, context);\
     QMUI_hookedMethodCall(container, context, ^{\
         ((void (*)(id, SEL, _Type1))originalIMPProvider())(_selfObject, _selector, _arg1);\
     });\
    QMUI_hookedMethodDidCall(container, context);\
};\

#define QMUIRutureTypeArg0(_reruenType) ^id(id selfObject) { \
    QMUIHookTokenContainer *container = QMUI_getContainerForObject(selfObject, selector, NO);\
    if (!container) {\
        return ((id (*)(_reruenType, SEL))originalIMPProvider())(selfObject, selector);\
    }\
    __block id _selfObject = selfObject;\
    __block SEL _selector = selector;\
    __block _reruenType _returnValue = nil;\
     QMUIHookContext *context = nil;\
    [self setInalInvocationBlockForContext:&context container:container selfObject:_selfObject selfObjectPtr:&_selfObject selector:_selector selectorPtr:&_selector returnPtr:&_returnValue arg1:NULL];\
     QMUI_hookedMethodWillCall(container, context);\
     QMUI_hookedMethodCall(container, context, ^{\
          _returnValue = ((_reruenType (*)(id, SEL))originalIMPProvider())(_selfObject, _selector);\
     });\
    QMUI_hookedMethodDidCall(container, context);\
    return _returnValue;\
};\

#define QMUIRutureTypeArg1(_reruenType, _Type1) ^id(id selfObject, _Type1 arg1) { \
    QMUIHookTokenContainer *container = QMUI_getContainerForObject(selfObject, selector, NO);\
    if (!container) {\
        return ((id (*)(_reruenType, SEL, _Type1))originalIMPProvider())(selfObject, selector, arg1);\
    }\
    __block id _selfObject = selfObject;\
    __block SEL _selector = selector;\
    __block _Type1 _arg1 = arg1;\
    __block _reruenType _returnValue = nil;\
     QMUIHookContext *context = nil;\
    [self setInalInvocationBlockForContext:&context container:container selfObject:_selfObject selfObjectPtr:&_selfObject selector:_selector selectorPtr:&_selector returnPtr:&_returnValue arg1:&_arg1];\
     QMUI_hookedMethodWillCall(container, context);\
     QMUI_hookedMethodCall(container, context, ^{\
          _returnValue = ((_reruenType (*)(id, SEL, _Type1))originalIMPProvider())(_selfObject, _selector, _arg1);\
     });\
    QMUI_hookedMethodDidCall(container, context);\
    return _returnValue;\
};\

+ (void)setInalInvocationBlockForContext:(QMUIHookContext **)contextPtr container:(QMUIHookTokenContainer *)container selfObject:(id)selfObject selfObjectPtr:(void *)selfObjectPtr selector:(SEL)selector selectorPtr:(void *)selectorPtr returnPtr:(void *)retValuePtr arg1:(void *)arg1Ptr {

    QMUIHookContext *context = [QMUIHookContext contextWithInstance:nil invocation:nil];
    context.getArgumentBlock = ^(void *argumentLocation, NSInteger idx) {
        if (!argumentLocation || idx >= container.methodSignature.numberOfArguments) {
            return;
        }
        const char *type = [container.methodSignature getArgumentTypeAtIndex:idx];
        NSUInteger argSize;
        NSGetSizeAndAlignment(type, &argSize, NULL);
        if (idx == 0) {
            memcpy(argumentLocation, selfObjectPtr, argSize);
        } else if (idx == 1) {
            memcpy(argumentLocation, selectorPtr, argSize);
        } else if (idx == 2 && arg1Ptr) {
            memcpy(argumentLocation, arg1Ptr, argSize);
        }
    };
    context.setArgumentBlock = ^(void *argumentLocation, NSInteger idx) {
        if (!argumentLocation || idx >= container.methodSignature.numberOfArguments) {
            return;
        }
        const char *type = [container.methodSignature getArgumentTypeAtIndex:idx];
        NSUInteger argSize;
        NSGetSizeAndAlignment(type, &argSize, NULL);
        if (idx == 0) {
            memcpy(selfObjectPtr, argumentLocation, argSize);
        } else if (idx == 1) {
            memcpy(selectorPtr, argumentLocation, argSize);
        } else if (idx == 2 && arg1Ptr) {
            memcpy(arg1Ptr, argumentLocation, argSize);
        }
    };
    if (retValuePtr) {
        context.setReturnValueBlock = ^(void *retLoc) {
            memcpy(retValuePtr, retLoc, container.methodSignature.methodReturnLength);
        };
        context.getReturnValueBlock = ^(void *retLoc) {
            memcpy(retLoc, retValuePtr, container.methodSignature.methodReturnLength);
        };
    }
    *contextPtr = context;
}

+ (id)getOverrideImplementationBlockWithOriginalIMPProvider:(IMP (^)(void))originalIMPProvider selector:(SEL)selector methodSignature:(NSString *)methodSignature {
    // void
     if ([methodSignature isEqualToString:@"v@:"]) { // - (void)func;
         id block = ^(id selfObject) {
             QMUIHookTokenContainer *container = QMUI_getContainerForObject(selfObject, selector, NO);
             if (!container) {
                 return ((void (*)(id, SEL))originalIMPProvider())(selfObject, selector);
             }
             __block id _selfObject = selfObject;
             __block SEL _selector = selector;
             QMUIHookContext *context = nil;
             [self setInalInvocationBlockForContext:&context container:container selfObject:_selfObject selfObjectPtr:&_selfObject selector:_selector selectorPtr:&_selector returnPtr:NULL arg1:NULL];
             QMUI_hookedMethodWillCall(container, context);
             QMUI_hookedMethodCall(container, context, ^{
                 return ((void (*)(id, SEL))originalIMPProvider())(_selfObject, _selector);
             });
            QMUI_hookedMethodDidCall(container, context);
        };
        return block;
    }
    // void & single arg
     else if ([methodSignature isEqualToString:@"v@:B"]) {  // - (void)setBool:(BOOL)bool;
        return QMUIVoidArg1(BOOL);
    }
     else if ([methodSignature isEqualToString:@"v@:@"]) {  // - (void)setId:(id)id;
        return QMUIVoidArg1(id);
    }
    // single return value
     else if ([methodSignature isEqualToString:@"@@:"]) {   // - (id)idValue;
       return QMUIRutureTypeArg0(id);
     } else if ([methodSignature isEqualToString:@"@@:@"]) {
         return QMUIRutureTypeArg1(id, id);
     }
    return nil;
}

@end
