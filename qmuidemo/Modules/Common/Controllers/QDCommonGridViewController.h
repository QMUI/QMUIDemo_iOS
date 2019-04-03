//
//  QDCommonGridViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 2016/10/10.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCommonViewController.h"

@interface QDCommonGridViewController : QDCommonViewController

@property(nonatomic, strong) QMUIOrderedDictionary<NSString *, UIImage *> *dataSource;
@property(nonatomic, strong, readonly) UIScrollView *scrollView;
@property(nonatomic, strong, readonly) QMUIGridView *gridView;

@end

@interface QDCommonGridViewController (UISubclassingHooks)

// 子类继承，可以不调super
- (void)initDataSource;
- (void)didSelectCellWithTitle:(NSString *)title;
@end
