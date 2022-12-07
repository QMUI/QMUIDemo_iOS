/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  QMUIBackBarButton.m
//  qmui
//
//  Created by QMUI Team on 20/12/03.
//

#import "QMUIBackBarButton.h"

@interface UIView (QMUIBackBarButton)

/// 用来标志某个 view 是否被设置为某个 UINavigationItem 的 qmui_backBarButton
@property(nonatomic, assign) BOOL qmuibbb_isViewOfQMUIBackBarButton;
@end

@interface UINavigationItem ()

@property(nonatomic, strong) UIBarButtonItem *qmuibbb_backBarButtonItem;
@property(nonatomic, assign) BOOL qmuibbb_hidesBackButton;// 这个标志位用来记录外面业务真正设置的值，QMUIBackBarButton 因内部需要而修改 UINavigationItem.hidesBackButton 的不会被记录。
@end

@implementation UINavigationItem (QMUIBackBarButton)

QMUISynthesizeIdStrongProperty(qmuibbb_backBarButtonItem, setQmuibbb_backBarButtonItem)
QMUISynthesizeBOOLProperty(qmuibbb_hidesBackButton, setQmuibbb_hidesBackButton)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 需要用到系统原本的实现，所以用 Exchange 的方式来 hook selector
        ExchangeImplementations(UINavigationItem.class, @selector(setLeftBarButtonItems:animated:), @selector(qmuibbb_setLeftBarButtonItems:animated:));
        ExchangeImplementations(UINavigationItem.class, @selector(setHidesBackButton:animated:), @selector(qmuibbb_setHidesBackButton:animated:));
        
#pragma mark - UINavigationBar setItems:animated:
        ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationBar class], @selector(setItems:animated:), NSArray<UINavigationItem *> *, BOOL, ^(UINavigationBar *navigationBar, NSArray<UINavigationItem *> *items, BOOL animated) {
            [UINavigationItem qmuibbb_updateNavigationItems:items];
        });
        
#pragma mark - UINavigationBar didMoveToSuperview
        ExtendImplementationOfVoidMethodWithoutArguments([UINavigationBar class], @selector(didMoveToSuperview), ^(UINavigationBar *selfObject) {
            [UINavigationItem qmuibbb_updateNavigationItems:selfObject.items];
        });
        
#pragma mark - UINavigationController setNavigationBarHidden:animated:
        ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationController class], @selector(setNavigationBarHidden:animated:), BOOL, BOOL, ^(UINavigationController *navigationController, BOOL hidden, BOOL animated) {
            [UINavigationItem qmuibbb_updateNavigationItems:navigationController.navigationBar.items];
        });
        
#pragma mark - UINavigationBar pushNavigationItem:animated:
        OverrideImplementation([UINavigationBar class], @selector(pushNavigationItem:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, UINavigationItem *navigationItem, BOOL animated) {
                
                [UINavigationItem qmuibbb_updateNavigationItems:[selfObject.items arrayByAddingObject:navigationItem]];
                
                // call super
                void (*originSelectorIMP)(id, SEL, UINavigationItem *, BOOL);
                originSelectorIMP = (void (*)(id, SEL, UINavigationItem *, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, navigationItem, animated);
            };
        });
        
#pragma mark - UINavigationItem setLeftBarButtonItem:animated:
        OverrideImplementation([UINavigationItem class], @selector(setLeftBarButtonItem:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationItem *selfObject, UIBarButtonItem *item, BOOL animated) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIBarButtonItem *, BOOL);
                originSelectorIMP = (void (*)(id, SEL, UIBarButtonItem *, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, item, animated);
                
                [UINavigationItem qmuibbb_updateNavigationItem:selfObject];
            };
        });
        
#pragma mark - UINavigationItem setLeftItemsSupplementBackButton:
        OverrideImplementation([UINavigationItem class], @selector(setLeftItemsSupplementBackButton:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationItem *selfObject, BOOL supplementBackButton) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, supplementBackButton);
                
                [UINavigationItem qmuibbb_updateNavigationItem:selfObject];
            };
        });
    });
}

