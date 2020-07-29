//
//  QMUIInteractiveDebugger.h
//  qmuidemo
//
//  Created by MoLice on 2020/5/19.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMUIInteractiveDebugPanelViewController.h"
#import "QMUIInteractiveDebugPanelItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 快速地创建一个用 QMUIModalPresentationViewController present 出来的浮层，浮层内提供可交互的调试工具用于修改界面上的效果
 每个浮层是一个 QMUIInteractiveDebugPanelViewController，里面的每一行是一个 QMUIInteractiveDebugPanelItem，其中 item 又提供了多种常见的类型，例如颜色输入框、数字输入框、balabala
 */
@interface QMUIInteractiveDebugger : NSObject

+ (void)presentTabBarDebuggerInViewController:(UIViewController *)presentingViewController;
+ (void)presentNavigationBarDebuggerInViewController:(UIViewController *)presentingViewController;
@end

NS_ASSUME_NONNULL_END
