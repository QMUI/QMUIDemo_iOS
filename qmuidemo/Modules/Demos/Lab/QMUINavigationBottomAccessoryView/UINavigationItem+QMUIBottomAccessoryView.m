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
    
    #pragma mark - qmui_navigationBarMaxYInViewCoordinator
    OverrideImplementation([UIViewController class], @selector(qmui_navigationBarMaxYInViewCoordinator), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^CGFloat(UIViewController *selfObject) {
            // call super
            CGFloat (*originSelectorIMP)(id, SEL);
            originSelectorIMP = (CGFloat (*)(id, SEL))originalIMPProvider();
            CGFloat result = originSelectorIMP(selfObject, originCMD);
            
            if (result > 0 && selfObject.navigationItem.qmui_bottomAccessoryView) {
                return result + CGRectGetHeight(selfObject.navigationItem.qmui_bottomAccessoryView.frame);
            }
            return result;
        };
    });
    
    #pragma mark - TransitionNavigationBar setOriginalNavigationBar:
    
    // 在开启假 bar 转场效果优化时把 bottomAccessoryView 也同步复制到假 bar
    SEL setterSelector = NSSelectorFromString(@"setQmuinb_copyStylesToBar:");
    NSAssert([UINavigationBar instancesRespondToSelector:setterSelector], @"请检查 UINavigationBar+Transtion 里是否没提供 setQmuinb_copyStylesToBar: 方法？");
    OverrideImplementation(UINavigationBar.class, setterSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^(UINavigationBar *selfObject, UINavigationBar *copyStylesToBar) {
            
            // call super
            void (*originSelectorIMP)(id, SEL, UINavigationBar *);
            originSelectorIMP = (void (*)(id, SEL, UINavigationBar *))originalIMPProvider();
            originSelectorIMP(selfObject, originCMD, copyStylesToBar);
            
            copyStylesToBar.qmuibav_backgroundEffectViewExtendBottomBlock = selfObject.qmuibav_backgroundEffectViewExtendBottomBlock;
            copyStylesToBar.qmui_backgroundView.qmui_layoutSubviewsBlock = selfObject.qmui_backgroundView.qmui_layoutSubviewsBlock;
        };
    });
    
    #pragma mark - updateBottomAccessoryViewBlock
    void (^updateBottomAccessoryViewBlock)(UINavigationBar *, UINavigationItem *, BOOL) = ^void(UINavigationBar *navigationBar, UINavigationItem *navigationItem, BOOL animated) {
        if (navigationBar.qmuibav_bottomAccessoryView != navigationItem.qmui_bottomAccessoryView) {
            [navigationBar setQmuibav_bottomAccessoryView:navigationItem.qmui_bottomAccessoryView animated:animated];
        }
    };
    
    #pragma mark - UINavigationBar pushNavigationItem:animated:
    // push 界面时更新 navigationItem
    void (^pushNavigationItemBlock)(UINavigationBar *, UINavigationItem *, BOOL) = ^(UINavigationBar *navigationBar, UINavigationItem *navigationItem, BOOL animated) {
        updateBottomAccessoryViewBlock(navigationBar, navigationItem, animated);
    };
    
    #pragma mark - UINavigationBar _popNavigationItemWithTransition:
    // pop 界面时更新 navigationItem，系统没有调用 public API `popNavigationItemAnimated:`，所以只能用私有 API
    UINavigationItem *(^popNavigationItemWithTransitionBlock)(UINavigationBar *, NSInteger, id) = ^UINavigationItem *(UINavigationBar *navigationBar, NSInteger transition, UINavigationItem *originReturnValue) {
        updateBottomAccessoryViewBlock(navigationBar, navigationBar.topItem, transition > 0);
        return originReturnValue;
    };
    
    #pragma mark - UINavigationBar setItems:animated:
    // 通过 setItems 直接修改 navigationItem 堆栈时更新 navigationItem
    void (^setItemsBlock)(UINavigationBar *, NSArray<UINavigationItem *> *, BOOL) = ^(UINavigationBar *navigationBar, NSArray<UINavigationItem *> *items, BOOL animated) {
        updateBottomAccessoryViewBlock(navigationBar, items.lastObject, animated);
    };
    
    #pragma mark - UINavigationBar _updateContentIfTopItem:animated:
    // 在 viewWillAppear: 等已经显示完 navigationBar 之后的时机再去修改 navigationItem 时，系统会通过这个私有 API 来刷新当前的 navigationItem
    void (^updateTopItemBlock)(UINavigationBar *, UINavigationItem *, BOOL) = ^(UINavigationBar *navigationBar, UINavigationItem *navigationItem, BOOL animated) {
        if (navigationBar.topItem == navigationItem) {// 在 pop 的时候如果前一个界面在 viewWillAppear: 里修改 navigationItem，则会先触发这个 block，再触发 pop block，导致没有动画，所以做一个保护
            updateBottomAccessoryViewBlock(navigationBar, navigationItem, animated);
        }
    };
    
    #pragma mark - UINavigationBar didMoveToSuperview
    // 例如 A 不显示 bottomAccessoryView，在 A 里 present UISearchController，此时 navigationBar 会从 View 层级树里被移除，在 searchController 里进入界面 B，B 显示 bottomAccessoryView，此时从 B 回到 searchController，再降下 searchController，navigationBar 会被重新加回 View 层级树，这时候需要主动刷新一下 navigationItem，否则 A 也会看到 bottomAccessoryView。
    void (^didMoveToSuperviewBlock)(UINavigationBar *) = ^void(UINavigationBar *navigationBar) {
        updateBottomAccessoryViewBlock(navigationBar, navigationBar.topItem, NO);
    };
    
    #pragma mark - UINavigationController setNavigationBarHidden:animated:
    // 如果在 navigationBar 隐藏的情况下去修改 navigationItem，是无法触发 updateTopItemBlock 的，所以需要在显示 navigationBar 时主动刷新一次
    void (^navigationBarHiddenBlock)(UINavigationController *, BOOL, BOOL) = ^void(UINavigationController *navigationController, BOOL hidden, BOOL animated) {
        if (!hidden) {
            updateBottomAccessoryViewBlock(navigationController.navigationBar, navigationController.navigationBar.topItem, animated);
        }
    };
    
    ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationBar class], @selector(pushNavigationItem:animated:), UINavigationItem *, BOOL, pushNavigationItemBlock);
    ExtendImplementationOfNonVoidMethodWithSingleArgument([UINavigationBar class], NSSelectorFromString(@"_popNavigationItemWithTransition:"), NSInteger, id, popNavigationItemWithTransitionBlock);
    ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationBar class], @selector(setItems:animated:), NSArray<UINavigationItem *> *, BOOL, setItemsBlock);
    ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationBar class], NSSelectorFromString(@"_updateContentIfTopItem:animated:"), UINavigationItem *, BOOL, updateTopItemBlock);
    ExtendImplementationOfVoidMethodWithoutArguments([UINavigationBar class], @selector(didMoveToSuperview), didMoveToSuperviewBlock);
    ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationController class], @selector(setNavigationBarHidden:animated:), BOOL, BOOL, navigationBarHiddenBlock);
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
    SEL selector = NSSelectorFromString(@"qmuinb_copyStylesToBar");
    NSAssert([self respondsToSelector:selector], @"请检查 UINavigationBar+Transtion 里是否没提供 qmuinb_copyStylesToBar 方法？");
    BeginIgnorePerformSelectorLeaksWarning
    UINavigationBar *copyStylesToBar = (UINavigationBar *)[self performSelector:selector];
    EndIgnorePerformSelectorLeaksWarning
    if (copyStylesToBar) {
        copyStylesToBar.qmuibav_backgroundEffectViewExtendBottomBlock = qmuibav_backgroundEffectViewExtendBottomBlock;
    }
}

- (CGFloat (^)(void))qmuibav_backgroundEffectViewExtendBottomBlock {
    return (CGFloat (^)(void))objc_getAssociatedObject(self, &kAssociatedObjectKey_backgroundEffectViewExtendBottomBlock);
}

@end
