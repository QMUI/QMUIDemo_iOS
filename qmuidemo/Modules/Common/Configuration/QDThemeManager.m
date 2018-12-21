//
//  QDThemeManager.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/5/9.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDThemeManager.h"
#import "QMUIConfigurationTemplate.h"

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

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:QDThemeChangedNotification object:nil];
    }
    return self;
}

- (void)handleThemeChangedNotification:(NSNotification *)notification {
    NSObject<QDThemeProtocol> *themeBeforeChanged = notification.userInfo[QDThemeBeforeChangedName];
    themeBeforeChanged = [themeBeforeChanged isKindOfClass:[NSNull class]] ? nil : themeBeforeChanged;
    
    NSObject<QDThemeProtocol> *themeAfterChanged = notification.userInfo[QDThemeAfterChangedName];
    themeAfterChanged = [themeAfterChanged isKindOfClass:[NSNull class]] ? nil : themeAfterChanged;
    
    [self themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
}

- (void)setCurrentTheme:(NSObject<QDThemeProtocol> *)currentTheme {
    BOOL isThemeChanged = _currentTheme != currentTheme;
    NSObject<QDThemeProtocol> *themeBeforeChanged = nil;
    if (isThemeChanged) {
        themeBeforeChanged = _currentTheme;
    }
    _currentTheme = currentTheme;
    if (isThemeChanged && themeBeforeChanged) {// 从 nil 变成某个 theme 就不发通知了，初始化时会自动 apply，这里只需要处理在 QD 里手动更改 theme 的场景就行
        [currentTheme applyConfigurationTemplate];
        [[NSNotificationCenter defaultCenter] postNotificationName:QDThemeChangedNotification object:self userInfo:@{QDThemeBeforeChangedName: themeBeforeChanged ?: [NSNull null], QDThemeAfterChangedName: currentTheme ?: [NSNull null]}];
    }
}

#pragma mark - <QDChangingThemeDelegate>

- (void)themeBeforeChanged:(NSObject<QDThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<QDThemeProtocol> *)themeAfterChanged {
    // 主题发生变化，在这里更新全局 UI 控件的 appearance
    [QDCommonUI renderGlobalAppearances];
    
    // 更新表情 icon 的颜色
    [QDUIHelper updateEmotionImages];
}

@end
