//
//  QDThemeManager.m
//  qmuidemo
//
//  Created by MoLice on 2017/5/9.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDThemeManager.h"

NSString *const QDThemeChangedNotification = @"QDThemeChangedNotification";
NSString *const QDThemeBeforeChangedName = @"QDThemeBeforeChangedName";
NSString *const QDThemeAfterChangedName = @"QDThemeAfterChangedName";

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

- (void)setCurrentTheme:(NSObject<QDThemeProtocol> *)currentTheme {
    BOOL isThemeChanged = _currentTheme != currentTheme;
    NSObject<QDThemeProtocol> *themeBeforeChanged = nil;
    if (isThemeChanged) {
        themeBeforeChanged = _currentTheme;
    }
    _currentTheme = currentTheme;
    if (isThemeChanged) {
        [currentTheme setupConfigurationTemplate];
        [[NSNotificationCenter defaultCenter] postNotificationName:QDThemeChangedNotification object:self userInfo:@{QDThemeBeforeChangedName: themeBeforeChanged ?: [NSNull null], QDThemeAfterChangedName: currentTheme ?: [NSNull null]}];
    }
}

@end
