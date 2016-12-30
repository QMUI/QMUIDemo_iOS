//
//  QDAboutViewController.m
//  qmuidemo
//
//  Created by MoLice on 2016/11/5.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDAboutViewController.h"

@interface QDAboutViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *logoImageView;
@property(nonatomic, strong) UILabel *versionLabel;
@property(nonatomic, strong) QMUIButton *websiteButton;
@property(nonatomic, strong) QMUIButton *gitHubButton;
@property(nonatomic, strong) UILabel *copyrightLabel;
@end

@implementation QDAboutViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"about_logo")];
    [self.scrollView addSubview:self.logoImageView];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorGray3];
    self.versionLabel.text = [NSString stringWithFormat:@"版本 %@", appVersion];
    [self.versionLabel sizeToFit];
    [self.scrollView addSubview:self.versionLabel];
    
    self.websiteButton = [self generateCellButtonWithTitle:@"访问官网"];
    self.websiteButton.qmui_borderPosition = QMUIBorderViewPositionTop;
    [self.websiteButton addTarget:self action:@selector(handleWebsiteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.websiteButton];
    
    self.gitHubButton = [self generateCellButtonWithTitle:@"GitHub"];
    self.gitHubButton.qmui_borderPosition = QMUIBorderViewPositionTop | QMUIBorderViewPositionBottom;
    [self.gitHubButton addTarget:self action:@selector(handleGitHubButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.gitHubButton];
    
    self.copyrightLabel = [[UILabel alloc] init];
    self.copyrightLabel.numberOfLines = 0;
    self.copyrightLabel.attributedText = [[NSAttributedString alloc] initWithString:@"© 2017 QMUI Team All Rights Reserved." attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColorGray5, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
    [self.scrollView addSubview:self.copyrightLabel];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"关于";
}

- (QMUIButton *)generateCellButtonWithTitle:(NSString *)title {
    QMUIButton *button = [[QMUIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TableViewCellTitleLabelColor forState:UIControlStateNormal];
    button.titleLabel.font = UIFontMake(15);
    button.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
    button.qmui_borderColor = TableViewSeparatorColor;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    button.qmui_needsTakeOverTouchEvent = YES;
    return button;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat tabBarHeight = 0;
    UIEdgeInsets padding = UIEdgeInsetsMake(24, 24, 24, 24);
    CGFloat versionLabelMarginTop = 10;
    CGFloat buttonHeight = TableViewCellNormalHeight;
    
    self.scrollView.frame = CGRectSetHeight(self.view.bounds, CGRectGetHeight(self.view.bounds) - tabBarHeight);
    
    if (IS_IPHONE && IS_LANDSCAPE) {
        CGFloat leftWidth = flatf(CGRectGetWidth(self.scrollView.bounds) / 2);
        CGFloat rightWidth = CGRectGetWidth(self.scrollView.bounds) - leftWidth;
        
        CGFloat leftHeight = CGRectGetHeight(self.logoImageView.frame) + versionLabelMarginTop + CGRectGetHeight(self.versionLabel.frame);
        CGFloat leftMinY = CGFloatGetCenter(CGRectGetHeight(self.scrollView.bounds) - CGRectGetMaxY(self.navigationController.navigationBar.frame), leftHeight);
        self.logoImageView.frame = CGRectSetXY(self.logoImageView.frame, CGFloatGetCenter(leftWidth, CGRectGetHeight(self.logoImageView.frame)), leftMinY);
        self.versionLabel.frame = CGRectSetXY(self.versionLabel.frame, CGRectGetMinXHorizontallyCenter(self.logoImageView.frame, self.versionLabel.frame), CGRectGetMaxY(self.logoImageView.frame) + versionLabelMarginTop);
        
        CGFloat contentWidthInRight = rightWidth - UIEdgeInsetsGetHorizontalValue(padding);
        self.websiteButton.frame = CGRectMake(leftWidth + padding.left, CGRectGetMinY(self.logoImageView.frame) + 10, contentWidthInRight, buttonHeight);
        self.gitHubButton.frame = CGRectSetY(self.websiteButton.frame, CGRectGetMaxY(self.websiteButton.frame));
        
        CGFloat copyrightLabelHeight = [self.copyrightLabel sizeThatFits:CGSizeMake(contentWidthInRight, CGFLOAT_MAX)].height;
        self.copyrightLabel.frame = CGRectFlatMake(leftWidth + padding.left, CGRectGetHeight(self.scrollView.bounds) - CGRectGetMaxY(self.navigationController.navigationBar.frame) - padding.bottom - copyrightLabelHeight, contentWidthInRight, copyrightLabelHeight);
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    } else {
        
        CGFloat containerHeight = CGRectGetHeight(self.scrollView.bounds) - UIEdgeInsetsGetVerticalValue(padding);
        CGFloat buttonMarginTop = 36;
        CGFloat mainContentHeight = CGRectGetHeight(self.logoImageView.frame) + versionLabelMarginTop + CGRectGetHeight(self.versionLabel.frame) + buttonMarginTop + buttonHeight * 2;
        CGFloat mainContentMinY = padding.top + (containerHeight - mainContentHeight) / 6;
        
        self.logoImageView.frame = CGRectSetXY(self.logoImageView.frame, CGRectGetMinXHorizontallyCenterInParentRect(self.scrollView.bounds, self.logoImageView.frame), mainContentMinY);
        
        self.versionLabel.frame = CGRectSetXY(self.versionLabel.frame, CGRectGetMinXHorizontallyCenterInParentRect(self.scrollView.bounds, self.versionLabel.frame), CGRectGetMaxY(self.logoImageView.frame) + versionLabelMarginTop);
        
        self.websiteButton.frame = CGRectMake(0, CGRectGetMaxY(self.versionLabel.frame) + buttonMarginTop, CGRectGetWidth(self.scrollView.bounds), buttonHeight);
        self.gitHubButton.frame = CGRectSetY(self.websiteButton.frame, CGRectGetMaxY(self.websiteButton.frame));
        
        CGFloat copyrightLabelWidth = CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
        CGFloat copyrightLabelHeight = [self.copyrightLabel sizeThatFits:CGSizeMake(copyrightLabelWidth, CGFLOAT_MAX)].height;
        self.copyrightLabel.frame = CGRectFlatMake(padding.left, CGRectGetHeight(self.scrollView.bounds) - CGRectGetMaxY(self.navigationController.navigationBar.frame) - padding.bottom - copyrightLabelHeight, copyrightLabelWidth, copyrightLabelHeight);
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.copyrightLabel.frame) + padding.bottom);
    }
}

- (void)handleWebsiteButtonEvent:(QMUIButton *)button {
    [self openUrlString:@"http://www.qmuiteam.com/ios"];
}

- (void)handleGitHubButtonEvent:(QMUIButton *)button {
    [self openUrlString:@"https://github.com/QMUI/QMUI_iOS"];
}

- (void)openUrlString:(NSString *)urlString {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:urlString];
#ifdef IOS10_SDK_ALLOWED
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:@{} completionHandler:nil];
    } else {
        [application openURL:url];
    }
#else
    [application openURL:url];
#endif
}

@end
