//
//  QDModalPresentationViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/7/20.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDModalPresentationViewController.h"
#import "UIImageEffects.h"

static NSString * const kSectionTitleForUsing = @"使用方式";
static NSString * const kSectionTitleForStyling = @"内容及动画";

@interface QDModalContentViewController : UIViewController<QMUIModalPresentationContentViewControllerProtocol>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;
@end

@interface QDModalPresentationViewController ()

@property(nonatomic, assign) QMUIModalPresentationAnimationStyle currentAnimationStyle;
@property(nonatomic, strong) QMUIModalPresentationViewController *modalViewControllerForAddSubview;
@end

@implementation QDModalPresentationViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                        kSectionTitleForUsing, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                @"showWithAnimated",      @"以 UIWindow 的形式盖在当前界面上",
                                                @"presentViewController", @"以 presentViewController: 的方式显示",
                                                @"showInView",            @"以 addSubview: 的方式直接将浮层添加到要显示的 UIView 上",
                                                nil],
                        kSectionTitleForStyling, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                  @"contentView",           @"直接显示一个UIView浮层",
                                                  @"contentViewController", @"显示一个UIViewController",
                                                  @"animationStyle",        @"默认提供3种动画，可重复点击，依次展示",
                                                  @"dimmingView",           @"自带背景遮罩，也可自行制定一个遮罩的UIView",
                                                  @"layoutBlock",           @"利用layoutBlock、showingAnimation、hidingAnimation制作自定义的显示动画",
                                                  @"keyboard",              @"控件自带对keyboard的管理，并且能保证浮层和键盘同时升起，不会有跳动",
                                                  nil],
                       nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"contentView"]) {
        [self handleShowContentView];
    } else if ([title isEqualToString:@"contentViewController"]) {
        [self handleShowContentViewController];
    } else if ([title isEqualToString:@"animationStyle"]) {
        [self handleAnimationStyle];
    } else if ([title isEqualToString:@"dimmingView"]) {
        [self handleCustomDimmingView];
    } else if ([title isEqualToString:@"layoutBlock"]) {
        [self handleLayoutBlockAndAnimation];
    } else if ([title isEqualToString:@"keyboard"]) {
        [self handleKeyboard];
    } else if ([title isEqualToString:@"showWithAnimated"]) {
        [self handleWindowShowing];
    } else if ([title isEqualToString:@"presentViewController"]) {
        [self handlePresentShowing];
    } else if ([title isEqualToString:@"showInView"]) {
        [self handleShowInView];
    }
}

#pragma mark - Handles

- (void)handleShowContentView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"默认的布局是上下左右居中，可通过contentViewMargins、maximumContentViewWidth属性来调整宽高、上下左右的偏移。\n你现在可以试试旋转一下设备试试看。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleShowContentViewController {
    QDModalContentViewController *contentViewController = [[QDModalContentViewController alloc] init];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentViewController = contentViewController;
    modalViewController.maximumContentViewWidth = CGFLOAT_MAX;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleAnimationStyle {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"modalViewController提供的显示/隐藏动画总共有3种，可通过animationStyle属性来设置，默认为QMUIModalPresentationAnimationStyleFade。\n多次打开此浮层会在这3种动画之间互相切换。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = self.currentAnimationStyle % 3;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
    
    self.currentAnimationStyle++;
}

