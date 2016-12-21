//
//  QDCollectionDemoViewController.h
//  qmuidemo
//
//  Created by zhoonchen on 16/9/8.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCommonViewController.h"

@interface QDCollectionDemoViewController : QDCommonViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong, readonly) UICollectionView *collectionView;
@property(nonatomic, strong, readonly) QMUICollectionViewPagingLayout *collectionViewLayout;

- (instancetype)initWithLayoutStyle:(QMUICollectionViewPagingLayoutStyle)style;
@end
