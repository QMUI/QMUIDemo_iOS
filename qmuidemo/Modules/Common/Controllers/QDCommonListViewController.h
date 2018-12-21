//
//  QDCommonListViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 15/9/15.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonTableViewController.h"

@interface QDCommonListViewController : QDCommonTableViewController

@property(nonatomic, strong) NSArray<NSString *> *dataSource;
@property(nonatomic, strong) QMUIOrderedDictionary<NSString *, NSString *> *dataSourceWithDetailText;

@end

@interface QDCommonListViewController (UISubclassingHooks)

// 子类继承，可以不调super
- (void)initDataSource;
- (void)didSelectCellWithTitle:(NSString *)title;

@end
