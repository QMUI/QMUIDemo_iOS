//
//  QDPopupContainerViewController.m
//  qmuidemo
//
//  Created by MoLice on 15/12/17.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDPopupContainerViewController.h"

@interface QDPopupContainerView : QMUIPopupContainerView

@property(nonatomic, strong) QMUIQQEmotionManager *qqEmotionManager;
@end

@implementation QDPopupContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsZero;
        self.qqEmotionManager = [[QMUIQQEmotionManager alloc] init];
        self.qqEmotionManager.emotionView.sendButton.hidden = YES;
        [self.contentView addSubview:self.qqEmotionManager.emotionView];
    }
    return self;
}

- (CGSize)sizeThatFitsInContentView:(CGSize)size {
    return CGSizeMake(300, 232);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 所有布局都参照 contentView
    self.qqEmotionManager.emotionView.frame = self.contentView.bounds;
}

@end

@interface QDPopupContainerViewController ()

@property(nonatomic, strong) QMUIButton *button1;
@property(nonatomic, strong) QMUIPopupContainerView *popupView1;
@property(nonatomic, strong) QMUIButton *button2;
@property(nonatomic, strong) QDPopupContainerView *popupView2;
@property(nonatomic, strong) CALayer *separatorLayer;
@end

@implementation QDPopupContainerViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.separatorLayer = [CALayer layer];
    self.separatorLayer.backgroundColor = UIColorSeparator.CGColor;
    [self.view.layer addSublayer:self.separatorLayer];
    
    self.button1 = [QDUIHelper generateLightBorderedButton];
    [self.button1 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button1];
    
    self.popupView1 = [[QMUIPopupContainerView alloc] init];
    self.popupView1.imageView.image = [UIImageMake(@"icon_emotion") qmui_imageWithScaleToSize:CGSizeMake(24, 24) contentMode:UIViewContentModeScaleToFill];
    self.popupView1.textLabel.text = @"默认自带 imageView、textLabel，可展示简单的内容";
    self.popupView1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    self.popupView1.hidden = YES;// 默认不显示，需要的时候调用 showWithAnimated: 方法来显示
    [self.view addSubview:self.popupView1];
    
    self.button2 = [QDUIHelper generateDarkFilledButton];
    [self.button2 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setTitle:@"显示自定义浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button2];
    
    self.popupView2 = [[QDPopupContainerView alloc] init];
    self.popupView2.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;// 默认在目标的下方，如果目标下方空间不够，会尝试放到目标上方。若上方空间也不够，则缩小自身的高度。
    self.popupView2.hidden = YES;
    [self.view addSubview:self.popupView2];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat minY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat viewportHeight = CGRectGetHeight(self.view.bounds) - minY;
    self.separatorLayer.frame = CGRectFlatMake(0, minY + viewportHeight / 2.0, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.button1.frame = CGRectSetXY(self.button1.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.button1.frame)), minY + (viewportHeight / 2.0 - CGRectGetHeight(self.button1.frame)) / 2.0);
    [self.popupView1 layoutWithReferenceItemRectInSuperview:self.button1.frame];
    
    self.button2.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.separatorLayer.frame) + (viewportHeight / 2.0 - CGRectGetHeight(self.button2.frame)) / 2.0);
    [self.popupView2 layoutWithReferenceItemRectInSuperview:self.button2.frame];
}

- (void)handleButtonEvent:(QMUIButton *)button {
    if (button == self.button1) {
        if (self.popupView1.isShowing) {
            [self.popupView1 hideWithAnimated:YES];
            [self.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
        } else {
            [self.popupView1 showWithAnimated:YES];
            [self.button1 setTitle:@"隐藏默认浮层" forState:UIControlStateNormal];
        }
        return;
    }
    
    if (button == self.button2) {
        if (self.popupView2.isShowing) {
            [self.popupView2 hideWithAnimated:YES];
            [self.button2 setTitle:@"显示自定义浮层" forState:UIControlStateNormal];
        } else {
            [self.popupView2 showWithAnimated:YES];
            [self.button2 setTitle:@"隐藏自定义浮层" forState:UIControlStateNormal];
        }
        return;
    }
}


@end
