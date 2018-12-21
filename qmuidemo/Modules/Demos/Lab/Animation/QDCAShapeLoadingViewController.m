//
//  QDCAShapeLoadingViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/9/16.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

static const CGFloat kLayerSizeValue = 60;
static const CGFloat kPathLineWidth = 6;
static const CGFloat kAnimationDuration = 1.5;

#import "QDCAShapeLoadingViewController.h"

@interface QDCAShapeLoadingViewController ()

@property(nonatomic, strong) CALayer *line1;
@property(nonatomic, strong) CALayer *line2;

@end

@implementation QDCAShapeLoadingViewController {
    CAShapeLayer *_shapeLayer1;
    CAShapeLayer *_shapeLayer2;
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
    
    self.line1 = [CALayer layer];
    self.line1.backgroundColor = UIColorSeparator.CGColor;
    [self.line1 qmui_removeDefaultAnimations];
    [self.view.layer addSublayer:self.line1];
    
    self.line2 = [CALayer layer];
    self.line2.backgroundColor = UIColorSeparator.CGColor;
    [self.line2 qmui_removeDefaultAnimations];
    [self.view.layer addSublayer:self.line2];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kLayerSizeValue, kLayerSizeValue)];
    _shapeLayer1 = [CAShapeLayer layer];
    _shapeLayer1.strokeColor = UIColorTheme1.CGColor;
    _shapeLayer1.fillColor = UIColorClear.CGColor;
    _shapeLayer1.lineCap = kCALineCapRound;
    _shapeLayer1.strokeStart = 0;
    _shapeLayer1.strokeEnd = 0.4;
    _shapeLayer1.lineWidth = kPathLineWidth;
    _shapeLayer1.path = path.CGPath;
    
    [self.view.layer addSublayer:_shapeLayer1];
    _shapeLayer2 = [CAShapeLayer layer];
    _shapeLayer2.strokeColor = UIColorTheme3.CGColor;
    _shapeLayer2.fillColor = UIColorClear.CGColor;
    _shapeLayer2.lineCap = kCALineCapRound;
    _shapeLayer2.strokeStart = -0.5;
    _shapeLayer2.strokeEnd = 0;
    _shapeLayer2.lineWidth = kPathLineWidth;
    _shapeLayer2.path = path.CGPath;
    [self.view.layer addSublayer:_shapeLayer2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self beginAnimation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat lineSpace = 40;
    CGFloat minY = lineSpace;
    
    _shapeLayer1.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), kLayerSizeValue), self.qmui_navigationBarMaxYInViewCoordinator + minY, kLayerSizeValue, kLayerSizeValue);
    
    minY = CGRectGetMaxY(_shapeLayer1.frame) + lineSpace;
    
    self.line1.frame = CGRectMake(0, minY, CGRectGetWidth(self.view.bounds), PixelOne);
    
    minY = CGRectGetMaxY(self.line1.frame) + lineSpace;
    
    _shapeLayer2.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), kLayerSizeValue), minY, kLayerSizeValue, kLayerSizeValue);
    
    minY = CGRectGetMaxY(_shapeLayer2.frame) + lineSpace;
    
    self.line2.frame = CGRectMake(0, minY, CGRectGetWidth(self.view.bounds), PixelOne);
}

- (void)beginAnimation {
    
    // layer1
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation1.duration = kAnimationDuration;
    animation1.fromValue = @0;
    animation1.toValue = @(M_PI * 2);
    animation1.repeatCount = INFINITY; // HUGE
    [_shapeLayer1 addAnimation:animation1 forKey:nil];
    
    // layer2
    
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(-0.5);
    startAnimation.toValue = @(1);
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0);
    endAnimation.toValue = @(1);
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[startAnimation, endAnimation];
    groupAnimation.duration = kAnimationDuration;
    groupAnimation.repeatCount = INFINITY;
    [_shapeLayer2 addAnimation:groupAnimation forKey:nil];
}

@end