static char kAssociatedObjectKey_backBarButton;
- (void)setQmui_backBarButton:(__kindof UIView *)qmui_backBarButton {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_backBarButton, qmui_backBarButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    qmui_backBarButton.qmuibbb_isViewOfQMUIBackBarButton = YES;
    self.qmuibbb_backBarButtonItem = qmui_backBarButton ? [[UIBarButtonItem alloc] initWithCustomView:qmui_backBarButton] : nil;
    
    [UINavigationItem qmuibbb_updateNavigationItems:self.qmui_navigationBar.items];
    
    // 当返回按钮使用 qmui_backBarButton 实现时，保证手势返回正常运转
    // 如果在 QMUI 体系里，还要检查 pop 拦截功能是否正常
    NSObject *delegate = self.qmui_navigationController.interactivePopGestureRecognizer.delegate;
    if (qmui_backBarButton && delegate) {
        Class delegateClass = delegate.class;
        [QMUIHelper executeBlock:^{
            SEL selector1 = NSSelectorFromString(@"_gestureRecognizer:shouldReceiveEvent:");
            SEL selector2 = @selector(gestureRecognizer:shouldReceiveTouch:);
            
            BOOL (^isShowingQMUIBackBarButtonBlock)(UIView *) = ^BOOL(UIView *view) {
                if ([view.qmui_viewController isKindOfClass:UINavigationController.class]) {
                    UINavigationController *navController = (UINavigationController *)view.qmui_viewController;
                    UINavigationItem *topItem = navController.navigationBar.topItem;
                    if (!navController.navigationBarHidden && topItem.leftBarButtonItem && topItem.leftBarButtonItem == topItem.qmui_previousItem.qmuibbb_backBarButtonItem) {
                        return YES;
                    }
                }
                return NO;
            };
            // iOS 13.4 及以后的版本使用这个
            if ([delegate respondsToSelector:selector1]) {
                OverrideImplementation(delegateClass, selector1, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                    return ^BOOL(NSObject *selfObject, UIGestureRecognizer *firstArgv, UIEvent *secondArgv) {
                        
                        if (isShowingQMUIBackBarButtonBlock(firstArgv.view)) {
                            return YES;
                        }
                        
                        // call super
                        BOOL (*originSelectorIMP)(id, SEL, UIGestureRecognizer *, UIEvent *);
                        originSelectorIMP = (BOOL (*)(id, SEL, UIGestureRecognizer *, UIEvent *))originalIMPProvider();
                        BOOL result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
                        
                        return result;
                    };
                });
            }
            
            // iOS 13.4 以前的版本用这个
            if ([delegate respondsToSelector:selector2]) {
                OverrideImplementation(delegateClass, selector2, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                    return ^BOOL(NSObject *selfObject, UIGestureRecognizer *firstArgv, UITouch *secondArgv) {
                        
                        if (isShowingQMUIBackBarButtonBlock(firstArgv.view)) {
                            return YES;
                        }
                        
                        // call super
                        BOOL (*originSelectorIMP)(id, SEL, UIGestureRecognizer *, UITouch *);
                        originSelectorIMP = (BOOL (*)(id, SEL, UIGestureRecognizer *, UITouch *))originalIMPProvider();
                        BOOL result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
                        
                        return result;
                    };
                });
            }
        } oncePerIdentifier:[NSString stringWithFormat:@"QMUIBackBarButton %@", NSStringFromClass(delegateClass)]];
    }
}

+ (void)qmuibbb_updateNavigationItems:(NSArray<UINavigationItem *> *)items {
    for (NSInteger i = 0, l = items.count; i < l; i++) {
        [UINavigationItem _qmuibbb_updateNavigationItem:items[i] previousItem:i > 0 ? items[i-1] : nil nextItem:i < l - 1 ? items[i+1] : nil];
    }
}

// 由于 qmuibbb_updateNavigationItem 的实现原理，实际上更新当前 item 的逻辑是在 prevItem 里（每个 item 都更新自己的 nextItem），所以这里 update 了两次
+ (void)qmuibbb_updateNavigationItem:(UINavigationItem *)item {
    UINavigationItem *prevItem = item.qmui_previousItem;
    UINavigationItem *nextItem = item.qmui_nextItem;
    if (prevItem) {
        [UINavigationItem _qmuibbb_updateNavigationItem:prevItem previousItem:prevItem.qmui_previousItem nextItem:item];
    }
    [UINavigationItem _qmuibbb_updateNavigationItem:item previousItem:prevItem nextItem:nextItem];
}

