//
//  QDAboutViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2016/11/5.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDAboutViewController.h"
#import "QDAAViewController.h"

@interface QDAboutViewController ()

@property(nonatomic, strong) UIImage *themeAboutLogoImage;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *logoImageView;
@property(nonatomic, strong) QMUIButton *versionButton;
@property(nonatomic, strong) QMUIButton *websiteButton;
@property(nonatomic, strong) QMUIButton *documentButton;
@property(nonatomic, strong) QMUIButton *gitHubButton;
@property(nonatomic, strong) UILabel *copyrightLabel;
@property(nonatomic, assign) NSInteger tapCount;
@end

@implementation QDAboutViewController

- (void)didInitialize {
    [super didInitialize];
    
    NSString *imagePath = [[NSUserDefaults standardUserDefaults] objectForKey:[self userDefaultsKeyForAboutLogoImage]];
    if (imagePath) {
        UIImage *aboutLogoImage = [UIImage imageWithContentsOfFile:imagePath];
        if (aboutLogoImage) {
            self.themeAboutLogoImage = aboutLogoImage;
            return;
        }
    }
    
    // 如果是第一次进来，则在 viewDidAppear 之后再让 logo 图渐变显示出来
    __weak __typeof(self)weakSelf = self;
    self.qmui_didAppearAndLoadDataBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf transitLogoImageIfNeeded];
    };
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *aboutLogoImage = UIImageMake(@"about_logo_monochrome");
        UIImage *blendedAboutLogoImage = [aboutLogoImage qmui_imageWithBlendColor:UIColor.qd_tintColor];
        [self saveImageAsFile:blendedAboutLogoImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.themeAboutLogoImage = blendedAboutLogoImage;
            self.qmui_dataLoaded = YES;
        });
    });
}

