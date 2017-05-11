//
//  QDThemeProtocol.h
//  qmuidemo
//
//  Created by MoLice on 2017/5/9.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 所有主题均应实现这个协议，规定了 QMUI Demo 里常用的几个关键外观属性
@protocol QDThemeProtocol <NSObject>

@required

/// 来自于 QMUIConfigurationTemplate 里的自带方法，用于应用配置表里的设置
- (void)setupConfigurationTemplate;

- (UIColor *)themeTintColor;
- (UIColor *)themeListTextColor;
- (UIColor *)themeCodeColor;
- (UIColor *)themeGridItemTintColor;

- (NSString *)themeName;

@end


/// 所有能响应主题变化的对象均应实现这个协议，目前主要用于 QDCommonViewController 及 QDCommonTableViewController
@protocol QDChangingThemeDelegate <NSObject>

@required

- (void)themeBeforeChanged:(NSObject<QDThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<QDThemeProtocol> *)themeAfterChanged;

@end
