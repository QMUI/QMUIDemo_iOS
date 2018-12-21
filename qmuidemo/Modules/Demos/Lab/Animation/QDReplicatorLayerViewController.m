//
//  QDReplicatorLayerViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/9/23.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

static const CGFloat kAnimationDuration = 0.9;

static const CGFloat kSubLayerWidth = 8;
static const CGFloat kSubLayerHeiht = 26;
static const CGFloat kSubLayerSpace = 4;
static const NSInteger kSubLayerCount = 3;

static const CGFloat kCircleContainerSize = 80;
static const NSInteger kCircleCount = 12;
static const CGFloat kCircleSize = 12;

#import "QDReplicatorLayerViewController.h"

@interface QDReplicatorLayerViewController ()

@property(nonatomic, strong) CALayer *line1;
@property(nonatomic, strong) CALayer *line2;

@end

@implementation QDReplicatorLayerViewController {
    CAReplicatorLayer *_containerLayer1;
    CAReplicatorLayer *_containerLayer2;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)handleWillEnterForeground:(NSNotification *)notification {
    [self beginAnimation];
}

- (void)initSubviews {
    [super initSubviews];
    
    _containerLayer1 = [CAReplicatorLayer layer];
    _containerLayer1.masksToBounds = YES;
    _containerLayer1.instanceCount = kSubLayerCount;
    _containerLayer1.instanceDelay = kAnimationDuration / _containerLayer1.instanceCount;
    _containerLayer1.instanceTransform = CATransform3DMakeTranslation(kSubLayerWidth + kSubLayerSpace, 0, 0);
    [self.view.layer addSublayer:_containerLayer1];
    
    _containerLayer2 = [CAReplicatorLayer layer];
    _containerLayer2.masksToBounds = YES;
    _containerLayer2.instanceCount = kCircleCount;
    _containerLayer2.instanceDelay = kAnimationDuration / _containerLayer2.instanceCount;
    _containerLayer2.instanceTransform = CATransform3DMakeRotation(AngleWithDegrees(360 / _containerLayer2.instanceCount), 0, 0, 1);
    [self.view.layer addSublayer:_containerLayer2];
    
    self.line1 = [CALayer layer];
    self.line1.backgroundColor = UIColorSeparator.CGColor;
    [self.line1 qmui_removeDefaultAnimations];
    [self.view.layer addSublayer:self.line1];
    
    self.line2 = [CALayer layer];
    self.line2.backgroundColor = UIColorSeparator.CGColor;
    [self.line2 qmui_removeDefaultAnimations];
    [self.view.layer addSublayer:self.line2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self beginAnimation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat lineSpace = 60;
    CGFloat minY = self.qmui_navigationBarMaxYInViewCoordinator + lineSpace;
    CGFloat width1 = kSubLayerWidth * kSubLayerCount + (kSubLayerCount - 1) * kSubLayerSpace;
    
    _containerLayer1.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), width1), minY, width1, kSubLayerHeiht);
    
    minY = CGRectGetMaxY(_containerLayer1.frame) + lineSpace;
    
    self.line1.frame = CGRectMake(0, minY, CGRectGetWidth(self.view.bounds), PixelOne);
    
    minY = CGRectGetMaxY(self.line1.frame) + lineSpace;
    
    _containerLayer2.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), kCircleContainerSize), minY, kCircleContainerSize, kCircleContainerSize);
    
    minY = CGRectGetMaxY(_containerLayer2.frame) + lineSpace;
    
    self.line2.frame = CGRectMake(0, minY, CGRectGetWidth(self.view.bounds), PixelOne);
}

- (void)beginAnimation {
    
    CALayer *subLayer1 = [CALayer layer];
    subLayer1.backgroundColor = UIColorGreen.CGColor;
    subLayer1.frame = CGRectMake(0, kSubLayerHeiht - 6, kSubLayerWidth, kSubLayerHeiht);
    subLayer1.cornerRadius = 2;
    [_containerLayer1 addSublayer:subLayer1];
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation1.fromValue = @(kSubLayerHeiht * 1.5 - 6);
    animation1.toValue = @(kSubLayerHeiht * 0.5);
    animation1.repeatCount = HUGE;
    animation1.duration = kAnimationDuration;
    animation1.autoreverses = YES;
    [subLayer1 addAnimation:animation1 forKey:nil];
    
    CALayer *subLayer2 = [CALayer layer];
    subLayer2.backgroundColor = UIColorBlue.CGColor;
    subLayer2.frame = CGRectMake((kCircleContainerSize - kCircleSize) / 2, 0, kCircleSize, kCircleSize);
    subLayer2.cornerRadius = kCircleSize / 2;
    subLayer2.transform = CATransform3DMakeScale(0, 0, 0);
    [_containerLayer2 addSublayer:subLayer2];
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = @(1);
    animation2.toValue = @(0.1);
    animation2.repeatCount = HUGE;
    animation2.duration = kAnimationDuration;
    [subLayer2 addAnimation:animation2 forKey:nil];
}

@end