- (void)initSubviews {
    [super initSubviews];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:self.themeAboutLogoImage ?: UIImageMake(@"about_logo_monochrome")];
    self.logoImageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.logoImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tap.numberOfTapsRequired = 3;
    [self.logoImageView addGestureRecognizer:tap];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionButton = [[QMUIButton alloc] init];
    self.versionButton.titleLabel.font = UIFontMake(14);
    [self.versionButton setTitleColor:UIColor.qd_mainTextColor forState:UIControlStateNormal];
    [self.versionButton setTitle:[NSString stringWithFormat:@"版本 %@", appVersion] forState:UIControlStateNormal];
    [self.versionButton sizeToFit];
    self.versionButton.qmui_outsideEdge = UIEdgeInsetsMake(-12, -12, -12, -12);
    [self.versionButton addTarget:self action:@selector(handleVersionButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.versionButton];
    
    self.websiteButton = [self generateCellButtonWithTitle:@"访问官网"];
    self.websiteButton.qmui_borderPosition = QMUIViewBorderPositionTop;
    [self.websiteButton addTarget:self action:@selector(handleWebsiteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.websiteButton];
    
    self.documentButton = [self generateCellButtonWithTitle:@"功能列表"];
    self.documentButton.qmui_borderPosition = QMUIViewBorderPositionTop;
    [self.documentButton addTarget:self action:@selector(handleDocumentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.documentButton];
    
    self.gitHubButton = [self generateCellButtonWithTitle:@"GitHub"];
    self.gitHubButton.qmui_borderPosition = QMUIViewBorderPositionTop | QMUIViewBorderPositionBottom;
    [self.gitHubButton addTarget:self action:@selector(handleGitHubButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.gitHubButton];
    
    self.copyrightLabel = [[UILabel alloc] init];
    self.copyrightLabel.numberOfLines = 0;
    self.copyrightLabel.attributedText = [[NSAttributedString alloc] initWithString:@"© 2019 QMUI Team All Rights Reserved." attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
    [self.scrollView addSubview:self.copyrightLabel];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"关于";
}

- (void)transitLogoImageIfNeeded {
    if (self.themeAboutLogoImage && self.logoImageView && self.logoImageView.image != self.themeAboutLogoImage) {
        UIImageView *templateImageView = [[UIImageView alloc] initWithFrame:self.logoImageView.bounds];
        templateImageView.image = self.themeAboutLogoImage;
        templateImageView.alpha = 0;
        [self.logoImageView addSubview:templateImageView];
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            templateImageView.alpha = 1;
        } completion:^(BOOL finished) {
            self.logoImageView.image = self.themeAboutLogoImage;
            [templateImageView removeFromSuperview];
        }];
    }
}

- (QMUIButton *)generateCellButtonWithTitle:(NSString *)title {
    QMUIButton *button = [[QMUIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TableViewCellTitleLabelColor ?: UIColorBlack forState:UIControlStateNormal];
    button.titleLabel.font = UIFontMake(15);
    button.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
    button.qmui_borderColor = TableViewSeparatorColor;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    button.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
    return button;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat navigationBarHeight = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat versionLabelMarginTop = 10;
    CGFloat buttonHeight = TableViewCellNormalHeight;
    
    UIEdgeInsets padding = UIEdgeInsetsMake(24, 24, 24, 24);
    if (self.view.qmui_safeAreaInsets.bottom > 0) {
        padding.bottom = padding.bottom - 20;
    }
    
    self.scrollView.frame = self.view.bounds;
    
    if (IS_IPHONE && IS_LANDSCAPE) {
        CGFloat leftWidth = flat(CGRectGetWidth(self.scrollView.bounds) / 2);
        CGFloat rightWidth = CGRectGetWidth(self.scrollView.bounds) - leftWidth;
        
        CGFloat leftHeight = CGRectGetHeight(self.logoImageView.frame) + versionLabelMarginTop + CGRectGetHeight(self.versionButton.frame);
        CGFloat leftMinY = CGFloatGetCenter(CGRectGetHeight(self.scrollView.bounds) - navigationBarHeight, leftHeight);
        self.logoImageView.frame = CGRectSetXY(self.logoImageView.frame, CGFloatGetCenter(leftWidth, CGRectGetHeight(self.logoImageView.frame)), leftMinY);
        self.versionButton.frame = CGRectSetXY(self.versionButton.frame, CGRectGetMinXHorizontallyCenter(self.logoImageView.frame, self.versionButton.frame), CGRectGetMaxY(self.logoImageView.frame) + versionLabelMarginTop);
        
        CGFloat contentWidthInRight = rightWidth - UIEdgeInsetsGetHorizontalValue(padding);
        self.websiteButton.frame = CGRectMake(leftWidth + padding.left, CGRectGetMinY(self.logoImageView.frame) + 10, contentWidthInRight, buttonHeight);
        self.documentButton.frame = CGRectSetY(self.websiteButton.frame, CGRectGetMaxY(self.websiteButton.frame));
        self.gitHubButton.frame = CGRectSetY(self.websiteButton.frame, CGRectGetMaxY(self.documentButton.frame));
        
        CGFloat copyrightLabelHeight = [self.copyrightLabel sizeThatFits:CGSizeMake(contentWidthInRight, CGFLOAT_MAX)].height;
        self.copyrightLabel.frame = CGRectFlatMake(leftWidth + padding.left, CGRectGetHeight(self.scrollView.bounds) - UIEdgeInsetsGetVerticalValue(self.scrollView.qmui_contentInset) - padding.bottom - copyrightLabelHeight, contentWidthInRight, copyrightLabelHeight);
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - UIEdgeInsetsGetVerticalValue(self.scrollView.qmui_contentInset));
    } else {
        
        CGFloat containerHeight = CGRectGetHeight(self.scrollView.bounds) - UIEdgeInsetsGetVerticalValue(self.scrollView.qmui_contentInset) - UIEdgeInsetsGetVerticalValue(padding);
        CGFloat buttonMarginTop = 36;
        CGFloat mainContentHeight = CGRectGetHeight(self.logoImageView.frame) + versionLabelMarginTop + CGRectGetHeight(self.versionButton.frame) + buttonMarginTop + buttonHeight * 2;
        CGFloat mainContentMinY = padding.top + (containerHeight - mainContentHeight) / 6;
        
        if (DEVICE_HEIGHT <= [QMUIHelper screenSizeFor40Inch].height) {
            buttonMarginTop -= 8;
            buttonHeight -= 8;
        }
        
        self.logoImageView.frame = CGRectSetXY(self.logoImageView.frame, CGRectGetMinXHorizontallyCenterInParentRect(self.scrollView.bounds, self.logoImageView.frame), mainContentMinY);
        
        self.versionButton.frame = CGRectSetXY(self.versionButton.frame, CGRectGetMinXHorizontallyCenterInParentRect(self.scrollView.bounds, self.versionButton.frame), CGRectGetMaxY(self.logoImageView.frame) + versionLabelMarginTop);
        
        self.websiteButton.frame = CGRectMake(0, CGRectGetMaxY(self.versionButton.frame) + buttonMarginTop, CGRectGetWidth(self.scrollView.bounds), buttonHeight);
        self.documentButton.frame = CGRectSetY(self.websiteButton.frame, CGRectGetMaxY(self.websiteButton.frame));
        self.gitHubButton.frame = CGRectSetY(self.documentButton.frame, CGRectGetMaxY(self.documentButton.frame));
        
        CGFloat copyrightLabelWidth = CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
        CGFloat copyrightLabelHeight = [self.copyrightLabel sizeThatFits:CGSizeMake(copyrightLabelWidth, CGFLOAT_MAX)].height;
        self.copyrightLabel.frame = CGRectFlatMake(padding.left, CGRectGetHeight(self.scrollView.bounds) - UIEdgeInsetsGetVerticalValue(self.scrollView.qmui_contentInset) - padding.bottom - copyrightLabelHeight, copyrightLabelWidth, copyrightLabelHeight);
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.copyrightLabel.frame) + padding.bottom);
    }
}

- (NSString *)userDefaultsKeyForAboutLogoImage {
    return [NSString stringWithFormat:@"about_logo_%@@%.0fx.png", QDThemeManager.currentTheme.themeName, ScreenScale];
}

- (void)saveImageAsFile:(UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *imageName = [self userDefaultsKeyForAboutLogoImage];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    if ([imageData writeToFile:imagePath atomically:NO]) {
        [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:imageName];
    }
}

- (void)handleVersionButtonEvent:(QMUIButton *)button {
    [self openUrlString:@"https://github.com/Tencent/QMUI_iOS/releases"];
}

- (void)handleWebsiteButtonEvent:(QMUIButton *)button {
    [self openUrlString:@"https://qmuiteam.com/ios"];
}

- (void)handleDocumentButtonEvent:(QMUIButton *)button {
    [self openUrlString:@"https://qmuiteam.com/ios/page/document.html"];
}

- (void)handleGitHubButtonEvent:(QMUIButton *)button {
    [self openUrlString:@"https://github.com/QMUI/QMUI_iOS"];
}

- (void)openUrlString:(NSString *)urlString {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:urlString];
    if (@available(iOS 10, *)) {
        [application openURL:url options:@{} completionHandler:nil];
    } else {
        [application openURL:url];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    QDAAViewController *viewController = [[QDAAViewController alloc] init];
    [viewController show];
}

@end
