//
//  QMUIConfigurationTemplate.m
//  qmui
//
//  Created by QMUI Team on 15/3/29.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QMUIConfigurationTemplateDark.h"

@implementation QMUIConfigurationTemplateDark

#pragma mark - <QMUIConfigurationTemplateProtocol>

- (void)applyConfigurationTemplate {
    [super applyConfigurationTemplate];
    
    QMUICMI.keyboardAppearance = UIKeyboardAppearanceDark;
    
    QMUICMI.navBarBackgroundImage = nil;
    QMUICMI.navBarStyle = UIBarStyleBlack;
    
    QMUICMI.tabBarBackgroundImage = nil;
    QMUICMI.tabBarShadowImageColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
        return theme.themeSeparatorColor;
    }];// 这是一个 QMUIThemeColor，在应用配置表时，QMUIThemeImage 里还没 hook qmui_imageWithColor 方法，所以无法生成一个 QMUIThemeImage 对象，所以不会自动变化，所以需要手动在 Dark 配置表里再设置一次
    QMUICMI.tabBarStyle = UIBarStyleBlack;
    
    QMUICMI.toolBarShadowImageColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
        return theme.themeSeparatorColor;
    }];// 这是一个 QMUIThemeColor，在应用配置表时，QMUIThemeImage 里还没 hook qmui_imageWithColor 方法，所以无法生成一个 QMUIThemeImage 对象，所以不会自动变化，所以需要手动在 Dark 配置表里再设置一次
    QMUICMI.toolBarStyle = UIBarStyleBlack;
}

// QMUI 2.3.0 版本里，配置表新增这个方法，返回 YES 表示在 App 启动时要自动应用这份配置表。仅当你的 App 里存在多份配置表时，才需要把除默认配置表之外的其他配置表的返回值改为 NO。
- (BOOL)shouldApplyTemplateAutomatically {
    [QMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:self.themeName theme:self];
    
    NSString *selectedThemeIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:QDSelectedThemeIdentifier];
    BOOL result = [selectedThemeIdentifier isEqualToString:self.themeName];
    if (result) {
        QMUIThemeManagerCenter.defaultThemeManager.currentTheme = self;
    }
    return result;
}

#pragma mark - <QDThemeProtocol>

- (UIColor *)themeBackgroundColor {
    return UIColorBlack;
}

- (UIColor *)themeBackgroundColorLighten {
    return UIColorMake(28, 28, 30);
}

- (UIColor *)themeBackgroundColorHighlighted {
    return UIColorMake(48, 49, 51);
}

- (UIColor *)themeTintColor {
    return UIColorTheme10;
}

- (UIColor *)themeTitleTextColor {
    return UIColorDarkGray1;
}

- (UIColor *)themeMainTextColor {
    return UIColorDarkGray3;
}

- (UIColor *)themeDescriptionTextColor {
    return UIColorDarkGray6;
}

- (UIColor *)themePlaceholderColor {
    return UIColorDarkGray8;
}

- (UIColor *)themeCodeColor {
    return self.themeTintColor;
}

- (UIColor *)themeSeparatorColor {
    return UIColorMake(46, 50, 54);
}

- (NSString *)themeName {
    return QDThemeIdentifierDark;
}

@end
