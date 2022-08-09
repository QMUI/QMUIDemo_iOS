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
 调试面板，用于展示若干 @c QMUIInteractiveDebugPanelItem ，用 init 方法初始化后通过 @c title 属性设置标题，通过 @c addDebugItem: 添加调试项目，最后用 @c presentInViewController: 展示出来，或者直接把 .view 当成一个普通的 view 添加到界面上。
 @example
 QMUIInteractiveDebugPanelViewController *vc = QMUIInteractiveDebugPanelViewController.new;
 vc.title = @"title";
 [vc addDebugItem:xxx];
 [vc presentInViewController:xxx];
 
 QMUIInteractiveDebugPanelViewController *vc = QMUIInteractiveDebugPanelViewController.new;
 vc.title = @"title";
 [vc addDebugItem:xxx];
 CGSize size = [vc contentSizeThatFits:CGSizeMake(320, CGFLOAT_MAX)];
 vc.view.frame = CGRectMake(24, 24 320, size.height);
 [xxx addSubview:vc.view];
 */
@interface QMUIInteractiveDebugPanelViewController : UIViewController <QMUIModalPresentationContentViewControllerProtocol>

@property(nullable, nonatomic, strong, readonly) UILabel *titleLabel;
@property(nullable, nonatomic, strong, readonly) NSArray<QMUIInteractiveDebugPanelItem *> *debugItems;
@property(nullable, nonatomic, copy) void (^styleConfiguration)(QMUIInteractiveDebugPanelViewController *viewController);

- (void)addDebugItem:(QMUIInteractiveDebugPanelItem *)item;
- (void)removeDebugItem:(QMUIInteractiveDebugPanelItem *)item;
- (void)insertDebugItem:(QMUIInteractiveDebugPanelItem *)item atIndex:(NSUInteger)index;
- (void)removeDebugItemAtIndex:(NSUInteger)index;

- (void)presentInViewController:(UIViewController *)viewController;
- (CGSize)contentSizeThatFits:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
