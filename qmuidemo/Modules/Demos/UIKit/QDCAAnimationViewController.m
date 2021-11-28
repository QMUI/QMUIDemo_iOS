//
//  QDCAAnimationViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/7/31.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDCAAnimationViewController.h"

@interface QDCAAnimationViewController ()

@property(nonatomic, strong) CALayer *layer;
@property(nonatomic, strong) QMUIButton *actionButton;
@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDCAAnimationViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.actionButton = [QDUIHelper generateLightBorderedButton];
    [self.actionButton setTitle:@"点击开始动画" forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(handleActionButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionButton];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.numberOfLines = 0;
    NSMutableAttributedString *tips = [[NSMutableAttributedString alloc] initWithString:@"CAAnimation (QMUI) 支持用 block 的形式添加对 animationDidStart 和 animationDidStop 的监听，无需自行设置 delegate，从而避免 CAAnimation.delegate 为 strong 带来的一些内存管理上的麻烦。\n同时你也可以继续使用系统原有的 delegate 方法，互不影响。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]}];
    NSDictionary *codeAttributes = CodeAttributes(12);
    [tips.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [tips addAttributes:codeAttributes range:codeRange];
    }];
    self.tipsLabel.attributedText = tips;
    [self.view addSubview:self.tipsLabel];
    
    self.layer = [CALayer layer];
    [self.layer qmui_removeDefaultAnimations];
    self.layer.cornerRadius = self.actionButton.layer.cornerRadius;
    self.layer.backgroundColor = UIColor.qd_tintColor.CGColor;
    [self.view.layer addSublayer:self.layer];
}

- (void)handleActionButtonEvent:(QMUIButton *)button {
    if ([button.currentTitle isEqualToString:@"回到初始状态"]) {
        [self.layer removeAnimationForKey:@"move"];
        [self.actionButton setTitle:@"点击开始动画" forState:UIControlStateNormal];
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DMakeTranslation(CGRectGetWidth(self.view.bounds) - 24 - CGRectGetMaxX(self.layer.frame), 0, 0);
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = 2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.qmui_animationDidStartBlock = ^(__kindof CAAnimation *aAnimation) {
        button.enabled = NO;
        [button setTitle:@"动画中..." forState:UIControlStateNormal];
    };
    animation.qmui_animationDidStopBlock = ^(__kindof CAAnimation *aAnimation, BOOL finished) {
        button.enabled = YES;
        [button setTitle:@"回到初始状态" forState:UIControlStateNormal];
    };
    [self.layer addAnimation:animation forKey:@"move"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets paddings = UIEdgeInsetsMake(24 + self.qmui_navigationBarMaxYInViewCoordinator, 24 + self.view.safeAreaInsets.left, 24 + self.view.safeAreaInsets.bottom, 24 + self.view.safeAreaInsets.right);
    self.layer.frame = CGRectMake(paddings.left, paddings.top, 64, 64);
    self.actionButton.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.layer.frame) + 24, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), CGRectGetHeight(self.actionButton.frame));
    self.tipsLabel.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.actionButton.frame) + 16, CGRectGetWidth(self.actionButton.frame), QMUIViewSelfSizingHeight);
}

@end
