//
//  QDAllAnimationViewController.m
//  qmui
//
//  Created by QMUI Team on 14-9-23.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDAllAnimationViewController.h"
#import "QDActivityIndicator.h"

@interface QDAllAnimationViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIView *shapeView1;
@property(nonatomic, strong) UIView *shapeView2;
@property(nonatomic, strong) UIView *shapeView3;

@property(nonatomic, strong) UIView *shapeView4;
@property(nonatomic, strong) UIView *shapeView5;
@property(nonatomic, strong) UIView *shapeView6;
@property(nonatomic, strong) UIView *shapeView7;
@property(nonatomic, strong) UIView *shapeView8;

@property(nonatomic, strong) QDActivityIndicator *indicatorView;

@property(nonatomic, strong) CALayer *line1;
@property(nonatomic, strong) CALayer *line2;
@property(nonatomic, strong) CALayer *line3;

@end

@implementation QDAllAnimationViewController

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
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.line1 = [CALayer layer];
    self.line1.backgroundColor = UIColorSeparator.CGColor;
    [self.line1 qmui_removeDefaultAnimations];
    [self.scrollView.layer addSublayer:self.line1];
    
    self.line2 = [CALayer layer];
    self.line2.backgroundColor = UIColorSeparator.CGColor;
    [self.line2 qmui_removeDefaultAnimations];
    [self.scrollView.layer addSublayer:self.line2];
    
    self.line3 = [CALayer layer];
    self.line3.backgroundColor = UIColorSeparator.CGColor;
    [self.line3 qmui_removeDefaultAnimations];
    [self.scrollView.layer addSublayer:self.line3];
    
    self.shapeView1 = [[UIView alloc] init];
    self.shapeView1.backgroundColor = UIColorGreen;
    self.shapeView1.layer.cornerRadius = 10;
    [self.scrollView addSubview:self.shapeView1];
    
    self.shapeView2 = [[UIView alloc] init];
    self.shapeView2.backgroundColor = UIColorRed;
    self.shapeView2.layer.cornerRadius = 10;
    [self.scrollView addSubview:self.shapeView2];
    
    self.shapeView3 = [[UIView alloc] init];
    self.shapeView3.backgroundColor = UIColorBlue;
    self.shapeView3.layer.cornerRadius = 10;
    [self.scrollView addSubview:self.shapeView3];
    
    self.shapeView4 = [[UIView alloc] init];
    self.shapeView4.backgroundColor = UIColorBlue;
    self.shapeView4.layer.cornerRadius = 2;
    [self.scrollView addSubview:self.shapeView4];
    
    self.shapeView5 = [[UIView alloc] init];
    self.shapeView5.backgroundColor = UIColorBlue;
    self.shapeView5.layer.cornerRadius = 2;
    [self.scrollView addSubview:self.shapeView5];
    
    self.shapeView6 = [[UIView alloc] init];
    self.shapeView6.backgroundColor = UIColorBlue;
    self.shapeView6.layer.cornerRadius = 2;
    [self.scrollView addSubview:self.shapeView6];
    
    self.shapeView7 = [[UIView alloc] init];
    self.shapeView7.backgroundColor = UIColorBlue;
    self.shapeView7.layer.cornerRadius = 2;
    [self.scrollView addSubview:self.shapeView7];
    
    self.shapeView8 = [[UIView alloc] init];
    self.shapeView8.backgroundColor = UIColorBlue;
    self.shapeView8.layer.cornerRadius = 2;
    [self.scrollView addSubview:self.shapeView8];
    
    self.indicatorView = [[QDActivityIndicator alloc] initWithStyle:QDActivityIndicatorStyleNormal];
    self.indicatorView.tintColor = UIColorGrayLighten;
    [self.indicatorView sizeToFit];
    [self.scrollView addSubview:self.indicatorView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat bigSize = 20;
    CGFloat smallSize = 4;
    CGFloat lineSpace = 40;
    CGFloat minY = lineSpace;
    CGFloat minX = (CGRectGetWidth(self.view.bounds) - 100) / 2;
    
    self.scrollView.frame = self.view.bounds;
    
    self.shapeView1.frame = CGRectMake(minX, minY, bigSize, bigSize);
    self.shapeView2.frame = CGRectMake(minX, minY, bigSize, bigSize);
    self.shapeView3.frame = CGRectMake(minX, minY, bigSize, bigSize);
    
    minY = CGRectGetMaxY(self.shapeView1.frame) + lineSpace;
    
    self.line1.frame = CGRectMake(0, minY, CGRectGetWidth(self.scrollView.bounds), PixelOne);
    
    minY = CGRectGetMaxY(self.line1.frame) + lineSpace;
    minX = (CGRectGetWidth(self.view.bounds) - 220) / 2;
    
    self.shapeView4.frame = CGRectMake(minX, minY, smallSize, smallSize);
    self.shapeView5.frame = CGRectMake(minX, minY, smallSize, smallSize);
    self.shapeView6.frame = CGRectMake(minX, minY, smallSize, smallSize);
    self.shapeView7.frame = CGRectMake(minX, minY, smallSize, smallSize);
    self.shapeView8.frame = CGRectMake(minX, minY, smallSize, smallSize);
    
    minY = CGRectGetMaxY(self.shapeView4.frame) + lineSpace;
    
    self.line2.frame = CGRectMake(0, minY, CGRectGetWidth(self.scrollView.bounds), PixelOne);
    
    minY = CGRectGetMaxY(self.line2.frame) + lineSpace;
    
    self.indicatorView.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.scrollView.bounds), CGRectGetWidth(self.indicatorView.bounds)), minY, CGRectGetWidth(self.indicatorView.bounds), CGRectGetHeight(self.indicatorView.bounds));
    
    minY = CGRectGetMaxY(self.indicatorView.frame) + lineSpace;
    
    self.line3.frame = CGRectMake(0, minY, CGRectGetWidth(self.scrollView.bounds), PixelOne);
    
    minY = CGRectGetMaxY(self.line3.frame);
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), minY);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self beginAnimation];
}

