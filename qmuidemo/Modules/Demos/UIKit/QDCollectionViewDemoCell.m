//
//  QDCollectionViewDemoCell.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/9/24.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDCollectionViewDemoCell.h"

@implementation QDCollectionViewDemoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        
        _contentLabel = [[UILabel alloc] qmui_initWithFont:UIFontLightMake(100) textColor:UIColorWhite];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentLabel sizeToFit];
    self.contentLabel.center = CGPointMake(CGRectGetWidth(self.contentView.bounds) / 2, CGRectGetHeight(self.contentView.bounds) / 2);
}

@end
