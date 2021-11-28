//
//  QMUIInteractiveDebugPanelItem.h
//  qmuidemo
//
//  Created by QMUI Team on 2020/5/20.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 代表 Debug 面板里的一行，左边文字右边 actionView，用户操作都是通过 actionView 完成。在 item 被添加到面板上后会调用 valueGetter()，请在里面为自己的 actionView 赋值。当 actionView 产生了用户操作行为（例如输入文字、切换开关）后，numbericItem、colorItem、boolItem 这些内置的 item 会自动调用 valueSetter()，请在里面获取最新的 actionView 的值并进行一些你需要的响应（例如刷新 App 界面上的某些东西）。
 */
@interface QMUIInteractiveDebugPanelItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong) __kindof UIView *actionView;
@property(nonatomic, copy, nullable) void (^valueGetter)(__kindof UIView *actionView);
@property(nonatomic, copy, nullable) void (^valueSetter)(__kindof UIView *actionView);
@property(nonatomic, assign) CGFloat height;

+ (instancetype)itemWithTitle:(NSString *)title actionView:(__kindof UIView *)actionView valueGetter:(nullable void (^)(__kindof UIView *actionView))valueGetter valueSetter:(nullable void (^)(__kindof UIView *actionView))valueSetter;

/// 文字 item，提供一个输入框输入文字
+ (instancetype)textItemWithTitle:(NSString *)title valueGetter:(nullable void (^)(QMUITextField *actionView))valueGetter valueSetter:(nullable void (^)(QMUITextField *actionView))valueSetter;

/// 数字 item，提供一个输入框仅允许输入数字、小数点
+ (instancetype)numbericItemWithTitle:(NSString *)title valueGetter:(nullable void (^)(QMUITextField *actionView))valueGetter valueSetter:(nullable void (^)(QMUITextField *actionView))valueSetter;

/// 颜色 item，提供一个输入框输入 RGBA 格式的字符串
+ (instancetype)colorItemWithTitle:(NSString *)title valueGetter:(nullable void (^)(QMUITextField *actionView))valueGetter valueSetter:(nullable void (^)(QMUITextField *actionView))valueSetter;

/// BOOL 值 item，提供一个 UISwitch 开启/关闭
+ (instancetype)boolItemWithTitle:(NSString *)title valueGetter:(nullable void (^)(UISwitch *actionView))valueGetter valueSetter:(nullable void (^)(UISwitch *actionView))valueSetter;

+ (instancetype)enumItemWithTitle:(NSString *)title items:(NSArray<NSString *> *)items valueGetter:(nullable void (^)(UISegmentedControl *actionView))valueGetter valueSetter:(nullable void (^)(UISegmentedControl *actionView))valueSetter;
@end

NS_ASSUME_NONNULL_END
