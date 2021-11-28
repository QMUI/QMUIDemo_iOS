//
//  QDDropdownNotificationViewController.m
//  qmuidemo
//
//  Created by molice on 2021/10/27.
//  Copyright © 2021 QMUI Team. All rights reserved.
//

#import "QDDropdownNotificationViewController.h"
#import "QMUIDropdownNotification.h"

@interface QDDropdownNotificationView : UIControl<QMUIDropdownNotificationViewProtocol>

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIVisualEffectView *backgroundView;

@property(nonatomic, assign) UIEdgeInsets padding;
@end

@interface QDDropdownNotificationViewController ()

@property(nonatomic, strong) QMUIButton *button1;
@property(nonatomic, strong) QMUIButton *button2;
@property(nonatomic, strong) QMUIButton *button3;
@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) CALayer *separatorLayer2;
@property(nonatomic, strong) CALayer *separatorLayer3;
@end

@implementation QDDropdownNotificationViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button1 = [QDUIHelper generateLightBorderedButton];
    [self.button1 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 setTitle:@"显示一条自动消失的通知" forState:UIControlStateNormal];
    [self.view addSubview:self.button1];
    
    self.button2 = [QDUIHelper generateLightBorderedButton];
    [self.button2 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setTitle:@"显示一条不可消除的通知" forState:UIControlStateNormal];
    [self.view addSubview:self.button2];
    
    self.button3 = [QDUIHelper generateLightBorderedButton];
    [self.button3 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 setTitle:@"显示一条自定义 View 的通知" forState:UIControlStateNormal];
    [self.view addSubview:self.button3];
    
    self.separatorLayer1 = [CALayer qmui_separatorLayer];
    [self.view.layer addSublayer:self.separatorLayer1];
    
    self.separatorLayer2 = [CALayer qmui_separatorLayer];
    [self.view.layer addSublayer:self.separatorLayer2];
    
    self.separatorLayer3 = [CALayer qmui_separatorLayer];
    [self.view.layer addSublayer:self.separatorLayer3];
}

- (void)handleButtonEvent:(QMUIButton *)button {
    if (button == self.button1) {
        QMUIDropdownNotification *notification = [QMUIDropdownNotification notificationWithViewClass:QMUIDropdownNotificationView.class configuration:^(QMUIDropdownNotificationView * _Nonnull view) {
            view.imageView.image = [UIImage qmui_imageWithColor:UIColor.qd_tintColor size:CGSizeMake(16, 16) cornerRadius:1.5];
            
            view.titleLabel.text = @"王者荣耀给你发了一条私信";
            view.titleLabel.textColor = UIColor.qd_titleTextColor;
            
            view.descriptionLabel.text = @"又输了？点击查看主播的视频教程学学再去玩吧。";
            view.descriptionLabel.textColor = UIColor.qd_mainTextColor;
            
            view.backgroundView.effect = UIVisualEffect.qd_standardBlurEffect;
            view.backgroundView.qmui_foregroundColor = nil;
        }];
        notification.didTouchBlock = ^(__kindof QMUIDropdownNotification * _Nonnull notification) {
            [notification hide];
        };
        [notification show];
        return;
    }
    
    if (button == self.button2) {
        QMUIDropdownNotification *notification = [QMUIDropdownNotification notificationWithViewClass:QMUIDropdownNotificationView.class configuration:^(QMUIDropdownNotificationView * _Nonnull view) {
            view.imageView.image = [UIImage qmui_imageWithColor:UIColor.qd_tintColor size:CGSizeMake(16, 16) cornerRadius:1.5];
            
            view.titleLabel.text = @"不可消失的通知";
            view.titleLabel.textColor = UIColor.qd_titleTextColor;
            
            view.descriptionLabel.text = @"用户一定要点击才可以，俗称牛皮藓";
            view.descriptionLabel.textColor = UIColor.qd_mainTextColor;
            
            view.backgroundView.effect = UIVisualEffect.qd_standardBlurEffect;
            view.backgroundView.qmui_foregroundColor = nil;
        }];
        notification.canHide = NO;// 不可消失
        notification.didTouchBlock = ^(__kindof QMUIDropdownNotification * _Nonnull notification) {
            notification.canHide = YES;// 点击后改为可消失
            [notification hide];
        };
        [notification show];
        return;
    }
    
    if (button == self.button3) {
        QMUIDropdownNotification *notification = [QMUIDropdownNotification notificationWithViewClass:QDDropdownNotificationView.class configuration:^(QDDropdownNotificationView * _Nonnull view) {
            view.imageView.image = [UIImage qmui_imageWithColor:QDCommonUI.randomThemeColor size:CGSizeMake(100, 100) cornerRadius:8];
            view.titleLabel.text = @"自定义通知的标题";
            view.descriptionLabel.text = @"特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字特别长的文字";
            view.timeLabel.text = @"23:10";
        }];
        notification.canHide = NO;// 不可消失
        notification.didTouchBlock = ^(__kindof QMUIDropdownNotification * _Nonnull notification) {
            notification.canHide = YES;// 点击后改为可消失
            [notification hide];
        };
        [notification show];
        return;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat contentMinY = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat buttonSpacingHeight = QDButtonSpacingHeight;
    
    self.button1.frame = CGRectSetXY(self.button1.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.button1.frame)), contentMinY + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.button1.frame)));
    self.separatorLayer1.frame = CGRectFlatMake(0, contentMinY + buttonSpacingHeight, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.button2.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.separatorLayer1.frame) + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.button1.frame)));
    self.separatorLayer2.frame = CGRectSetY(self.separatorLayer1.frame, contentMinY + buttonSpacingHeight * 2);
    
    self.button3.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.separatorLayer2.frame) + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.button1.frame)));
    self.separatorLayer3.frame = CGRectSetY(self.separatorLayer1.frame, contentMinY + buttonSpacingHeight * 3);
}


- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"Dropdown Notification";
}

@end

@implementation QDDropdownNotificationView

// 自动生成 protocol 里定义的 property（必须）
@synthesize notification;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:UIVisualEffect.qd_standardBlurEffect];
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.layer.cornerRadius = 12;
        self.backgroundView.clipsToBounds = YES;
        [self addSubview:self.backgroundView];
        
        self.imageView = [[UIImageView alloc] qmui_initWithSize:CGSizeMake(100, 100)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.titleLabel = UILabel.new;
        self.titleLabel.font = UIFontMediumMake(15);
        self.titleLabel.qmui_lineHeight = round(self.titleLabel.font.pointSize * 1.4);
        self.titleLabel.textColor = UIColor.qd_titleTextColor;
        [self.titleLabel qmui_calculateHeightAfterSetAppearance];
        [self addSubview:self.titleLabel];
        
        self.descriptionLabel = UILabel.new;
        self.descriptionLabel.font = UIFontMake(15);
        self.descriptionLabel.qmui_lineHeight = round(self.descriptionLabel.font.pointSize * 1.4);
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.textColor = UIColor.qd_mainTextColor;
        [self addSubview:self.descriptionLabel];
        
        self.timeLabel = UILabel.new;
        self.timeLabel.font = UIFontMake(12);
        self.timeLabel.textColor = UIColor.qd_descriptionTextColor;
        [self addSubview:self.timeLabel];
        
        self.padding = UIEdgeInsetsMake(18, 16, 18, 16);
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat resultHeight = UIEdgeInsetsGetVerticalValue(self.padding) + CGRectGetHeight(self.imageView.frame);
    return CGSizeMake(size.width, resultHeight);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    
    self.imageView.qmui_top = self.padding.top;
    self.imageView.qmui_left = self.padding.left;
    
    [self.timeLabel sizeToFit];
    self.timeLabel.qmui_right = CGRectGetWidth(self.bounds) - self.padding.right;
    
    CGFloat firstLineHeight = MAX(self.timeLabel.qmui_height, self.titleLabel.qmui_height);
    self.titleLabel.qmui_top = self.padding.top + CGFloatGetCenter(firstLineHeight, self.titleLabel.qmui_height);
    self.timeLabel.qmui_top = self.padding.top + CGFloatGetCenter(firstLineHeight, self.timeLabel.qmui_height);
    
    self.titleLabel.qmui_left = self.imageView.qmui_right + 8;
    self.titleLabel.qmui_extendToRight = self.timeLabel.qmui_left - 8;
    
    CGFloat descriptionLabelMarginTop = 8;
    CGFloat descriptionLabelMaxHeight = CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(self.padding) - firstLineHeight - descriptionLabelMarginTop;
    CGFloat descriptionLabelWidth = self.timeLabel.qmui_right - self.titleLabel.qmui_left;
    CGSize descriptionLabelSize = [self.descriptionLabel sizeThatFits:CGSizeMake(descriptionLabelWidth, CGFLOAT_MAX)];
    self.descriptionLabel.frame = CGRectMake(self.titleLabel.qmui_left, self.padding.top + firstLineHeight + descriptionLabelMarginTop, descriptionLabelWidth, MIN(descriptionLabelSize.height, descriptionLabelMaxHeight));
}

@end
