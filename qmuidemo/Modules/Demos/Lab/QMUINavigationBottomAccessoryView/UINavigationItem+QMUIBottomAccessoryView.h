//
//  UINavigationItem+QMUIBottomAccessoryView.h
//  qmuidemo
//
//  Created by MoLice on 2020/7/20.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 支持在 navigationBar 底部显示一个额外的 view，仅支持 navigationBar 为磨砂的场景。
 使用方法：
 1. 为 accessoryView 设置好高度，至于 x/y/width 均会被忽略，设置为0即可，最终 accessoryView 宽度会撑满 navigationBar，并被置于 navigationBar 的底部。
 2. 通过 viewController.navigationItem.qmui_bottomAccessoryView = xxx 的方式设置。
 
 @note 以后修改代码时的测试要点
 因为 navigationItem 是隶属于每个 UIViewController 的，所以会涉及到几个场景：
 1. 将被 push 的 vc 在 viewDidLoad 里修改 navigationItem（意味着 push 时直接拿该 item 即可）。
 2. 将被 push 的 vc 在 viewWillAppear: 里修改 navigationItem（意味着 push 时拿该 item，然后在 push 过程中又要再次刷新该 item）。
 3. 在 viewDidAppear: 后修改 navigationItem（此时 push/pop 均已结束，所以需要在 navigationItem 被修改后主动通知界面更新）。
 4. pop 时在前一个界面的 viewWillAppear: 里修改 navigationItem（因为是先触发 pop 再触发 viewWillAppear:，所以 viewWillAppear: 里修改 navigationItem 可能会覆盖 pop 过程的动画）。
 5. 手势返回过程、中断又取消手势返回。
 */
@interface UINavigationItem (QMUIBottomAccessoryView)

/// 在 navigationBar 底部显示一个额外的 view，仅支持 navigationBar 为磨砂的场景。为这个属性赋值前请自行保证 view 的 height 已被正确设置，至于 x/y/width 均会被忽略，设置为0即可。
@property(nonatomic, strong) __kindof UIView *qmui_bottomAccessoryView;
@end

NS_ASSUME_NONNULL_END
