//
//  QDThemeManager.h
//  qmuidemo
//
//  Created by QMUI Team on 2017/5/9.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDThemeProtocol.h"

/// 当主题发生变化时，会发送这个通知
extern NSString *const QDThemeChangedNotification;

/// 主题发生改变前的值，类型为 NSObject<QDThemeProtocol>，可能为 NSNull
extern NSString *const QDThemeBeforeChangedName;

/// 主题发生改变后的值，类型为 NSObject<QDThemeProtocol>，可能为 NSNull
extern NSString *const QDThemeAfterChangedName;

/**
 *  QMUI Demo 的皮肤管理器，当需要换肤时，请为 currentTheme 赋值；当需要获取当前皮肤时，可访问 currentTheme 属性。
 *  可通过监听 QDThemeChangedNotification 通知来捕获换肤事件，默认地，QDCommonViewController 及 QDCommonTableViewController 均已支持响应换肤，其响应方法是通过 QDChangingThemeDelegate 接口来实现的。
 */
@interface QDThemeManager : NSObject<QDChangingThemeDelegate>

+ (instancetype)sharedInstance;

@property(nonatomic, strong) NSObject<QDThemeProtocol> *currentTheme;
@end
