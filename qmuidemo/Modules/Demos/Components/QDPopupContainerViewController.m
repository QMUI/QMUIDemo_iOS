//
//  QDPopupContainerViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/12/17.
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
@property(nonatomic, strong) QMUIPopupContainerView *popupByAddSubview;
@property(nonatomic, strong) QMUIButton *button2;
@property(nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property(nonatomic, strong) QMUIButton *button3;
@property(nonatomic, strong) QDPopupContainerView *popupWithCustomView;
@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) CALayer *separatorLayer2;
@property(nonatomic, strong) QMUIPopupMenuView *popupAtBarButtonItem;
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
    self.popupByAddSubview = [[QMUIPopupContainerView alloc] init];
    self.popupByAddSubview.imageView.image = [[UIImageMake(@"icon_emotion") qmui_imageResizedInLimitedSize:CGSizeMake(24, 24) resizingMode:QMUIImageResizingModeScaleToFill] qmui_imageWithTintColor:[QDThemeManager sharedInstance].currentTheme.themeTintColor];
    self.popupByAddSubview.textLabel.text = @"默认自带 imageView、textLabel，可展示简单的内容";
    self.popupByAddSubview.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    self.popupByAddSubview.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
    };
    self.popupByAddSubview.sourceView = self.button1;// 相对于 button1 布局
    // 使用方法 1 时，显示浮层前需要先手动隐藏浮层，并自行添加到目标 UIView 上
    self.popupByAddSubview.hidden = YES;
    [self.view addSubview:self.popupByAddSubview];
    
    
    
    self.button2 = [QDUIHelper generateLightBorderedButton];
    [self.button2 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button2];
    
    // 使用方法 2，以 UIWindow 的形式显示到界面上，这种无需默认隐藏，也无需 add 到某个 UIView 上
    self.popupByWindow = [[QMUIPopupMenuView alloc] init];
    self.popupByWindow.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popupByWindow.maskViewBackgroundColor = UIColorMaskWhite;// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
    self.popupByWindow.shouldShowItemSeparator = YES;
    self.popupByWindow.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
        // 利用 itemConfigurationHandler 批量设置所有 item 的样式
        aItem.button.highlightedBackgroundColor = [[QDThemeManager sharedInstance].currentTheme.themeTintColor colorWithAlphaComponent:.2];
    };
    self.popupByWindow.items = @[[QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"QMUIKit" handler:^(QMUIPopupMenuButtonItem *aItem) {
        [aItem.menuView hideWithAnimated:YES];
    }],
                                 [QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Components" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                     [aItem.menuView hideWithAnimated:YES];
                                 }],
                                 [QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Lab" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                     [aItem.menuView hideWithAnimated:YES];
                                 }]];
    self.popupByWindow.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button2 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
    };
    self.popupByWindow.sourceView = self.button2;// 相对于 button2 布局
    
    
    
    self.button3 = [QDUIHelper generateLightBorderedButton];
    [self.button3 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 setTitle:@"显示自定义浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button3];
    
    self.popupWithCustomView = [[QDPopupContainerView alloc] init];
    self.popupWithCustomView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;// 默认在目标的下方，如果目标下方空间不够，会尝试放到目标上方。若上方空间也不够，则缩小自身的高度。
    self.popupWithCustomView.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button3 setTitle:@"显示自定义浮层" forState:UIControlStateNormal];
    };
    
    // 在 UIBarButtonItem 上显示
    self.popupAtBarButtonItem = [[QMUIPopupMenuView alloc] init];
    self.popupAtBarButtonItem.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popupAtBarButtonItem.maximumWidth = 180;
    self.popupAtBarButtonItem.shouldShowItemSeparator = YES;
    self.popupAtBarButtonItem.items = @[[QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"QMUIKit" handler:NULL],
                              [QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Components" handler:NULL],
                              [QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Lab" handler:NULL]];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleRightBarButtonItemEvent)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // popupView3 使用方法 2 显示，并且没有打开 automaticallyHidesWhenUserTap，则需要手动隐藏
    if (self.popupWithCustomView.isShowing) {
        [self.popupWithCustomView hideWithAnimated:animated];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat minY = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat viewportHeight = CGRectGetHeight(self.view.bounds) - minY;
    CGFloat sectionHeight = viewportHeight / 3.0;
    
    self.popupByAddSubview.safetyMarginsOfSuperview = UIEdgeInsetsSetTop(self.popupByAddSubview.safetyMarginsOfSuperview, self.qmui_navigationBarMaxYInViewCoordinator + 10);
    self.button1.frame = CGRectSetXY(self.button1.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.button1.frame)), minY + (sectionHeight - CGRectGetHeight(self.button1.frame)) / 2.0);
    
    self.separatorLayer1.frame = CGRectFlatMake(0, minY + sectionHeight, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.button2.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.button1.frame) + sectionHeight - CGRectGetHeight(self.button2.frame));
    
    self.separatorLayer2.frame = CGRectSetY(self.separatorLayer1.frame, minY + sectionHeight * 2.0);
    
    self.button3.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.button2.frame) + sectionHeight - CGRectGetHeight(self.button3.frame));
    self.popupWithCustomView.sourceRect = [self.button3 convertRect:self.button3.bounds toView:nil];// 将 button3 的坐标转换到相对于 UIWindow 的坐标系里，然后再传给浮层布局
}

- (void)handleButtonEvent:(QMUIButton *)button {
    if (button == self.button1) {
        if (self.popupByAddSubview.isShowing) {
            [self.popupByAddSubview hideWithAnimated:YES];
            [self.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
        } else {
            [self.popupByAddSubview showWithAnimated:YES];
            [self.button1 setTitle:@"隐藏默认浮层" forState:UIControlStateNormal];
        }
        return;
    }
    
    if (button == self.button2) {
        [self.popupByWindow showWithAnimated:YES];
        [self.button2 setTitle:@"隐藏菜单浮层" forState:UIControlStateNormal];
        return;
    }
    
    if (button == self.button3) {
        if (self.popupWithCustomView.isShowing) {
            [self.popupWithCustomView hideWithAnimated:YES];
        } else {
            [self.popupWithCustomView showWithAnimated:YES];
            [self.button3 setTitle:@"隐藏自定义浮层" forState:UIControlStateNormal];
        }
        return;
    }
}

- (void)handleRightBarButtonItemEvent {
    if (self.popupAtBarButtonItem.isShowing) {
        [self.popupAtBarButtonItem hideWithAnimated:YES];
    } else {
        // 相对于右上角的按钮布局
        self.popupAtBarButtonItem.sourceBarItem = self.navigationItem.rightBarButtonItem;
        [self.popupAtBarButtonItem showWithAnimated:YES];
    }
}

@end
