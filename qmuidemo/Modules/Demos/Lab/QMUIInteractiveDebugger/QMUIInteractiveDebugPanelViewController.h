//
//  QMUIInteractiveDebugPanelViewController.h
//  qmuidemo
//
//  Created by MoLice on 2020/5/20.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QMUIInteractiveDebugPanelItem;

/**
 调试面板，用于展示若干 @c QMUIInteractiveDebugPanelItem ，用 init 方法初始化后通过 @c title 属性设置标题，通过 @c addDebugItem: 添加调试项目，最后用 @c presentInViewController: 展示出来。
 */
@interface QMUIInteractiveDebugPanelViewController : UIViewController <QMUIModalPresentationContentViewControllerProtocol>

@property(nonatomic, strong, readonly, nullable) UILabel *titleLabel;

- (void)addDebugItem:(QMUIInteractiveDebugPanelItem *)item;
- (void)presentInViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
