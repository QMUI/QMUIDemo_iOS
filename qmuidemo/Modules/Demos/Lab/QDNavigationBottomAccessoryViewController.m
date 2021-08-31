//
//  QDNavigationBottomAccessoryViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/7/28.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDNavigationBottomAccessoryViewController.h"
#import "UINavigationItem+QMUIBottomAccessoryView.h"

@interface QDBottomAccessoryView : UIView

@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) QMUIButton *linkButton;
@end

@implementation QDNavigationBottomAccessoryViewController

- (void)setupNavigationItems {
    [super setupNavigationItems];
    QDBottomAccessoryView *accessoryView = [[QDBottomAccessoryView alloc] qmui_initWithSize:CGSizeMake(0, 24)];
    self.navigationItem.qmui_bottomAccessoryView = accessoryView;
}

- (UIImage *)qmui_navigationBarBackgroundImage {
    return nil;
}

- (UIColor *)qmui_navigationBarTintColor {
    return UIColor.qd_titleTextColor;
}

- (UIColor *)qmui_titleViewTintColor {
    return self.qmui_navigationBarTintColor;
}

- (NSString *)customNavigationBarTransitionKey {
    return @"bottom";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [QDThemeManager.currentTheme.themeName isEqualToString:QDThemeIdentifierDark] ? UIStatusBarStyleLightContent : QMUIStatusBarStyleDarkContent;
}

@end

@implementation QDBottomAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 4, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        self.textLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(12) textColor:UIColor.qd_titleTextColor];
        self.textLabel.text = @"具体说明请";
        [self.textLabel sizeToFit];
        [self addSubview:self.textLabel];
        
        self.linkButton = [[QMUIButton alloc] init];
        self.linkButton.titleLabel.font = UIFontMake(12);
        [self.linkButton setTitle:@"查看详情" forState:UIControlStateNormal];
        self.linkButton.qmui_borderPosition = QMUIViewBorderPositionBottom;
        self.linkButton.qmui_borderWidth = 1;
        self.linkButton.qmui_borderColor = self.linkButton.tintColor;
        self.linkButton.qmui_outsideEdge = UIEdgeInsetsMake(-12, -12, -12, -12);
        [self.linkButton sizeToFit];
        [self addSubview:self.linkButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentWidth = CGRectGetWidth(self.textLabel.frame) + CGRectGetWidth(self.linkButton.frame);
    CGFloat minX = CGFloatGetCenter(CGRectGetWidth(self.bounds), contentWidth);
    
    self.textLabel.frame = CGRectSetXY(self.textLabel.frame, minX, CGRectGetMinYVerticallyCenterInParentRect(self.bounds, self.textLabel.frame));
    minX = CGRectGetMaxX(self.textLabel.frame);
    
    self.linkButton.frame = CGRectSetXY(self.linkButton.frame, minX, CGRectGetMinYVerticallyCenterInParentRect(self.bounds, self.linkButton.frame));
}

@end
