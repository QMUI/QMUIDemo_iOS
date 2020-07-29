//
//  UINavigationItem+QMUIBottomAccessoryView.m
//  qmuidemo
//
//  Created by MoLice on 2020/7/20.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "UINavigationItem+QMUIBottomAccessoryView.h"

@interface UINavigationBar (QMUIBottomAccessoryView)

// 对于开启了转场导航栏效果优化（例如配置表 AutomaticCustomNavigationBarTransitionStyle 为 YES）的情况，转场过程中会添加一条复制了目标 bar 所有样式的假 UINavigationBar，如果目标 bar 带有 qmuibav_bottomAccessoryView 则 backgroundView 里的 effectView 高度需要变高，但 qmuibav_bottomAccessoryView 是 add 在目标 bar 上而不是同时也 add 到假 bar 上，为了让假 bar 也能拿到 effectView 需要变高的值，这里通过 block 返回一个值（而不是通过 bar.qmuibav_bottomAccessoryView 取高度）
@property(nonatomic, copy) CGFloat (^qmuibav_backgroundEffectViewExtendBottomBlock)(void);
@property(nonatomic, strong) __kindof UIView *qmuibav_bottomAccessoryView;

- (void)setQmuibav_bottomAccessoryView:(UIView *)qmuibav_bottomAccessoryView animated:(BOOL)animated;// 前置声明，让 UINavigationItem 里能访问到
@end

@implementation UINavigationItem (QMUIBottomAccessoryView)

+ (void)qmuibav_swizzleMethods {
    CGFloat (^navigationBarMaxYBlock)(UIViewController *, CGFloat) = ^CGFloat(UIViewController *selfObject, CGFloat originReturnValue) {
        if (originReturnValue > 0 && selfObject.navigationItem.qmui_bottomAccessoryView) {
            return originReturnValue + CGRectGetHeight(selfObject.navigationItem.qmui_bottomAccessoryView.frame);
        }
        return originReturnValue;
    };
    
    void (^updateBottomAccessoryViewBlock)(UINavigationBar *, UINavigationItem *, BOOL) = ^void(UINavigationBar *navigationBar, UINavigationItem *navigationItem, BOOL animated) {
        if (navigationBar.qmuibav_bottomAccessoryView != navigationItem.qmui_bottomAccessoryView) {
            [navigationBar setQmuibav_bottomAccessoryView:navigationItem.qmui_bottomAccessoryView animated:animated];
        }
    };
    void (^pushNavigationItemBlock)(UINavigationBar *, UINavigationItem *, BOOL) = ^(UINavigationBar *navigationBar, UINavigationItem *navigationItem, BOOL animated) {
        updateBottomAccessoryViewBlock(navigationBar, navigationItem, animated);
    };
    UINavigationItem *(^popNavigationItemWithTransitionBlock)(UINavigationBar *, NSInteger, id) = ^UINavigationItem *(UINavigationBar *navigationBar, NSInteger transition, UINavigationItem *originReturnValue) {
        updateBottomAccessoryViewBlock(navigationBar, navigationBar.topItem, transition > 0);
        return originReturnValue;
    };
    void (^setItemsBlock)(UINavigationBar *, NSArray<UINavigationItem *> *, BOOL) = ^(UINavigationBar *navigationBar, NSArray<UINavigationItem *> *items, BOOL animated) {
        updateBottomAccessoryViewBlock(navigationBar, items.lastObject, animated);
    };
    void (^updateTopItemBlock)(UINavigationBar *, UINavigationItem *, BOOL) = ^(UINavigationBar *navigationBar, UINavigationItem *navigationItem, BOOL animated) {
        if (navigationBar.topItem == navigationItem) {// 在 pop 的时候如果前一个界面在 viewWillAppear: 里修改 navigationItem，则会先触发这个 block，再触发 pop block，导致没有动画，所以做一个保护
            updateBottomAccessoryViewBlock(navigationBar, navigationItem, animated);
        }
    };
    ExtendImplementationOfNonVoidMethodWithoutArguments([UIViewController class], @selector(qmui_navigationBarMaxYInViewCoordinator), CGFloat, navigationBarMaxYBlock);
    
    ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationBar class], @selector(pushNavigationItem:animated:), UINavigationItem *, BOOL, pushNavigationItemBlock);
    ExtendImplementationOfNonVoidMethodWithSingleArgument([UINavigationBar class], NSSelectorFromString(@"_popNavigationItemWithTransition:"), NSInteger, id, popNavigationItemWithTransitionBlock);
    ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationBar class], @selector(setItems:animated:), NSArray<UINavigationItem *> *, BOOL, setItemsBlock);
    
    // 在收到 UINavigationItem 要更新当前 item 的消息后会通过这个方法来刷新
    ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationBar class], NSSelectorFromString(@"_updateContentIfTopItem:animated:"), UINavigationItem *, BOOL, updateTopItemBlock);
    
    OverrideImplementation(NSClassFromString(@"_QMUITransitionNavigationBar"), NSSelectorFromString(@"setOriginalNavigationBar:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^(UINavigationBar *selfObject, UINavigationBar *originalNavigationBar) {
            
            // call super
            void (*originSelectorIMP)(id, SEL, UINavigationBar *);
            originSelectorIMP = (void (*)(id, SEL, UINavigationBar *))originalIMPProvider();
            originSelectorIMP(selfObject, originCMD, originalNavigationBar);
            
            selfObject.qmuibav_backgroundEffectViewExtendBottomBlock = originalNavigationBar.qmuibav_backgroundEffectViewExtendBottomBlock;
            selfObject.qmui_backgroundView.qmui_layoutSubviewsBlock = originalNavigationBar.qmui_backgroundView.qmui_layoutSubviewsBlock;
        };
    });
}

