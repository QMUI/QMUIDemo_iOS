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
        
        OverrideImplementation([UINavigationBar class], @selector(setQmui_effectForegroundColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, UIColor *firstArgv) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
                
                if (firstArgv) {
                    selfObject.qmui_smoothEffectAlpha = -1;
                }
            };
        });
        
        // 同步假 bar 的效果
        SEL setterSelector = NSSelectorFromString(@"setQmuinb_copyStylesToBar:");
        NSAssert([UINavigationBar instancesRespondToSelector:setterSelector], @"请检查 UINavigationBar+Transtion 里是否没提供 setQmuinb_copyStylesToBar: 方法？");
        OverrideImplementation(UINavigationBar.class, setterSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, UINavigationBar *copyStylesToBar) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UINavigationBar *);
                originSelectorIMP = (void (*)(id, SEL, UINavigationBar *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, copyStylesToBar);
                
                copyStylesToBar.qmui_smoothEffect = selfObject.qmui_smoothEffect;
                copyStylesToBar.qmui_smoothEffectAlpha = selfObject.qmui_smoothEffectAlpha;
            };
        });
    });
}

static char kAssociatedObjectKey_smoothEffect;
- (void)setQmui_smoothEffect:(BOOL)qmui_smoothEffect {
    BOOL valueChanged = qmui_smoothEffect != self.qmui_smoothEffect;
    if (!valueChanged) return;
    if (qmui_smoothEffect) {
        
        UIImage *backgroundImage = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
        if (backgroundImage && !CGRectIsEmpty(self.frame)) {// 假 bar 转场时有一瞬间会走到这里，但那个时候 frame 还是0，所以屏蔽这个情况
            QMUILogWarn(@"QMUISmoothEffect", @"试图开启 qmui_smoothEffect 但由于当前 UINavigationBar 存在 backgroundImage 所以无法显示磨砂，%@, backgroundImage = %@", self, backgroundImage);
            return;
        }
        
        UIColor *barTintColor = self.barTintColor;
        if (barTintColor && barTintColor.qmui_alpha > 0 && !CGRectIsEmpty(self.frame)) {// 假 bar 转场时有一瞬间会走到这里，但那个时候 frame 还是0，所以屏蔽这个情况
            // 只是提示，不用 return，因为影响比较小
            QMUILogWarn(@"QMUISmoothEffect", @"开启 qmui_smoothEffect 的 UINavigationBar 同时存在 barTintColor，可能会导致在 iOS 15 上的磨砂效果比 iOS 14 及以前的版本要弱，因为前景色多了一层 barTintColor。bar = %@, barTintColor = %@", self, barTintColor);
        }
    }
    
    objc_setAssociatedObject(self, &kAssociatedObjectKey_smoothEffect, @(qmui_smoothEffect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (qmui_smoothEffect) {
        self.qmui_effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        [self qmuinbe_setEffectForegroundColorAutomatically];
    } else {
        self.qmui_effect = nil;
    }
}

- (BOOL)qmui_smoothEffect {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_smoothEffect)) boolValue];
}

static char kAssociatedObjectKey_smoothEffectAlpha;
- (void)setQmui_smoothEffectAlpha:(CGFloat)smoothEffectAlpha {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_smoothEffectAlpha, @(smoothEffectAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self qmuinbe_setEffectForegroundColorAutomatically];
}

- (CGFloat)qmui_smoothEffectAlpha {
    NSNumber *value = ((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_smoothEffectAlpha));
    if (!value) {
        // 默认值
        return 0.7;
    }
    return [value qmui_CGFloatValue];
}

- (void)qmuinbe_setEffectForegroundColorAutomatically {
    // 自动设置完一次就不会再更新了，因为在上面 hook 逻辑里会把 alpha 置为-1，就不会再走进来这个条件
    if (self.qmui_smoothEffectAlpha >= 0) {
        UINavigationController *nav = (UINavigationController *)self.qmui_viewController;
        if ([nav isKindOfClass:UINavigationController.class]) {
            UIViewController *vc = nav.topViewController;
            if (vc.isViewLoaded) {
                UIColor *color = vc.view.backgroundColor;
                color = [color colorWithAlphaComponent:self.qmui_smoothEffectAlpha];
                self.qmui_effectForegroundColor = color;
            }
        }
    }
}

@end
