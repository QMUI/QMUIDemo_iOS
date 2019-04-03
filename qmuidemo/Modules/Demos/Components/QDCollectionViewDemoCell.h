//
//  QDCollectionViewDemoCell.h
//  qmuidemo
//
//  Created by QMUI Team on 15/9/24.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDCollectionViewDemoCell : UICollectionViewCell

@property(nonatomic, strong, readonly) UILabel *contentLabel;
@property(nonatomic, assign) BOOL debug;
@property(nonatomic, assign) CGFloat pagingThreshold;
@property(nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@end