static char kAssociatedObjectKey_bottomAccessoryView;
- (void)setQmui_bottomAccessoryView:(__kindof UIView *)qmui_bottomAccessoryView {
    if (qmui_bottomAccessoryView) {
        [QMUIHelper executeBlock:^{
            [self.class qmuibav_swizzleMethods];
        } oncePerIdentifier:[NSString stringWithFormat:@"QMUIBottomAccessoryView %@", NSStringFromSelector(@selector(qmuibav_swizzleMethods))]];
    }
    
    objc_setAssociatedObject(self, &kAssociatedObjectKey_bottomAccessoryView, qmui_bottomAccessoryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 系统在修改了 UINavigationItem.rightBarButtonItem/titleView 等属性后会通过这个私有方法去通知 navigationBar 刷新内部的按钮，这里也借助这个方法在 navigationBar 内部刷新 bottomAccessoryView
    BOOL animated = YES;
    [self qmui_performSelector:NSSelectorFromString(@"updateNavigationBarButtonsAnimated:") withArguments:&animated, nil];
}

- (__kindof UIView *)qmui_bottomAccessoryView {
    return (UIView *)objc_getAssociatedObject(self, &kAssociatedObjectKey_bottomAccessoryView);
}

@end

@implementation UINavigationBar (QMUIBottomAccessoryView)

static char kAssociatedObjectKey_accessoryView;
- (void)setQmuibav_bottomAccessoryView:(UIView *)qmuibav_bottomAccessoryView animated:(BOOL)animated {
    BOOL prefersToShow = !self.qmuibav_bottomAccessoryView && qmuibav_bottomAccessoryView;
    BOOL prefersToHide = self.qmuibav_bottomAccessoryView && !qmuibav_bottomAccessoryView;
    BOOL shouldAnimate = animated && (prefersToShow || prefersToHide);// 只有从无到有或从有到无才需要动画，本来就有的，不管前后是否一致，都不需要动画呈现
    
    self.qmuibav_backgroundEffectViewExtendBottomBlock = qmuibav_bottomAccessoryView ? ^CGFloat{
        return CGRectGetHeight(qmuibav_bottomAccessoryView.frame);
    } : nil;
    
    if (!self.qmui_backgroundView.qmui_layoutSubviewsBlock) {
        self.qmui_backgroundView.qmui_layoutSubviewsBlock = ^(__kindof UIView * _Nonnull selfObject) {
            UINavigationBar *navigationBar = (UINavigationBar *)selfObject.superview;
            if (!navigationBar || ![navigationBar isKindOfClass:UINavigationBar.class]) {
                return;
            }
            
            UIVisualEffectView *effectView = nil;
            if (@available(iOS 13.0, *)) {
                effectView = [selfObject qmui_valueForKey:@"_effectView1"];
            } else {
                effectView = [selfObject qmui_valueForKey:@"_backgroundEffectView"];
            }
            if (navigationBar.qmuibav_backgroundEffectViewExtendBottomBlock) {
                if (effectView) {
                    effectView.frame = CGRectSetHeight(effectView.frame, CGRectGetHeight(selfObject.bounds) + navigationBar.qmuibav_backgroundEffectViewExtendBottomBlock());
                }
            }
        };
    }
    if (!self.qmui_layoutSubviewsBlock) {
        self.qmui_layoutSubviewsBlock = ^(UINavigationBar * _Nonnull navigationBar) {
            UIView *accessoryView = navigationBar.qmuibav_bottomAccessoryView;
            if (accessoryView) {
                accessoryView.qmui_frameApplyTransform = CGRectMake(0, CGRectGetHeight(accessoryView.superview.bounds), CGRectGetWidth(accessoryView.superview.bounds), CGRectGetHeight(accessoryView.frame));
                [accessoryView.superview bringSubviewToFront:accessoryView];
                CGRect bounds = navigationBar.bounds;
                CGRect boundsWithAccessoryView = CGRectUnion(bounds, accessoryView.frame);
                UIEdgeInsets outsideEdge = UIEdgeInsetsMake(MIN(CGRectGetMinY(bounds) - CGRectGetMinY(boundsWithAccessoryView), 0),
                                                            MIN(CGRectGetMinX(bounds) - CGRectGetMinX(boundsWithAccessoryView), 0),
                                                            MIN(CGRectGetMaxY(bounds) - CGRectGetMaxY(boundsWithAccessoryView), 0),
                                                            MIN(CGRectGetMaxX(bounds) - CGRectGetMaxX(boundsWithAccessoryView), 0));
                navigationBar.qmui_outsideEdge = outsideEdge;
            } else {
                navigationBar.qmui_outsideEdge = UIEdgeInsetsZero;
            }
        };
    }
    
    if (shouldAnimate) {
        if (prefersToShow) {
            objc_setAssociatedObject(self, &kAssociatedObjectKey_accessoryView, qmuibav_bottomAccessoryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self addSubview:qmuibav_bottomAccessoryView];
            [self.qmui_backgroundView setNeedsLayout];
            [self.qmui_backgroundView layoutIfNeeded];
            [self setNeedsLayout];
            [self layoutIfNeeded];
            qmuibav_bottomAccessoryView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(qmuibav_bottomAccessoryView.frame));
            qmuibav_bottomAccessoryView.alpha = 0;
            [UIView animateWithDuration:.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                qmuibav_bottomAccessoryView.transform = CGAffineTransformIdentity;
                qmuibav_bottomAccessoryView.alpha = 1;
            } completion:nil];
        } else {
            [UIView animateWithDuration:.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                [self.qmui_backgroundView setNeedsLayout];
                [self.qmui_backgroundView layoutIfNeeded];
                [self setNeedsLayout];
                [self layoutIfNeeded];
                self.qmuibav_bottomAccessoryView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.qmuibav_bottomAccessoryView.frame));
                self.qmuibav_bottomAccessoryView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.qmuibav_bottomAccessoryView removeFromSuperview];
                self.qmuibav_bottomAccessoryView.transform = CGAffineTransformIdentity;
                self.qmuibav_bottomAccessoryView.alpha = 1;
                [self.qmuibav_bottomAccessoryView removeFromSuperview];
                objc_setAssociatedObject(self, &kAssociatedObjectKey_accessoryView, qmuibav_bottomAccessoryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }];
        }
    } else {
        // 这个分支包含无动画、有动画但 setter 前和 setter 后都有存在 bottomAccessoryView
        if (self.qmuibav_bottomAccessoryView != qmuibav_bottomAccessoryView) {
            [self.qmuibav_bottomAccessoryView removeFromSuperview];
            [self addSubview:qmuibav_bottomAccessoryView];
        }
        objc_setAssociatedObject(self, &kAssociatedObjectKey_accessoryView, qmuibav_bottomAccessoryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self.qmui_backgroundView setNeedsLayout];
        [self setNeedsLayout];
    }
}

- (void)setQmuibav_bottomAccessoryView:(__kindof UIView *)qmuibav_bottomAccessoryView {
    [self setQmuibav_bottomAccessoryView:qmuibav_bottomAccessoryView animated:NO];
}

- (__kindof UIView *)qmuibav_bottomAccessoryView {
    return (UIView *)objc_getAssociatedObject(self, &kAssociatedObjectKey_accessoryView);
}

static char kAssociatedObjectKey_backgroundEffectViewExtendBottomBlock;
- (void)setQmuibav_backgroundEffectViewExtendBottomBlock:(CGFloat (^)(void))qmuibav_backgroundEffectViewExtendBottomBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_backgroundEffectViewExtendBottomBlock, qmuibav_backgroundEffectViewExtendBottomBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.transitionNavigationBar) {
        self.transitionNavigationBar.qmuibav_backgroundEffectViewExtendBottomBlock = qmuibav_backgroundEffectViewExtendBottomBlock;
    }
}

- (CGFloat (^)(void))qmuibav_backgroundEffectViewExtendBottomBlock {
    return (CGFloat (^)(void))objc_getAssociatedObject(self, &kAssociatedObjectKey_backgroundEffectViewExtendBottomBlock);
}

@end
