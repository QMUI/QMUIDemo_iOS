//
//  QDNavigationBarSmoothEffectViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/7/28.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDNavigationBarSmoothEffectViewController.h"
#import "UINavigationBar+QMUISmoothEffect.h"

@interface QDNavigationBarSmoothEffectViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *tagView;
@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation QDNavigationBarSmoothEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 指定界面的背景色，让它与 navigationBar.barTintColor 相同，只是后者需要带 alpha 半透明
    self.view.backgroundColor = UIColor.qd_backgroundColor;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    self.tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.tagView.backgroundColor = UIColor.qd_tintColor;
    [self.scrollView addSubview:self.tagView];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.numberOfLines = 0;
    NSMutableAttributedString *tips = [[NSMutableAttributedString alloc] initWithString:@"注意观察 navigationBar 与 self.view 接触的边缘，在 navigationBar 背后没内容的情况下，navigationBar 和 self.view 会融合到一起，看不出分界线，只有当内容滚动到 navigationBar 背后时才能看到分界线和磨砂效果" attributes:@{NSFontAttributeName: UIFontMake(14), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]}];
    NSDictionary *codeAttributes = CodeAttributes(14);
    [tips.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [tips addAttributes:codeAttributes range:codeRange];
    }];
    self.tipsLabel.attributedText = tips;
    [self.scrollView addSubview:self.tipsLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 2. 让 UINavigationBar 固定的磨砂前景色去除，改为自定义的，磨砂效果用 UIBlurEffectStyleLight，从而达到与背景色融合在一起看不到分界线的效果
    self.navigationController.navigationBar.qmui_smoothEffect = YES;
}

- (UIImage *)qmui_navigationBarBackgroundImage {
    return nil;// 3.1 QMUI Demo 默认有背景图，这里为了磨砂，去掉背景图，业务如果本来就没背景图则不需要处理
}

- (UIColor *)qmui_navigationBarBarTintColor {
    // 3.2 去掉 barTintColor，避免盖多一层磨砂前景色影响磨砂效果
    return nil;
}

- (UIColor *)qmui_navigationBarTintColor {
    return UIColor.qd_titleTextColor;
}

- (UIColor *)qmui_titleViewTintColor {
    return self.qmui_navigationBarTintColor;
}

- (NSString *)customNavigationBarTransitionKey {
    return @"smooth";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [QDThemeManager.currentTheme.themeName isEqualToString:QDThemeIdentifierDark] ? UIStatusBarStyleLightContent : QMUIStatusBarStyleDarkContent;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.tagView.qmui_left = self.tagView.qmui_leftWhenCenterInSuperview;
    self.tagView.qmui_top = -self.qmui_navigationBarMaxYInViewCoordinator;
    self.tipsLabel.frame = CGRectMake(24 + self.scrollView.safeAreaInsets.left, self.tagView.qmui_bottom + 24, self.scrollView.qmui_width - UIEdgeInsetsGetHorizontalValue(self.scrollView.safeAreaInsets) - 24 * 2, QMUIViewSelfSizingHeight);
}

@end
