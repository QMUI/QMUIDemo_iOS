//
//  QDChangeNavBarStyleViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 16/9/5.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCommonListViewController.h"

typedef NS_ENUM(NSInteger, QDNavigationBarStyle) {
    QDNavigationBarStyleOrigin,
    QDNavigationBarStyleLight,
    QDNavigationBarStyleDark
};

@interface QDChangeNavBarStyleViewController : QDCommonListViewController

- (instancetype)initWithBarStyle:(QDNavigationBarStyle)barStyle;

@end