- (void)handleCustomDimmingView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    contentView.layer.shadowColor = UIColorBlack.CGColor;
    contentView.layer.shadowOpacity = .08;
    contentView.layer.shadowRadius = 15;
    contentView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds cornerRadius:contentView.layer.cornerRadius].CGPath;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"QMUIModalPresentationViewController允许自定义背景遮罩的dimmingView，例如这里的背景遮罩是拿当前界面进行截图磨砂后显示出来的。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
    
    UIImage *blurredBackgroundImage = [UIImage qmui_imageWithView:self.navigationController.view];
    blurredBackgroundImage = [UIImageEffects imageByApplyingExtraLightEffectToImage:blurredBackgroundImage];
    UIImageView *blurredDimmingView = [[UIImageView alloc] initWithImage:blurredBackgroundImage];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.dimmingView = blurredDimmingView;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleLayoutBlockAndAnimation {
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    contentView.alwaysBounceVertical = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"利用layoutBlock可以自定义浮层的布局，注意此时contentViewMargins、maximumContentViewWidth属性均无效，如果需要实现外间距、最大宽高的保护，请自行计算。\n另外搭配showingAnimation、hidingAnimation也可制作自己的显示/隐藏动画，例如这个例子里实现了一个从底部升起的面板，升起后停靠在容器底端，你可以试着旋转设备，会发现依然能正确布局。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
    
    contentView.contentSize = CGSizeMake(CGRectGetWidth(contentView.bounds), CGRectGetMaxY(label.frame) + contentViewPadding.bottom);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectSetXY(contentView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(contentView.frame)), CGRectGetHeight(containerBounds) - 20 - CGRectGetHeight(contentView.frame));
    };
    modalViewController.showingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void(^completion)(BOOL finished)) {
        contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            contentView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    modalViewController.hidingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void(^completion)(BOOL finished)) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
            contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleKeyboard {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    
    QMUITextField *textField = [[QMUITextField alloc] initWithFrame:CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, 36)];
    textField.placeholder = @"请输入文字";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = UIFontMake(16);
    [contentView addSubview:textField];
    [textField becomeFirstResponder];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20];
    paragraphStyle.paragraphSpacing = 10;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"如果你的浮层里有输入框，建议在把输入框添加到界面上后立即调用becomeFirstResponder（如果你用contentViewController，则在viewWillAppear:时调用becomeFirstResponder），以保证键盘跟随浮层一起显示。\n而在浮层消失时，modalViewController会自动降下键盘，所以你的浮层里并不需要处理。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColorGrayDarken, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSDictionary *codeAttributes = @{NSFontAttributeName: CodeFontMake(12), NSForegroundColorAttributeName: [[QDThemeManager sharedInstance].currentTheme.themeCodeColor colorWithAlphaComponent:.8]};
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, CGRectGetMaxY(textField.frame) + 8, contentLimitWidth, labelSize.height);
    
    contentView.frame = CGRectSetHeight(contentView.frame, CGRectGetMaxY(label.frame) + contentViewPadding.bottom);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleWindowShowing {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"QMUIModalPresentationViewController支持 3 种使用方式，当前使用第 1 种，注意状态栏被遮罩盖住了" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 UIWindow 的形式来展示
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handlePresentShowing {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"QMUIModalPresentationViewController支持 3 种使用方式，当前使用第 2 种，注意遮罩无法盖住屏幕顶部的状态栏。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 presentViewController 的形式展示时，animated 要传 NO，否则系统的动画会覆盖 QMUIModalPresentationAnimationStyle 的动画
    [self presentViewController:modalViewController animated:NO completion:NULL];
}

- (void)handleShowInView {
    if (self.modalViewControllerForAddSubview) {
        [self.modalViewControllerForAddSubview hideInView:self.view animated:YES completion:nil];
    }
    
    CGRect modalRect = CGRectMake(40, self.qmui_navigationBarMaxYInViewCoordinator + 40, CGRectGetWidth(self.view.bounds) - 40 * 2, CGRectGetHeight(self.view.bounds) - self.qmui_navigationBarMaxYInViewCoordinator - 40 * 2);
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(modalRect) - 40, 200)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    self.modalViewControllerForAddSubview = [[QMUIModalPresentationViewController alloc] init];
    self.modalViewControllerForAddSubview.contentView = contentView;
    self.modalViewControllerForAddSubview.view.frame = modalRect;
    // 以 addSubview 的形式显示，此时需要retain住modalPresentationViewController，防止提前被释放
    [self.modalViewControllerForAddSubview showInView:self.view animated:YES completion:nil];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"QMUIModalPresentationViewController支持 3 种使用方式，当前使用第 3 种，注意可以透过遮罩外的空白地方点击到背后的 cell" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
}

@end

@implementation QDModalContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    self.view.layer.cornerRadius = 6;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderWidth = PixelOne;
    self.imageView.layer.borderColor = UIColorSeparator.CGColor;
    self.imageView.image = UIImageMake(@"image0");
    [self.scrollView addSubview:self.imageView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"如果你的浮层是以UIViewController的形式存在的，那么就可以通过modalViewController.contentViewController属性来显示出来。\n利用UIViewController的特点，你可以方便地管理复杂的UI状态，并且响应设备在不同状态下的布局。\n例如这个例子里，图片和文字的排版会随着设备的方向变化而变化，你可以试着旋转屏幕看看效果。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        if (![codeString isEqualToString:@"UI"]) {
            [attributedString addAttributes:codeAttributes range:codeRange];
        }
    }];
    self.textLabel.attributedText = attributedString;
    [self.scrollView addSubview:self.textLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.view.bounds) - UIEdgeInsetsGetVerticalValue(padding));
    self.scrollView.frame = self.view.bounds;
    
    if (IS_LANDSCAPE) {
        // 横屏下图文水平布局
        CGFloat imageViewLimitWidth = contentSize.width / 3;
        self.imageView.frame = CGRectSetXY(self.imageView.frame, padding.left, padding.top);
        [self.imageView qmui_sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(imageViewLimitWidth, CGFLOAT_MAX)];
        
        CGFloat textLabelMarginLeft = 20;
        CGFloat textLabelLimitWidth = contentSize.width - CGRectGetWidth(self.imageView.frame) - textLabelMarginLeft;
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(textLabelLimitWidth, CGFLOAT_MAX)];
        self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + textLabelMarginLeft, padding.top - 6, textLabelLimitWidth, textLabelSize.height);
    } else {
        // 竖屏下图文垂直布局
        CGFloat imageViewLimitHeight = 120;
        self.imageView.frame = CGRectMake(padding.left, padding.top, contentSize.width, imageViewLimitHeight);
        
        CGFloat textLabelMarginTop = 20;
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(contentSize.width, CGFLOAT_MAX)];
        self.textLabel.frame = CGRectMake(padding.left, CGRectGetMaxY(self.imageView.frame) + textLabelMarginTop, contentSize.width, textLabelSize.height);
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.textLabel.frame) + padding.bottom);
}

#pragma mark - <QMUIModalPresentationContentViewControllerProtocol>

- (CGSize)preferredContentSizeInModalPresentationViewController:(QMUIModalPresentationViewController *)controller limitSize:(CGSize)limitSize {
    // 高度无穷大表示不显示高度，则默认情况下会保证你的浮层高度不超过QMUIModalPresentationViewController的高度减去contentViewMargins
    return CGSizeMake(CGRectGetWidth(controller.view.bounds) - UIEdgeInsetsGetHorizontalValue(controller.contentViewMargins), CGFLOAT_MAX);
}

@end
