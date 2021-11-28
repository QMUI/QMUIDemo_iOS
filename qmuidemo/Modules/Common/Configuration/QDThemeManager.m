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

@property(nonatomic, strong) UIImage *qd_navigationBarBackgroundImage;
@property(nonatomic, strong) UIImage *qd_navigationBarBackIndicatorImage;
@property(nonatomic, strong) UIImage *qd_navigationBarCloseImage;
@property(nonatomic, strong) UIImage *qd_navigationBarDisclosureIndicatorImage;
@property(nonatomic, strong) UIImage *qd_tableViewCellDisclosureIndicatorImage;
@property(nonatomic, strong) UIImage *qd_tableViewCellCheckmarkImage;
@property(nonatomic, strong) UIImage *qd_tableViewCellDetailButtonImage;
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
        
        self.qd_navigationBarBackgroundImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [UIImage qmui_imageWithColor:theme.themeTintColor];
        }];
        self.qd_navigationBarBackIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:UIColor.whiteColor];
        self.qd_navigationBarCloseImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:UIColor.whiteColor];
        self.qd_navigationBarDisclosureIndicatorImage = [[UIImage qmui_imageWithShape:QMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.qd_tableViewCellDisclosureIndicatorImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [identifier isEqualToString:QDThemeIdentifierDark] ? [UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorMake(98, 100, 104)] : [UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorGray7];
        }];
        self.qd_tableViewCellCheckmarkImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [UIImage qmui_imageWithShape:QMUIImageShapeCheckmark size:CGSizeMake(15, 12) tintColor:self.qd_tintColor];
        }];
        self.qd_tableViewCellDetailButtonImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [UIImage qmui_imageWithShape:QMUIImageShapeDetailButtonImage size:CGSizeMake(20, 20) tintColor:self.qd_tintColor];
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

+ (UIImage *)qd_navigationBarBackgroundImage {
    return QDThemeManager.sharedInstance.qd_navigationBarBackgroundImage;
}

+ (UIImage *)qd_navigationBarBackIndicatorImage {
    return QDThemeManager.sharedInstance.qd_navigationBarBackIndicatorImage;
}

+ (UIImage *)qd_navigationBarCloseImage {
    return QDThemeManager.sharedInstance.qd_navigationBarCloseImage;
}

+ (UIImage *)qd_navigationBarDisclosureIndicatorImage {
    return QDThemeManager.sharedInstance.qd_navigationBarDisclosureIndicatorImage;
}

+ (UIImage *)qd_tableViewCellDisclosureIndicatorImage {
    return QDThemeManager.sharedInstance.qd_tableViewCellDisclosureIndicatorImage;
}

+ (UIImage *)qd_tableViewCellCheckmarkImage {
    return QDThemeManager.sharedInstance.qd_tableViewCellCheckmarkImage;
}

+ (UIImage *)qd_tableViewCellDetailButtonImage {
    return QDThemeManager.sharedInstance.qd_tableViewCellDetailButtonImage;
}

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
