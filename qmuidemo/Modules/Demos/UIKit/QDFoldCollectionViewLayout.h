//
//  QDFoldCollectionViewLayout.h
//  qmuidemo
//
//  Created by ZhoonChen on 15/10/6.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDFoldCollectionViewLayout : UICollectionViewLayout

@property(nonatomic, strong) NSIndexPath *curIndexPath;
@property(nonatomic, assign) CGPoint curPoint;
@property(nonatomic, assign) BOOL isMoving;

@end
