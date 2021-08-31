//
//  UINavigationBar+QMUISmoothEffect.m
//  QMUI
//
//  Created by MoLice on 2020/J/14.
//  Copyright © 2020 rdgz. All rights reserved.
//

#import "UINavigationBar+QMUISmoothEffect.h"

@implementation UINavigationBar (QMUISmoothEffect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        void (^updateBarBackgroundBlock)(UIView *) = ^void(UIView *selfObject) {
            if ([selfObject.superview isKindOfClass:UINavigationBar.class]) {
                UINavigationBar *navigationBar = (UINavigationBar *)selfObject.superview;
                if (navigationBar.qmui_smoothEffect) {
                    [navigationBar qmuinbe_updateBackgroundSmoothEffect];
                }
            }
        };
        OverrideImplementation(NSClassFromString(@"_UIBarBackground"), @selector(didAddSubview:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, UIView *subview) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIView *);
                originSelectorIMP = (void (*)(id, SEL, UIView *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, subview);
                
                updateBarBackgroundBlock(selfObject);
            };
        });
        
        OverrideImplementation(NSClassFromString(@"_UIBarBackground"), @selector(didMoveToSuperview), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject) {
                
                // call super
                void (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD);
                
                updateBarBackgroundBlock(selfObject);
            };
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([UINavigationBar class], @selector(setBarTintColor:), UIColor *, ^(UINavigationBar *navigationBar, UIColor *barTintColor) {
            if (navigationBar.qmui_smoothEffect) {
                [navigationBar qmuinbe_updateBackgroundSmoothEffect];
            }
        });
        
        SEL selector = NSSelectorFromString(@"replaceStyleForNavigationBar:withNavigationBar:");
        NSAssert([UIViewController respondsToSelector:selector], @"请检查 UINavigationController+NavigationBarTransition 里的 replaceStyleForNavigationBar:withNavigationBar: 是不是没了");
        OverrideImplementation(object_getClass([UIViewController class]), selector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject, UINavigationBar *firstArgv, UINavigationBar *secondArgv) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UINavigationBar *, UINavigationBar *);
                originSelectorIMP = (void (*)(id, SEL, UINavigationBar *, UINavigationBar *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
                
                firstArgv.qmui_smoothEffect = secondArgv.qmui_smoothEffect;
            };
        });
        
        OverrideImplementation(NSClassFromString(@"_QMUITransitionNavigationBar"), NSSelectorFromString(@"setOriginalNavigationBar:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, UINavigationBar *firstArgv) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UINavigationBar *);
                originSelectorIMP = (void (*)(id, SEL, UINavigationBar *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
                
                selfObject.qmui_smoothEffect = firstArgv.qmui_smoothEffect;
            };
        });
    });
}

- (void)qmuinbe_updateBackgroundSmoothEffect {
    [self.qmui_backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:UIVisualEffectView.class]) {// shadowView 也是一个 UIVisualEffect 的子类，所以这里用 isMemberOfClass 而不是 isKindOfClass
            UIVisualEffectView *effectView = (UIVisualEffectView *)obj;
            if (self.qmui_smoothEffect && !effectView.effect) {
                // push/pop 转场时不能修改 effect 属性，所以简单做个保护，因为一般都在 push/pop 前就已经走到这里了
                effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            }
            effectView.qmui_foregroundColor = self.qmui_smoothEffect ? self.barTintColor : nil;
        }
    }];
}

static char kAssociatedObjectKey_smoothEffect;
- (void)setQmui_smoothEffect:(BOOL)qmui_smoothEffect {
    BOOL valueChanged = qmui_smoothEffect != self.qmui_smoothEffect;
    if (!valueChanged) return;
    if (qmui_smoothEffect && [self backgroundImageForBarMetrics:UIBarMetricsDefault]) return;// 有 backgroundImage 则必定无法显示磨砂，此时不允许打开 qmui_smoothEffect
    
    objc_setAssociatedObject(self, &kAssociatedObjectKey_smoothEffect, @(qmui_smoothEffect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self qmuinbe_updateBackgroundSmoothEffect];
}

- (BOOL)qmui_smoothEffect {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_smoothEffect)) boolValue];
}

@end