- (void)beginAnimation {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.values = @[ @-5, @0, @10, @40, @70, @80, @75 ];
    positionAnimation.keyTimes = @[ @0, @(5 / 90.0), @(15 / 90.0), @(45 / 90.0), @(75 / 90.0), @(85 / 90.0), @1 ];
    positionAnimation.additive = YES;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.values = @[ @.7, @.9, @1, @.9, @.7 ];
    scaleAnimation.keyTimes = @[ @0, @(15 / 90.0), @(45 / 90.0), @(75 / 90.0), @1 ];
    
    CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.values = @[ @0, @1, @1, @1, @0 ];
    alphaAnimation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[positionAnimation, scaleAnimation, alphaAnimation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.repeatCount = HUGE_VALF;
    group.duration = 1.3;
    
    [self.shapeView1.layer addAnimation:group forKey:@"basic1"];
    group.timeOffset = .43;
    [self.shapeView2.layer addAnimation:group forKey:@"basic2"];
    group.timeOffset = .86;
    [self.shapeView3.layer addAnimation:group forKey:@"basic3"];
    
    CAKeyframeAnimation *position2Animation = [CAKeyframeAnimation animation];
    position2Animation.keyPath = @"position.x";
    position2Animation.duration = 2.4;
    position2Animation.values = @[ @0, @100, @120, @220 ];
    position2Animation.keyTimes = @[ @0, @.35, @.65, @1 ];
    position2Animation.timingFunctions = @[
                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
                                           ];
    position2Animation.additive = YES;
    
    CAKeyframeAnimation *alpha2Animation = [CAKeyframeAnimation animation];
    alpha2Animation.keyPath = @"opacity";
    alpha2Animation.fillMode = kCAFillModeForwards;
    alpha2Animation.removedOnCompletion = NO;
    alpha2Animation.duration = 2.4;
    alpha2Animation.values = @[ @0, @1, @1, @1, @0 ];
    alpha2Animation.keyTimes = @[ @0, @(.5 / 6.0), @(3 / 6.0), @(5.5 / 6.0), @1 ];
    
    CAAnimationGroup *group2 = [CAAnimationGroup animation];
    group2.animations = @[position2Animation, alpha2Animation];
    group2.repeatCount = HUGE_VALF;
    group2.duration = 3.2;
    
    [self.shapeView4.layer addAnimation:group2 forKey:nil];
    group2.timeOffset = .2;
    [self.shapeView5.layer addAnimation:group2 forKey:nil];
    group2.timeOffset = .4;
    [self.shapeView6.layer addAnimation:group2 forKey:nil];
    group2.timeOffset = .6;
    [self.shapeView7.layer addAnimation:group2 forKey:nil];
    group2.timeOffset = .8;
    [self.shapeView8.layer addAnimation:group2 forKey:nil];
    
    [self.indicatorView startAnimating];
}

@end
