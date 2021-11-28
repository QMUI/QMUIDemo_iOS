//
//  QMUIDropdownNotification.h
//  qmuidemo
//
//  Created by molice on 2021/10/27.
//  Copyright © 2021 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class QMUIDropdownNotification;

@protocol QMUIDropdownNotificationViewProtocol <NSObject>

@required
// 靠 notificationView 去持有 notification，从而避免 notification 被释放
@property(nullable, nonatomic, strong) __kindof QMUIDropdownNotification *notification;

@optional
- (void)willShowNotification;
- (void)didShowNotification;
- (void)willHideNotification;
- (void)didHideNotification;

@end

/// 作用于 QMUIDropdownNotification.duration 属性，表示该 notification 不会自动消失
extern const NSTimeInterval QMUIDropdownNotificationDurationInfinite;

/**
 用来在 App 顶部显示一个 App 内的通知 tips，支持使用自定义的 View 来展示（通常也建议业务自定义自己的 View，QMUI 自带的只能满足最简单的场景）。示例代码：
 @code
 QMUIDropdownNotification *notification = [QMUIDropdownNotification notificationWithViewClass:QMUIDropdownNotificationView.class configuration:^(QMUIDropdownNotificationView * _Nonnull view) {
     view.imageView.image = [UIImage qmui_imageWithColor:UIColor.qd_tintColor size:CGSizeMake(16, 16) cornerRadius:1.5];
     view.titleLabel.text = @"标题";
     view.descriptionLabel.text = @"详细文本";
 }];
 notification.didTouchBlock = ^(__kindof QMUIDropdownNotification * _Nonnull notification) {
     [notification hide];
 };
 [notification show];
 @endcode
 */
@interface QMUIDropdownNotification : NSObject

+ (instancetype)notificationWithViewClass:(Class)viewClass configuration:(void (^ __nullable)(__kindof UIControl<QMUIDropdownNotificationViewProtocol> *view))configuration;

/// 获取/设置该 notification 对应的 view。该 view 的点击事件可以业务自己添加，也可以通过 didTouchBlock 来绑定。
@property(nullable, nonatomic, strong) __kindof UIControl<QMUIDropdownNotificationViewProtocol> *view;

/// 表示 notification 显示的持续时长，到达该时长后自动消失。默认为 3s，可以赋值为 QMUIDropdownNotificationDurationInfinite 以使其不会自动消失。
@property(nonatomic, assign) NSTimeInterval duration;

/// 表示当前 notification 是否能被消除，默认为 YES。当为 NO 时，不管是调用 hide 方法，或是手动往上滑动，都无法将 notification 消除。
@property(nonatomic, assign) BOOL canHide;

/// 通过 block 的形式设置 notification 布局时的上下左右 margin。该 block 会在任何必要的时候被调用（例如状态栏高度变化、横竖屏旋转、iPad 分屏调整等），因此可以在内部动态根据当前实时的 App 状态去布局。
/// @note 利用该 block 也可以控制 notification 的“最大宽度”——因为 notification 的宽度是由当前 App 宽度减去 block 返回的 left/right 的值得到的。
@property(nonatomic, copy) UIEdgeInsets (^layoutMarginsBlock)(void);

/// 是否正在显示
@property(nonatomic, assign, readonly, getter=isVisible) BOOL visible;

/// 显示该 notification，此时要求 view 必须非空。
- (void)show;

/// 隐藏该 notification。
- (void)hide;

@property(nullable, nonatomic, copy) void (^didTouchBlock)(__kindof QMUIDropdownNotification *notification);
@property(nullable, nonatomic, copy) void (^didHideBlock)(__kindof QMUIDropdownNotification *notification);
@end

@interface QMUIDropdownNotificationView : UIControl <QMUIDropdownNotificationViewProtocol>

@property(nonatomic, strong, readonly) UIImageView *imageView;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong, readonly) UILabel *descriptionLabel;
@property(nonatomic, strong, readonly) UIVisualEffectView *backgroundView;
@end

NS_ASSUME_NONNULL_END
