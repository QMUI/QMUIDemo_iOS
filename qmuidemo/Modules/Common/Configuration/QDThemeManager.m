//
//  QDThemeManager.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/5/9.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDThemeManager.h"

@interface QDThemeManager ()

@property(nonatomic, strong) UIColor *qd_backgroundColor;
@property(nonatomic, strong) UIColor *qd_backgroundColorLighten;
@property(nonatomic, strong) UIColor *qd_backgroundColorHighlighted;
@property(nonatomic, strong) UIColor *qd_tintColor;
@property(nonatomic, strong) UIColor *qd_titleTextColor;
@property(nonatomic, strong) UIColor *qd_mainTextColor;
@property(nonatomic, strong) UIColor *qd_descriptionTextColor;
@property(nonatomic, strong) UIColor *qd_placeholderColor;
@property(nonatomic, strong) UIColor *qd_codeColor;
@property(nonatomic, strong) UIColor *qd_separatorColor;
@property(nonatomic, strong) UIColor *qd_gridItemTintColor;

@property(nonatomic, strong) UIImage *qd_searchBarTextFieldBackgroundImage;
@property(nonatomic, strong) UIImage *qd_searchBarBackgroundImage;

@property(nonatomic, strong) UIVisualEffect *qd_standardBlueEffect;

@property(class, nonatomic, strong, readonly) QDThemeManager *sharedInstance;
@end

@implementation QDThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QDThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        self.qd_backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themeBackgroundColor;
        }];
        self.qd_backgroundColorLighten = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return theme.themeBackgroundColorLighten;
        }];
        self.qd_backgroundColorHighlighted = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themeBackgroundColorHighlighted;
        }];
        self.qd_tintColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themeTintColor;
        }];
        self.qd_titleTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themeTitleTextColor;
        }];
        self.qd_mainTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themeMainTextColor;
        }];
        self.qd_descriptionTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themeDescriptionTextColor;
        }];
        self.qd_placeholderColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themePlaceholderColor;
        }];
        self.qd_codeColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themeCodeColor;
        }];
        self.qd_separatorColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> *theme) {
            return theme.themeSeparatorColor;
        }];
        self.qd_gridItemTintColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return theme.themeGridItemTintColor;
        }];
        
        self.qd_searchBarTextFieldBackgroundImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<QDThemeProtocol> * _Nullable theme) {
            return [UISearchBar qmui_generateTextFieldBackgroundImageWithColor:theme.themeBackgroundColorHighlighted];
        }];
        self.qd_searchBarBackgroundImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<QDThemeProtocol> * _Nullable theme) {
            return [UISearchBar qmui_generateBackgroundImageWithColor:theme.themeBackgroundColor borderColor:nil];
        }];
        
        self.qd_standardBlueEffect = [UIVisualEffect qmui_effectWithThemeProvider:^UIVisualEffect * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [UIBlurEffect effectWithStyle:[identifier isEqualToString:QDThemeIdentifierDark] ? UIBlurEffectStyleDark : UIBlurEffectStyleLight];
        }];
    }
    return self;
}

+ (NSObject<QDThemeProtocol> *)currentTheme {
    return QMUIThemeManagerCenter.defaultThemeManager.currentTheme;
}

@end

@implementation UIColor (QDTheme)

+ (instancetype)qd_sharedInstance {
    static dispatch_once_t onceToken;
    static UIColor *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (UIColor *)qd_backgroundColor {
    return QDThemeManager.sharedInstance.qd_backgroundColor;
}

+ (UIColor *)qd_backgroundColorLighten {
    return QDThemeManager.sharedInstance.qd_backgroundColorLighten;
}

+ (UIColor *)qd_backgroundColorHighlighted {
    return QDThemeManager.sharedInstance.qd_backgroundColorHighlighted;
}

+ (UIColor *)qd_tintColor {
    return QDThemeManager.sharedInstance.qd_tintColor;
}

+ (UIColor *)qd_titleTextColor {
    return QDThemeManager.sharedInstance.qd_titleTextColor;
}

+ (UIColor *)qd_mainTextColor {
    return QDThemeManager.sharedInstance.qd_mainTextColor;
}

+ (UIColor *)qd_descriptionTextColor {
    return QDThemeManager.sharedInstance.qd_descriptionTextColor;
}

+ (UIColor *)qd_placeholderColor {
    return QDThemeManager.sharedInstance.qd_placeholderColor;
}

+ (UIColor *)qd_codeColor {
    return QDThemeManager.sharedInstance.qd_codeColor;
}

+ (UIColor *)qd_separatorColor {
    return QDThemeManager.sharedInstance.qd_separatorColor;
}

+ (UIColor *)qd_gridItemTintColor {
    return QDThemeManager.sharedInstance.qd_gridItemTintColor;
}

@end

@implementation UIImage (QDTheme)

+ (UIImage *)qd_searchBarTextFieldBackgroundImage {
    return QDThemeManager.sharedInstance.qd_searchBarTextFieldBackgroundImage;
}

+ (UIImage *)qd_searchBarBackgroundImage {
    return QDThemeManager.sharedInstance.qd_searchBarBackgroundImage;
}

@end

@implementation UIVisualEffect (QDTheme)

+ (UIVisualEffect *)qd_standardBlurEffect {
    return QDThemeManager.sharedInstance.qd_standardBlueEffect;
}

@end