+ (void)_qmuibbb_updateNavigationItem:(UINavigationItem *)item previousItem:(UINavigationItem *)prevItem nextItem:(UINavigationItem *)nextItem {
    if (prevItem && !prevItem.qmuibbb_backBarButtonItem && item.leftBarButtonItem.customView.qmuibbb_isViewOfQMUIBackBarButton) {
        NSMutableArray<UIBarButtonItem *> *leftItems = [item qmuibbb_leftBarButtonItemsWithoutCustom];
        [item qmuibbb_setLeftBarButtonItemsAndUpdateSystemBackButton:leftItems];
    }
    if (item.qmuibbb_backBarButtonItem && nextItem) {
        UIBarButtonItem *backBarButtonItem = item.qmuibbb_backBarButtonItem;
        NSMutableArray<UIBarButtonItem *> *leftItems = [nextItem qmuibbb_leftBarButtonItemsWithoutCustom];
        BOOL shouldShowBackButton = (leftItems.count <= 0 && !nextItem.qmuibbb_hidesBackButton) || (leftItems.count > 0 && nextItem.leftItemsSupplementBackButton && !nextItem.qmuibbb_hidesBackButton);
        if (shouldShowBackButton) {
            UIViewController *nextViewController = nextItem.qmui_viewController;
            if (!nextViewController) {
                UINavigationController *nav = item.qmui_navigationController;
                if (nav.qmui_isPopping) {
                    nextViewController = [nav.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
                } else {
                    nextViewController = nav.topViewController;
                }
            }
            if ([nextViewController respondsToSelector:@selector(shouldShowBackBarButton:)]) {
                shouldShowBackButton = [((id<QMUIBackBarButtonViewControllerSupport>)nextViewController) shouldShowBackBarButton:backBarButtonItem.customView];
            }
            if (shouldShowBackButton) {
                [leftItems insertObject:backBarButtonItem atIndex:0];
            }
        }
        [nextItem qmuibbb_setLeftBarButtonItemsAndUpdateSystemBackButton:leftItems];
    }
}

- (__kindof UIView *)qmui_backBarButton {
    return (UIView *)objc_getAssociatedObject(self, &kAssociatedObjectKey_backBarButton);
}

- (void)qmuibbb_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)items animated:(BOOL)animated {
    [self qmuibbb_setLeftBarButtonItems:items animated:animated];
    [UINavigationItem qmuibbb_updateNavigationItem:self];
    [self qmuibbb_updateHidesBackButton];
}

- (void)qmuibbb_setLeftBarButtonItemsAndUpdateSystemBackButton:(NSArray<UIBarButtonItem *> *)items {
    [self qmuibbb_setLeftBarButtonItems:items animated:NO];
    [self qmuibbb_updateHidesBackButton];
}

// 清理当前的 leftBarButtonItems 里的所有自定义返回按钮，避免前一个界面的自定义返回按钮指针变了却没刷新当前界面的旧返回按钮，所以每次都清理掉再重新 add
- (NSMutableArray<UIBarButtonItem *> *)qmuibbb_leftBarButtonItemsWithoutCustom {
    NSMutableArray<UIBarButtonItem *> *leftItems = [[[NSMutableArray alloc] initWithArray:self.leftBarButtonItems] qmui_filterWithBlock:^BOOL(UIBarButtonItem * _Nonnull it) {
        return !it.customView.qmuibbb_isViewOfQMUIBackBarButton;
    }].mutableCopy;
    return leftItems;
}

- (void)qmuibbb_setHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated {
    [self qmuibbb_setHidesBackButton:hidesBackButton animated:animated];
    self.qmuibbb_hidesBackButton = hidesBackButton;
    [UINavigationItem qmuibbb_updateNavigationItem:self];
}

- (void)qmuibbb_updateHidesBackButton {
    // 当需要显示自定义的返回按钮时，必须把系统的返回按钮隐藏掉，否则会看到两个返回按钮同时存在
    BOOL shouldShowCustomBackButton = self.leftBarButtonItems.firstObject.customView.qmuibbb_isViewOfQMUIBackBarButton && (self.leftBarButtonItems.count == 1 || (self.leftBarButtonItems.count > 1 && self.leftItemsSupplementBackButton)) && !self.qmuibbb_hidesBackButton;
    if (shouldShowCustomBackButton) {
        [self qmuibbb_setHidesBackButton:YES animated:NO];
    } else {
        [self qmuibbb_setHidesBackButton:self.qmuibbb_hidesBackButton animated:NO];
    }
}

@end

@implementation UIView (QMUIBackBarButton)

QMUISynthesizeBOOLProperty(qmuibbb_isViewOfQMUIBackBarButton, setQmuibbb_isViewOfQMUIBackBarButton)
@end
