//
//  QDRippleAnimationViewController.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/9/11.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDRippleAnimationViewController.h"

#define RippleAnimationAvatarSize CGSizeMake(100, 100)
#define RippleAnimationExpandSizeValue 40.0
#define RippleAnimationDuration 2.0
#define RippleAnimationLineWidth 1.0

@interface QDRippleAnimationViewController ()

@end

@implementation QDRippleAnimationViewController {
    
    UIScrollView *_scrollView;
    
    UILabel     *_textLabel;
    
    UIView      *_avatarWrapView1;
    UIImageView *_avatarImageView1;
    UIView      *_avatarWrapView2;
    UIImageView *_avatarImageView2;
    UIBezierPath *_initPath;
    UIBezierPath *_finalPath;
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
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.numberOfLines = 0;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = UIColorGray4;
    _textLabel.font = UIFontMake(16);
    _textLabel.text = @"第一个动画使用CAAnimationGroup来实现，第二个动画使用CAReplicatorLayer来实现。";
    [_scrollView addSubview:_textLabel];
    
    _avatarWrapView1 = [[UIView alloc] init];
    [_scrollView addSubview:_avatarWrapView1];
    
    _avatarImageView1 = [[UIImageView alloc] initWithImage:UIImageMake(@"image0")];
    _avatarImageView1.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView1.clipsToBounds = YES;
    [_avatarWrapView1 addSubview:_avatarImageView1];
    
    _avatarWrapView2 = [[UIView alloc] init];
    [_scrollView addSubview:_avatarWrapView2];
    
    _avatarImageView2 = [[UIImageView alloc] initWithImage:UIImageMake(@"image0")];
    _avatarImageView2.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView2.clipsToBounds = YES;
    [_avatarWrapView2 addSubview:_avatarImageView2];
    
    _avatarImageView1.layer.cornerRadius = RippleAnimationAvatarSize.height / 2;
    _avatarImageView2.layer.cornerRadius = RippleAnimationAvatarSize.height / 2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _initPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, RippleAnimationAvatarSize.width, RippleAnimationAvatarSize.height), RippleAnimationLineWidth, RippleAnimationLineWidth)];
    _finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(- RippleAnimationExpandSizeValue, - RippleAnimationExpandSizeValue, RippleAnimationAvatarSize.width + RippleAnimationExpandSizeValue * 2, RippleAnimationAvatarSize.height + RippleAnimationExpandSizeValue * 2), RippleAnimationLineWidth, RippleAnimationLineWidth)];
    
    [self beginAnimation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _scrollView.frame = self.view.bounds;
    
    CGFloat insetLeft = 20;
    CGFloat labelWidth = CGRectGetWidth(self.view.bounds) - insetLeft * 2;
    CGSize labelSize = [_textLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
    _textLabel.frame = CGRectFlatMake(insetLeft, 40, labelWidth, labelSize.height);
    
    _avatarWrapView1.frame = CGRectMake(CGFloatGetCenter(CGRectGetWidth(self.view.bounds), RippleAnimationAvatarSize.width), CGRectGetMaxY(_textLabel.frame) + 70, RippleAnimationAvatarSize.width, RippleAnimationAvatarSize.height);
    _avatarWrapView2.frame = CGRectMake(CGRectGetMinX(_avatarWrapView1.frame), CGRectGetMaxY(_avatarWrapView1.frame) + 100, RippleAnimationAvatarSize.width, RippleAnimationAvatarSize.height);
    _avatarImageView1.frame = _avatarWrapView1.bounds;
    _avatarImageView2.frame = _avatarWrapView2.bounds;
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.bounds), CGRectGetMaxY(_avatarWrapView2.frame) + 50);
}

- (void)beginAnimation {
    [self animationAvatarInView:_avatarWrapView1 animated:YES];
    [_avatarWrapView1 bringSubviewToFront:_avatarImageView1];
    [self animationReplicatorAvatarInView:_avatarWrapView2 animated:YES];
    [_avatarWrapView2 bringSubviewToFront:_avatarImageView2];
}

- (void)animationAvatarInView:(UIView *)view animated:(BOOL)animated {

    NSMutableArray *_layers = [[NSMutableArray alloc] init];
    NSInteger count = view.layer.sublayers.count;
    for (int i = 0; i < count; i++) {
        if ([view.layer.sublayers[i] isKindOfClass:[CAShapeLayer class]]) {
            [_layers addObject:view.layer.sublayers[i]];
            [view.layer.sublayers[i] setHidden:YES];
        }
    }
    count = _layers.count;
    for (int i = 0; i < count; i++) {
        [_layers[i] removeFromSuperlayer];
    }

    if (!animated) {
        return;
    }

    CAShapeLayer *layer1 = [self animationLayerWithPath:_initPath];
    layer1.frame = CGRectMake(0, 0, RippleAnimationAvatarSize.width, RippleAnimationAvatarSize.height);
    [view.layer addSublayer:layer1];

    CAShapeLayer *layer2 = [self animationLayerWithPath:_initPath];
    layer2.frame = layer1.frame;
    [view.layer addSublayer:layer2];

    CAShapeLayer *layer3 = [self animationLayerWithPath:_initPath];
    layer3.frame = layer1.frame;
    [view.layer addSublayer:layer3];

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)_initPath.CGPath;
    pathAnimation.toValue = (id)_finalPath.CGPath;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[pathAnimation, opacityAnimation];
    groupAnimation.duration = RippleAnimationDuration;
    groupAnimation.repeatCount = HUGE_VALF;

    [layer1 addAnimation:groupAnimation forKey:nil];
    groupAnimation.beginTime = CACurrentMediaTime() + RippleAnimationDuration / 3;
    [layer2 addAnimation:groupAnimation forKey:nil];
    groupAnimation.beginTime = CACurrentMediaTime() + 2 * RippleAnimationDuration / 3;
    [layer3 addAnimation:groupAnimation forKey:nil];
}

- (void)animationReplicatorAvatarInView:(UIView *)view animated:(BOOL)animated {
    
    NSMutableArray *_layers = [[NSMutableArray alloc] init];
    NSInteger count = view.layer.sublayers.count;
    for (int i = 0; i < count; i++) {
        if ([view.layer.sublayers[i] isKindOfClass:[CAReplicatorLayer class]]) {
            [_layers addObject:view.layer.sublayers[i]];
            [view.layer.sublayers[i] setHidden:YES];
        }
    }
    count = _layers.count;
    for (int i = 0; i < count; i++) {
        [_layers[i] removeFromSuperlayer];
    }
    
    if (!animated) {
        return;
    }
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = RippleAnimationDuration / 3;
    replicatorLayer.backgroundColor = UIColorClear.CGColor;
    [view.layer addSublayer:replicatorLayer];
    
    CAShapeLayer *layer = [self animationLayerWithPath:_initPath];
    layer.frame = CGRectMake(0, 0, RippleAnimationAvatarSize.width, RippleAnimationAvatarSize.height);
    [replicatorLayer addSublayer:layer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)_initPath.CGPath;
    pathAnimation.toValue = (id)_finalPath.CGPath;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[pathAnimation, opacityAnimation];
    groupAnimation.duration = RippleAnimationDuration;
    groupAnimation.repeatCount = HUGE_VALF;
    
    [layer addAnimation:groupAnimation forKey:nil];
}

- (CAShapeLayer *)animationLayerWithPath:(UIBezierPath *)path {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = UIColorBlue.CGColor;
    layer.fillColor = UIColorClear.CGColor;
    layer.lineWidth = RippleAnimationLineWidth;
    return layer;
}

@end
