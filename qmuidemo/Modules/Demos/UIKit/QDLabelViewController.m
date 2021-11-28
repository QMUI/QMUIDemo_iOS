//
//  QDLabelViewController.m
//  qmui
//
//  Created by QMUI Team on 14-7-13.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDLabelViewController.h"

@interface QDLabelTruncatingTailView : UIControl

@property(nonatomic, strong) UIColor *gradientColor;
@property(nonatomic, assign) CGFloat gradientWidth;

@property(nonatomic, strong) CAGradientLayer *gradientMaskLayer;
@property(nonatomic, strong) UILabel *label;
@end

@interface QDLabelViewController ()

@property(nonatomic, strong) QMUILabel *label1;
@property(nonatomic, strong) QMUILabel *label2;
@property(nonatomic, strong) QMUILabel *label3;

@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) CALayer *separatorLayer2;
@property(nonatomic, strong) CALayer *separatorLayer3;

@end

@implementation QDLabelViewController

#pragma mark - 生命周期函数

- (void)initSubviews {
    [super initSubviews];

    _label1 = [[QMUILabel alloc] init];
    self.label1.text = @"可长按复制";
    self.label1.font = UIFontMake(15);
    self.label1.textColor = UIColor.qd_descriptionTextColor;
    self.label1.canPerformCopyAction = YES;
    self.label1.didCopyBlock = ^(QMUILabel *label, NSString *stringCopied) {
        [QMUITips showSucceed:@"已复制"];
    };
    [self.label1 sizeToFit];
    [self.view addSubview:self.label1];
    
    _label2 = [[QMUILabel alloc] init];
    self.label2.text = @"可设置 contentInsets";
    self.label2.font = UIFontMake(15);
    self.label2.textColor = UIColorWhite;
    self.label2.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
        return [theme.themeTintColor colorWithAlphaComponent:.5];
    }];
    self.label2.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);
    [self.label2 sizeToFit];
    [self.view addSubview:self.label2];
    
    _label3 = [[QMUILabel alloc] init];
    self.label3.text = @"可支持文字缩略时显示自定义的 View（通常用于展开更多）。例如这个文字特别长，然后最多只显示3行，点击“更多”可以展开完整的文字。例如这个文字特别长，然后最多只显示3行，点击“更多”可以展开完整的文字。例如这个文字特别长，然后最多只显示3行，点击“更多”可以展开完整的文字。例如这个文字特别长，然后最多只显示3行，点击“更多”可以展开完整的文字。例如这个文字特别长，然后最多只显示3行，点击“更多”可以展开完整的文字。";
    self.label3.numberOfLines = 3;
    self.label3.font = UIFontMake(15);
    self.label3.qmui_lineHeight = 21;
    self.label3.textColor = UIColor.qd_descriptionTextColor;
    self.label3.userInteractionEnabled = YES;// UILabel 系统默认是不支持点击的，如果你的 truncatingTailView 支持点击，则需要手动开启 userInteractionEnabled
    self.label3.truncatingTailView = ({
        QDLabelTruncatingTailView *view = QDLabelTruncatingTailView.new;
        view.gradientColor = self.view.backgroundColor;
        view.gradientWidth = 48;
        view.label.text = @"更多";
        [view addTarget:self action:@selector(handleTruncatingTailViewEvent:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [self.view addSubview:self.label3];
    
    self.separatorLayer1 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer1];
    
    self.separatorLayer2 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer2];
    
    self.separatorLayer3 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer3];

}

- (void)handleTruncatingTailViewEvent:(QDLabelTruncatingTailView *)view {
    self.label3.numberOfLines = 0;
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat contentMinY = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat buttonSpacingHeight = QDButtonSpacingHeight;
    
    self.label1.frame = CGRectSetXY(self.label1.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.label1.bounds)), contentMinY + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.label1.bounds)));
    
    self.separatorLayer1.frame = CGRectMake(0, contentMinY + buttonSpacingHeight * 1, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.label2.frame = CGRectSetXY(self.label2.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.label2.bounds)), CGRectGetMaxY(self.separatorLayer1.frame) + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.label2.bounds)));
    
    self.separatorLayer2.frame = CGRectMake(0, contentMinY + buttonSpacingHeight * 2, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.label3.frame = CGRectMake(32, CGRectGetMaxY(self.separatorLayer2.frame) + 32, CGRectGetWidth(self.view.bounds) - 32 * 2, QMUIViewSelfSizingHeight);
    
    self.separatorLayer3.frame = CGRectMake(0, CGRectGetMaxY(self.label3.frame) + 32, CGRectGetWidth(self.view.bounds), PixelOne);
}

@end

@implementation QDLabelTruncatingTailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.gradientMaskLayer = CAGradientLayer.layer;
        [self.gradientMaskLayer qmui_removeDefaultAnimations];
        self.gradientMaskLayer.startPoint = CGPointMake(0, .5);
        self.gradientMaskLayer.endPoint = CGPointMake(1, .5);
        [self.layer addSublayer:self.gradientMaskLayer];
        
        self.label = UILabel.new;
        [self addSubview:self.label];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if ([self.superview isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)self.superview;
        [self.label qmui_setTheSameAppearanceAsLabel:label];
        self.label.backgroundColor = self.gradientColor;
        [self setNeedsLayout];
    }
}

- (void)setGradientColor:(UIColor *)gradientColor {
    _gradientColor = gradientColor;
    self.gradientMaskLayer.colors = @[(id)[gradientColor colorWithAlphaComponent:0].CGColor, (id)gradientColor.CGColor];
    self.label.backgroundColor = gradientColor;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize labelSize = [self.label sizeThatFits:CGSizeMax];
    return CGSizeMake(self.gradientWidth + labelSize.width, labelSize.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientMaskLayer.frame = CGRectMake(0, 0, self.gradientWidth, CGRectGetHeight(self.bounds));
    self.label.frame = CGRectMake(CGRectGetMaxX(self.gradientMaskLayer.frame), 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.gradientMaskLayer.frame), CGRectGetHeight(self.bounds));
}

@end
