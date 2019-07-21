//
//  QDThemeProtocol.h
//  qmuidemo
//
//  Created by QMUI Team on 2017/5/9.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 所有主题均应实现这个协议，规定了 QMUI Demo 里常用的几个关键外观属性
@protocol QDThemeProtocol <QMUIConfigurationTemplateProtocol>

@required

/// 界面背景色
- (UIColor *)themeBackgroundColor;

/// 浅一点的界面背景色，例如 Grouped 类型的列表的 cell 背景
- (UIColor *)themeBackgroundColorLighten;

/// 在通用背景色上的 item 点击高亮背景色，例如 cell 的 highlightedBackgroundColor
- (UIColor *)themeBackgroundColorHighlighted;

/// 主题色
- (UIColor *)themeTintColor;

/// 最深的文字颜色，可用于标题或者输入框文字
- (UIColor *)themeTitleTextColor;

/// 主要内容的文字颜色，例如列表的 textLabel
- (UIColor *)themeMainTextColor;

/// 界面上一些附属说明的小字颜色
- (UIColor *)themeDescriptionTextColor;

/// 输入框 placeholder 的颜色
- (UIColor *)themePlaceholderColor;

/// 文字中的代码颜色
- (UIColor *)themeCodeColor;

/// 分隔线颜色，例如 tableViewSeparator
- (UIColor *)themeSeparatorColor;

/// App 首页每个单元格的颜色
- (UIColor *)themeGridItemTintColor;

- (NSString *)themeName;

@end
