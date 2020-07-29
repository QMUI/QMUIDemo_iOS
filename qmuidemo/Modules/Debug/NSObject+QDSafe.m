//
//  NSObject+QDSafe.m
//  qmuidemo
//
//  Created by ziezheng on 2020/6/12.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "NSObject+QDSafe.h"

@implementation NSObject (QDSafe)

void swizzleInstanceMethod(Class cls, SEL origSelector, SEL newSelector)
{
    if (!cls) {
        return;
    }
    /* if current class not exist selector, then get super*/
    Method originalMethod = class_getInstanceMethod(cls, origSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, newSelector);
    
    /* add selector if not exist, implement append with method */
    if (class_addMethod(cls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(cls,
                            newSelector,
                            class_replaceMethod(cls,
                                                origSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

+ (void)load2
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        swizzleInstanceMethod([NSObject class], @selector(methodSignatureForSelector:), @selector(hookMethodSignatureForSelector:));
        swizzleInstanceMethod([NSObject class], @selector(forwardInvocation:), @selector(hookForwardInvocation:));
    });
}

- (NSMethodSignature*)hookMethodSignatureForSelector:(SEL)aSelector {
    /* 如果 当前类有methodSignatureForSelector实现，NSObject的实现直接返回nil
     * 子类实现如下：
     *          NSMethodSignature* sig = [super methodSignatureForSelector:aSelector];
     *          if (!sig) {
     *              //当前类的methodSignatureForSelector实现
     *              //如果当前类的methodSignatureForSelector也返回nil
     *          }
     *          return sig;
     */
    NSMethodSignature* sig = [self hookMethodSignatureForSelector:aSelector];
    if (!sig){
        if (class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:))
            != class_getMethodImplementation(self.class, @selector(methodSignatureForSelector:)) ){
            return nil;
        }
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return sig;
}

- (void)hookForwardInvocation:(NSInvocation*)invocation
{
    NSString* info = [NSString stringWithFormat:@"unrecognized selector [%@] sent to %@", NSStringFromSelector(invocation.selector), NSStringFromClass(self.class)];
    NSLog(@"%@",info);
}

@end
