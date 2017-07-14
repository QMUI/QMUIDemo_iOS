//
//  QDButtonEdgeInsetsViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/7/12.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDButtonEdgeInsetsViewController.h"

const NSInteger TagForStaticSizeView = 111;

@interface QDButtonEdgeInsetsViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;
@end

@implementation QDButtonEdgeInsetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    ({
        [self generateLabelWithTitle:@"default"];
        [self generateSystemButton];
        [self generateQMUIButton];
    });
    
    ({
        [self generateLabelWithTitle:@"contentEdgeInsets(0, 8, 0, 8)"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.contentEdgeInsets = systemButton.contentEdgeInsets;
    });
    
    ({
        [self generateLabelWithTitle:@"imageEdgeInsets(0, 0, 0, 8)"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.imageEdgeInsets = systemButton.imageEdgeInsets;
    });
    
    ({
        [self generateLabelWithTitle:@"imageEdgeInsets(0, 8, 0, 0)"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.imageEdgeInsets = systemButton.imageEdgeInsets;
    });
    
    ({
        [self generateLabelWithTitle:@"titleEdgeInsets(0, 8, 0, 0)"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.titleEdgeInsets = systemButton.titleEdgeInsets;
    });
    
    ({
        [self generateLabelWithTitle:@"titleEdgeInsets(0, 0, 0, 8)"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.titleEdgeInsets = systemButton.titleEdgeInsets;
    });
    
    ({
        [self generateLabelWithTitle:@"UIControlContentHorizontalAlignmentFill"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.tag = systemButton.tag;
        qmuiButton.contentHorizontalAlignment = systemButton.contentHorizontalAlignment;
    });
    
    // 只显示 image
    ({
        [self generateLabelWithTitle:@"Fill Only Image"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [systemButton setTitle:nil forState:UIControlStateNormal];
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.tag = systemButton.tag;
        qmuiButton.contentHorizontalAlignment = systemButton.contentHorizontalAlignment;
        [qmuiButton setTitle:nil forState:UIControlStateNormal];
    });
    
    // 只显示 title
    ({
        [self generateLabelWithTitle:@"Fill Only Title"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [systemButton setImage:nil forState:UIControlStateNormal];
        [systemButton setTitle:@"UIControlContentHorizontalAlignmentFill" forState:UIControlStateNormal];
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.tag = systemButton.tag;
        qmuiButton.contentHorizontalAlignment = systemButton.contentHorizontalAlignment;
        [qmuiButton setImage:nil forState:UIControlStateNormal];
        [qmuiButton setTitle:@"UIControlContentHorizontalAlignmentFill" forState:UIControlStateNormal];
    });
    
    ({
        [self generateLabelWithTitle:@"UIControlContentHorizontalAlignmentRight"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.tag = systemButton.tag;
        qmuiButton.contentHorizontalAlignment = systemButton.contentHorizontalAlignment;
    });
    
    ({
        [self generateLabelWithTitle:@"UIControlContentVerticalAlignmentFill"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.tag = systemButton.tag;
        qmuiButton.contentVerticalAlignment = systemButton.contentVerticalAlignment;
    });
    
    // 只显示 image
    ({
        [self generateLabelWithTitle:@"Fill Only Image"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [systemButton setTitle:nil forState:UIControlStateNormal];
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.tag = systemButton.tag;
        qmuiButton.contentVerticalAlignment = systemButton.contentVerticalAlignment;
        [qmuiButton setTitle:nil forState:UIControlStateNormal];
    });
    
    // 只显示 title
    ({
        [self generateLabelWithTitle:@"Fill Only Title"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [systemButton setTitle:@"UIControlContentVerticalAlignmentFill" forState:UIControlStateNormal];
        [systemButton setImage:nil forState:UIControlStateNormal];
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.tag = systemButton.tag;
        qmuiButton.contentVerticalAlignment = systemButton.contentVerticalAlignment;
        [qmuiButton setTitle:@"UIControlContentVerticalAlignmentFill" forState:UIControlStateNormal];
        [qmuiButton setImage:nil forState:UIControlStateNormal];
    });
    
    ({
        [self generateLabelWithTitle:@"UIControlContentVerticalAlignmentBottom"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        QMUIButton *qmuiButton = [self generateQMUIButton];
        qmuiButton.tag = systemButton.tag;
        qmuiButton.contentVerticalAlignment = systemButton.contentVerticalAlignment;
    });
}

- (UIButton *)generateSystemButton {
    return [self generateButtonWithClass:[UIButton class]];
}

- (QMUIButton *)generateQMUIButton {
    return [self generateButtonWithClass:[QMUIButton class]];
}

- (__kindof UIButton *)generateButtonWithClass:(Class)buttonClass {
    UIButton *button = [[buttonClass alloc] init];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    [button setImage:[UIImage qmui_imageWithColor:UIColorBlue size:CGSizeMake(20, 20) cornerRadius:0] forState:UIControlStateNormal];
    button.backgroundColor = UIColorTestRed;
    button.imageView.layer.borderWidth = PixelOne;
    button.imageView.layer.borderColor = UIColorTestBlue.CGColor;
    [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
    button.titleLabel.font = UIFontMake(18);
    button.titleLabel.layer.borderWidth = PixelOne;
    button.titleLabel.layer.borderColor = UIColorRed.CGColor;
    [self.scrollView addSubview:button];
    return button;
}

- (UILabel *)generateLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorGray3];
    label.text = title;
    [self.scrollView addSubview:label];
    return label;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    
    CGFloat paddingLeft = 24;
    CGFloat minY = 0;
    for (NSInteger i = 0; i < self.scrollView.subviews.count; i++) {
        UIView *subview = self.scrollView.subviews[i];
        if (subview.tag == TagForStaticSizeView) {
            subview.frame = CGRectSetSize(subview.frame, CGSizeMake(100, 40));
        } else {
            [subview sizeToFit];
        }
        if (i % 3 == 0) {
            subview.frame = CGRectSetXY(subview.frame, paddingLeft, minY + 24);
            minY = CGRectGetMaxY(subview.frame);
        } else if (i % 3 == 1) {
            subview.frame = CGRectSetXY(subview.frame, paddingLeft, minY + 10);
        } else if (i % 3 == 2) {
            UIView *leftView = self.scrollView.subviews[i - 1];
            subview.frame = CGRectSetXY(subview.frame, CGRectGetMaxX(leftView.frame) + 24, CGRectGetMinY(leftView.frame));
            minY = CGRectGetMaxY(subview.frame);
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), minY);
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"Button EdgeInsets Testing";
    if (self.qmui_isPresented) {
        self.navigationItem.leftBarButtonItem = [QMUINavigationButton closeBarButtonItemWithTarget:self action:@selector(handleCloseItemEvent)];
    }
}

- (void)handleCloseItemEvent {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - <QMUINavigationControllerDelegate>

- (UIImage *)navigationBarBackgroundImage {
    // debug warning
    return [UIImage qmui_imageWithColor:UIColorMake(232, 46, 46)];
}

@end
