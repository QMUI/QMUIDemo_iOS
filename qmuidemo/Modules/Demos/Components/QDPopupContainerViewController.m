//
//  QDPopupContainerViewController.m
//  qmuidemo
//
//  Created by MoLice on 15/12/17.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDPopupContainerViewController.h"

@interface QDPopupContainerView : QMUIPopupContainerView

@property(nonatomic, strong) QMUIEmotionInputManager *emotionInputManager;
@end

@implementation QDPopupContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsZero;
        self.emotionInputManager = [[QMUIEmotionInputManager alloc] init];
        self.emotionInputManager.emotionView.emotions = [QDUIHelper qmuiEmotions];
        self.emotionInputManager.emotionView.sendButton.hidden = YES;
        [self.contentView addSubview:self.emotionInputManager.emotionView];
    }
    return self;
}

- (CGSize)sizeThatFitsInContentView:(CGSize)size {
    return CGSizeMake(300, 232);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 所有布局都参照 contentView
    self.emotionInputManager.emotionView.frame = self.contentView.bounds;
}

@end

@interface QDPopupContainerViewController ()

@property(nonatomic, strong) QMUIButton *button1;
@property(nonatomic, strong) QMUIPopupContainerView *popupView1;
@property(nonatomic, strong) QMUIButton *button2;
@property(nonatomic, strong) QMUIPopupMenuView *popupView2;
@property(nonatomic, strong) QMUIButton *button3;
@property(nonatomic, strong) QDPopupContainerView *popupView3;
@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) CALayer *separatorLayer2;
@end

@implementation QDPopupContainerViewController

- (void)initSubviews {
    [super initSubviews];
    
    __weak __typeof(self)weakSelf = self;
    
    self.separatorLayer1 = [CALayer layer];
    [self.separatorLayer1 qmui_removeDefaultAnimations];
    self.separatorLayer1.backgroundColor = UIColorSeparator.CGColor;
    [self.view.layer addSublayer:self.separatorLayer1];
    
    self.separatorLayer2 = [CALayer layer];
    [self.separatorLayer2 qmui_removeDefaultAnimations];
    self.separatorLayer2.backgroundColor = UIColorSeparator.CGColor;
    [self.view.layer addSublayer:self.separatorLayer2];
    
    self.button1 = [QDUIHelper generateLightBorderedButton];
    [self.button1 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button1];
    
    // 使用方法 1，以 addSubview: 的形式显示到界面上
    self.popupView1 = [[QMUIPopupContainerView alloc] init];
    self.popupView1.imageView.image = [[UIImageMake(@"icon_emotion") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24) contentMode:UIViewContentModeScaleToFill] qmui_imageWithTintColor:[QDThemeManager sharedInstance].currentTheme.themeTintColor];
    self.popupView1.textLabel.text = @"默认自带 imageView、textLabel，可展示简单的内容";
    self.popupView1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    self.popupView1.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
    };
    // 使用方法 1 时需要隐藏浮层，并自行添加到目标 UIView 上
    self.popupView1.hidden = YES;
    [self.view addSubview:self.popupView1];
    
    
    
    self.button2 = [QDUIHelper generateLightBorderedButton];
    [self.button2 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button2];
    
    // 使用方法 2，以 UIWindow 的形式显示到界面上，这种无需默认隐藏，也无需 add 到某个 UIView 上
    self.popupView2 = [[QMUIPopupMenuView alloc] init];
    self.popupView2.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popupView2.maskViewBackgroundColor = UIColorMaskWhite;// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
    self.popupView2.maximumWidth = 180;
    self.popupView2.shouldShowItemSeparator = YES;
    self.popupView2.separatorInset = UIEdgeInsetsMake(0, self.popupView2.padding.left, 0, self.popupView2.padding.right);
    self.popupView2.items = @[[QMUIPopupMenuItem itemWithImage:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"QMUIKit" handler:^{
                                  [weakSelf.popupView2 hideWithAnimated:YES];
                              }],
                              [QMUIPopupMenuItem itemWithImage:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Components" handler:^{
                                  [weakSelf.popupView2 hideWithAnimated:YES];
                              }],
                              [QMUIPopupMenuItem itemWithImage:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Lab" handler:^{
                                  [weakSelf.popupView2 hideWithAnimated:YES];
                              }]];
    self.popupView2.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button2 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
    };
    
    
    
    self.button3 = [QDUIHelper generateLightBorderedButton];
    [self.button3 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 setTitle:@"显示自定义浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button3];
    
    self.popupView3 = [[QDPopupContainerView alloc] init];
    self.popupView3.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;// 默认在目标的下方，如果目标下方空间不够，会尝试放到目标上方。若上方空间也不够，则缩小自身的高度。
    self.popupView3.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button3 setTitle:@"显示自定义浮层" forState:UIControlStateNormal];
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // popupView3 使用方法 2 显示，并且没有打开 automaticallyHidesWhenUserTap，则需要手动隐藏
    if (self.popupView3.isShowing) {
        [self.popupView3 hideWithAnimated:animated];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat minY = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat viewportHeight = CGRectGetHeight(self.view.bounds) - minY;
    CGFloat sectionHeight = viewportHeight / 3.0;
    
    self.button1.frame = CGRectSetXY(self.button1.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.button1.frame)), minY + (sectionHeight - CGRectGetHeight(self.button1.frame)) / 2.0);
    self.popupView1.safetyMarginsOfSuperview = UIEdgeInsetsSetTop(self.popupView1.safetyMarginsOfSuperview, self.qmui_navigationBarMaxYInViewCoordinator + 10);
    [self.popupView1 layoutWithTargetView:self.button1];// 相对于 button1 布局
    
    self.separatorLayer1.frame = CGRectFlatMake(0, minY + sectionHeight, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.button2.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.button1.frame) + sectionHeight - CGRectGetHeight(self.button2.frame));
    [self.popupView2 layoutWithTargetView:self.button2];// 相对于 button2 布局
    
    self.separatorLayer2.frame = CGRectSetY(self.separatorLayer1.frame, minY + sectionHeight * 2.0);
    
    self.button3.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.button2.frame) + sectionHeight - CGRectGetHeight(self.button3.frame));
    [self.popupView3 layoutWithTargetRectInScreenCoordinate:[self.button3 convertRect:self.button3.bounds toView:nil]];// 将 button3 的坐标转换到相对于 UIWindow 的坐标系里，然后再传给浮层布局
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
        [self.popupView2 showWithAnimated:YES];
        [self.button2 setTitle:@"隐藏菜单浮层" forState:UIControlStateNormal];
        return;
    }
    
    if (button == self.button3) {
        if (self.popupView3.isShowing) {
            [self.popupView3 hideWithAnimated:YES];
        } else {
            [self.popupView3 showWithAnimated:YES];
            [self.button3 setTitle:@"隐藏自定义浮层" forState:UIControlStateNormal];
        }
        return;
    }
}


@end
