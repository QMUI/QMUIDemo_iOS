//
//  QDCollectionViewDemoCell.m
//  qmuidemo
//
//  Created by QMUI Team on 15/9/24.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDCollectionViewDemoCell.h"

@interface QDCollectionViewDemoCell ()

@property(nonatomic, strong) CALayer *prevLayer;
@property(nonatomic, strong) CALayer *nextLayer;
@end

@implementation QDCollectionViewDemoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        
        _contentLabel = [[UILabel alloc] qmui_initWithFont:UIFontLightMake(100) textColor:UIColorWhite];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.contentLabel];
        
        self.prevLayer = [CALayer layer];
        [self.prevLayer qmui_removeDefaultAnimations];
        self.prevLayer.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, .3).CGColor;
        [self.contentView.layer addSublayer:self.prevLayer];
        
        self.nextLayer = [CALayer layer];
        [self.nextLayer qmui_removeDefaultAnimations];
        self.nextLayer.backgroundColor = self.prevLayer.backgroundColor;
        [self.contentView.layer addSublayer:self.nextLayer];
    }
    return self;
}

- (void)setDebug:(BOOL)debug {
    _debug = debug;
    self.prevLayer.hidden = !debug;
    self.nextLayer.hidden = !debug;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentLabel sizeToFit];
    self.contentLabel.center = CGPointMake(CGRectGetWidth(self.contentView.bounds) / 2, CGRectGetHeight(self.contentView.bounds) / 2);
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        self.prevLayer.frame = CGRectMake(0, CGRectGetHeight(self.contentView.bounds) * (1 - self.pagingThreshold), CGRectGetWidth(self.contentView.bounds), PixelOne);
        self.nextLayer.frame = CGRectSetY(self.prevLayer.frame, CGRectGetHeight(self.contentView.bounds) * self.pagingThreshold);
    } else {
        self.prevLayer.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) * (1 - self.pagingThreshold), 0, PixelOne, CGRectGetHeight(self.contentView.bounds));
        self.nextLayer.frame = CGRectSetX(self.prevLayer.frame, CGRectGetWidth(self.contentView.bounds) * self.pagingThreshold);
    }
}

@end
