//
//  QDButtonEdgeInsetsViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/7/12.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDButtonEdgeInsetsViewController.h"

const NSInteger TagForStaticSizeView = 111;
const CGSize SizeForStaticSizeView = {140, 60};

@interface QDButtonConfigurePopupView : QMUIPopupContainerView

@property(nonatomic, weak) UIButton *bindButton;
@end

@interface QDButtonEdgeInsetsViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) QDButtonConfigurePopupView *configurePopupView;
@end

@implementation QDButtonEdgeInsetsViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    ({
        [self generateLabelWithTitle:@"sizeToFit，无 insets"];
        [self generateSystemButton];
        [self generateQMUIButton];
    });
    
    ({
        [self generateLabelWithTitle:@"sizeToFit\ncontentEdgeInsets(0, 8, 0, 8)\nimageEdgeInsets(0, 8, 0, 8)\ntitleEdgeInsets(0, 8, 0, 8)"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        systemButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        systemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        QMUIButton *qmuiButton = [self generateQMUIButton];
        [self copyButtonPropertyFromButton:systemButton toButton:qmuiButton];
    });
    
    ({
        [self generateLabelWithTitle:@"固定宽高\ncontentEdgeInsets(0, 8, 0, 8)\nimageEdgeInsets(0, 8, 0, 8)\ntitleEdgeInsets(0, 8, 0, 8)"];
        UIButton *systemButton = [self generateSystemButton];
        systemButton.tag = TagForStaticSizeView;
        systemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        systemButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        systemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        QMUIButton *qmuiButton = [self generateQMUIButton];
        [self copyButtonPropertyFromButton:systemButton toButton:qmuiButton];
    });
    
    self.configurePopupView = [[QDButtonConfigurePopupView alloc] init];
    self.configurePopupView.automaticallyHidesWhenUserTap = YES;
}

- (UIButton *)generateSystemButton {
    return [self generateButtonWithClass:[UIButton class]];
}

- (QMUIButton *)generateQMUIButton {
    return [self generateButtonWithClass:[QMUIButton class]];
}

- (__kindof UIButton *)generateButtonWithClass:(Class)buttonClass {
    UIButton *button = [[buttonClass alloc] init];
    [button setTitle:@"短标题" forState:UIControlStateNormal];
    [button setImage:[UIImage qmui_imageWithColor:UIColorBlue size:CGSizeMake(20, 20) cornerRadius:0] forState:UIControlStateNormal];
    button.backgroundColor = UIColorTestRed;
    button.imageView.layer.borderWidth = PixelOne;
    button.imageView.layer.borderColor = UIColorTestBlue.CGColor;
    [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
    button.titleLabel.font = UIFontMake(18);
    button.titleLabel.layer.borderWidth = PixelOne;
    button.titleLabel.layer.borderColor = UIColorRed.CGColor;
    [button addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    return button;
}

- (void)copyButtonPropertyFromButton:(UIButton *)fromButton toButton:(UIButton *)toButton {
    toButton.tag = fromButton.tag;
    toButton.contentEdgeInsets = fromButton.contentEdgeInsets;
    toButton.imageEdgeInsets = fromButton.imageEdgeInsets;
    toButton.titleEdgeInsets = fromButton.titleEdgeInsets;
}

- (UILabel *)generateLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorGray3];
    label.numberOfLines = 0;
    label.qmui_lineHeight = 20;
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
            subview.frame = CGRectSetSize(subview.frame, SizeForStaticSizeView);
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

- (void)handleButtonEvent:(UIButton *)button {
    self.configurePopupView.bindButton = button;
    [self.configurePopupView layoutWithTargetView:button];
    [self.configurePopupView showWithAnimated:YES];
}

#pragma mark - <QMUINavigationControllerDelegate>

- (UIImage *)navigationBarBackgroundImage {
    // debug warning
    return [UIImage qmui_imageWithColor:UIColorMake(232, 46, 46)];
}

@end

@implementation QDButtonConfigurePopupView {
    UILabel *_shouldShowImageLabel;
    UISwitch *_shouldShowImageSwitch;
    CALayer *_shouldShowImageSeparatorLayer;
    
    UILabel *_shouldShowTitleLabel;
    UISwitch *_shouldShowTitleSwitch;
    CALayer *_shouldShowTitleSeparatorLayer;
    
    UILabel *_bigImageLabel;
    UISwitch *_bigImageSwitch;
    CALayer *_bigImageSeparatorLayer;
    
    UILabel *_longTitleLabel;
    UISwitch *_longTitleSwitch;
    CALayer *_longTitleSeparatorLayer;
    
    UILabel *_imagePositionLabel;
    UISegmentedControl *_imagePositionSegmented;
    CALayer *_imagePositionSeparatorLayer;
    
    UILabel *_horizontalAlignmentLabel;
    UISegmentedControl *_horizontalAlignmentSegmented;
    CALayer *_horizontalAlignmentSeparatorLayer;
    
    UILabel *_verticalAlignmentLabel;
    UISegmentedControl *_verticalAlignmentSegmented;
    CALayer *_verticalAlignmentSeparatorLayer;
}

- (void)didInitialized {
    [super didInitialized];
    
    self.contentEdgeInsets = UIEdgeInsetsSetTop(self.contentEdgeInsets, 0);
    
    // 是否要显示图片
    _shouldShowImageLabel = [self generateLabelWithText:@"setImage"];
    _shouldShowImageSwitch = [self generateSwitch];
    _shouldShowImageSeparatorLayer = [CALayer qmui_separatorLayer];
    [self.contentView.layer addSublayer:_shouldShowImageSeparatorLayer];
    
    // 是否要显示标题
    _shouldShowTitleLabel = [self generateLabelWithText:@"setTitle"];
    _shouldShowTitleSwitch = [self generateSwitch];
    _shouldShowTitleSeparatorLayer = [CALayer qmui_separatorLayer];
    [self.contentView.layer addSublayer:_shouldShowTitleSeparatorLayer];
    
    // 是否要显示超大图片
    _bigImageLabel = [self generateLabelWithText:@"bigImage"];
    _bigImageSwitch = [self generateSwitch];
    _bigImageSeparatorLayer = [CALayer qmui_separatorLayer];
    [self.contentView.layer addSublayer:_bigImageSeparatorLayer];
    
    // 是否要显示超长标题
    _longTitleLabel = [self generateLabelWithText:@"longTitle"];
    _longTitleSwitch = [self generateSwitch];
    _longTitleSeparatorLayer = [CALayer qmui_separatorLayer];
    [self.contentView.layer addSublayer:_longTitleSeparatorLayer];
    
    // 改变图片的位置（仅对 QMUIButton 生效）
    _imagePositionLabel = [self generateLabelWithText:@"imagePosition"];
    _imagePositionSegmented = [self generateSegmentedWithItems:@[@"Top", @"Left", @"Bottom", @"Right"]];
    _imagePositionSeparatorLayer = [CALayer qmui_separatorLayer];
    [self.contentView.layer addSublayer:_imagePositionSeparatorLayer];
    
    // 内容的水平对齐方式
    _horizontalAlignmentLabel = [self generateLabelWithText:@"horizontal"];
    _horizontalAlignmentSegmented = [self generateSegmentedWithItems:@[@"Center", @"Left", @"Right", @"Fill"]];
    _horizontalAlignmentSeparatorLayer = [CALayer qmui_separatorLayer];
    [self.contentView.layer addSublayer:_horizontalAlignmentSeparatorLayer];
    
    // 内容的垂直对齐方式
    _verticalAlignmentLabel = [self generateLabelWithText:@"vertical"];
    _verticalAlignmentSegmented = [self generateSegmentedWithItems:@[@"Center", @"Top", @"Bottom", @"Fill"]];
    _verticalAlignmentSeparatorLayer = [CALayer qmui_separatorLayer];
    [self.contentView.layer addSublayer:_verticalAlignmentSeparatorLayer];
}

- (CGSize)sizeThatFitsInContentView:(CGSize)size {
    return CGSizeMake(size.width, 315);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat minY = 14;
    CGPoint switchCenter = CGPointMake(flat(CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(_shouldShowImageSwitch.frame) / 2), 0);
    
    _shouldShowImageLabel.frame = CGRectSetY(_shouldShowImageLabel.frame, minY);
    _shouldShowImageSwitch.center = CGPointMake(switchCenter.x, _shouldShowImageLabel.center.y);
    _shouldShowImageSeparatorLayer.frame = CGRectMake(0, CGRectGetMaxY(_shouldShowImageLabel.frame) + 14, CGRectGetWidth(self.contentView.bounds), PixelOne);
    minY = ceil(CGRectGetMaxY(_shouldShowImageSeparatorLayer.frame));
    
    _shouldShowTitleLabel.frame = CGRectSetY(_shouldShowTitleLabel.frame, minY + 14);
    _shouldShowTitleSwitch.center = CGPointMake(switchCenter.x, _shouldShowTitleLabel.center.y);
    _shouldShowTitleSeparatorLayer.frame = CGRectSetY(_shouldShowImageSeparatorLayer.frame, CGRectGetMaxY(_shouldShowTitleLabel.frame) + 14);
    minY = ceil(CGRectGetMaxY(_shouldShowTitleSeparatorLayer.frame));
    
    _bigImageLabel.frame = CGRectSetY(_bigImageLabel.frame, minY + 14);
    _bigImageSwitch.center = CGPointMake(switchCenter.x, _bigImageLabel.center.y);
    _bigImageSeparatorLayer.frame = CGRectSetY(_shouldShowImageSeparatorLayer.frame, CGRectGetMaxY(_bigImageLabel.frame) + 14);
    minY = ceil(CGRectGetMaxY(_bigImageSeparatorLayer.frame));
    
    _longTitleLabel.frame = CGRectSetY(_longTitleLabel.frame, minY + 14);
    _longTitleSwitch.center = CGPointMake(switchCenter.x, _longTitleLabel.center.y);
    _longTitleSeparatorLayer.frame = CGRectSetY(_shouldShowImageSeparatorLayer.frame, CGRectGetMaxY(_longTitleLabel.frame) + 14);
    minY = ceil(CGRectGetMaxY(_longTitleSeparatorLayer.frame));
    
    _imagePositionLabel.frame = CGRectSetY(_imagePositionLabel.frame, minY + 14);
    _imagePositionSegmented.center = CGPointMake(flat(CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(_imagePositionSegmented.frame) / 2), _imagePositionLabel.center.y);
    _imagePositionSeparatorLayer.frame = CGRectSetY(_shouldShowImageSeparatorLayer.frame, CGRectGetMaxY(_imagePositionLabel.frame) + 14);
    minY = ceil(CGRectGetMaxY(_imagePositionSeparatorLayer.frame));
    
    _horizontalAlignmentLabel.frame = CGRectSetY(_horizontalAlignmentLabel.frame, minY + 14);
    _horizontalAlignmentSegmented.center = CGPointMake(flat(CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(_horizontalAlignmentSegmented.frame) / 2), _horizontalAlignmentLabel.center.y);
    _horizontalAlignmentSeparatorLayer.frame = CGRectSetY(_shouldShowImageSeparatorLayer.frame, CGRectGetMaxY(_horizontalAlignmentLabel.frame) + 14);
    minY = ceil(CGRectGetMaxY(_horizontalAlignmentSeparatorLayer.frame));
    
    _verticalAlignmentLabel.frame = CGRectSetY(_verticalAlignmentLabel.frame, minY + 14);
    _verticalAlignmentSegmented.center = CGPointMake(flat(CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(_verticalAlignmentSegmented.frame) / 2), _verticalAlignmentLabel.center.y);
    _verticalAlignmentSeparatorLayer.frame = CGRectSetY(_shouldShowImageSeparatorLayer.frame, CGRectGetMaxY(_verticalAlignmentLabel.frame) + 14);
    minY = ceil(CGRectGetMaxY(_verticalAlignmentSeparatorLayer.frame));
}

- (UILabel *)generateLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorGray3];
    label.text = text;
    [label sizeToFit];
    [self.contentView addSubview:label];
    return label;
}

- (UISwitch *)generateSwitch {
    UISwitch *switchControl = [[UISwitch alloc] init];
    switchControl.tintColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    [switchControl sizeToFit];
    switchControl.transform = CGAffineTransformMakeScale(.7, .7);
    [switchControl addTarget:self action:@selector(handleSwitchControlEvent:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchControl];
    return switchControl;
}

- (UISegmentedControl *)generateSegmentedWithItems:(NSArray<NSString *> *)items {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentedControl.tintColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    segmentedControl.frame = CGRectSetWidth(segmentedControl.frame, 240);// 统一按照最长的来就行啦
    segmentedControl.transform = CGAffineTransformMakeScale(.8, .8);
    [segmentedControl addTarget:self action:@selector(handleSegmentedControlEvent:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:segmentedControl];
    return segmentedControl;
}

- (void)setBindButton:(UIButton *)bindButton {
    _bindButton = bindButton;
    _shouldShowImageSwitch.on = !!bindButton.currentImage;
    _shouldShowTitleSwitch.on = !!bindButton.currentTitle;
    _bigImageSwitch.on = bindButton.currentImage.size.width >= 80;
    _longTitleSwitch.on = bindButton.currentTitle.length >= 20;
    _imagePositionSegmented.enabled = [bindButton isKindOfClass:[QMUIButton class]];
    _imagePositionSegmented.selectedSegmentIndex = [bindButton isKindOfClass:[QMUIButton class]] ? ((QMUIButton *)bindButton).imagePosition : -1;
    _horizontalAlignmentSegmented.selectedSegmentIndex = bindButton.contentHorizontalAlignment;
    _verticalAlignmentSegmented.selectedSegmentIndex = bindButton.contentVerticalAlignment;
}

- (void)handleSwitchControlEvent:(UISwitch *)switchControl {
    if (switchControl == _shouldShowImageSwitch || switchControl == _bigImageSwitch) {
        [self updateImageForButton:self.bindButton shouldShowImage:_shouldShowImageSwitch.on shouldShowBigImage:_bigImageSwitch.on];
    }
    if (switchControl == _shouldShowTitleSwitch || switchControl == _longTitleSwitch) {
        [self updateTitleForButton:self.bindButton shouldShowTitle:_shouldShowTitleSwitch.on shouldShowLongTitle:_longTitleSwitch.on];
    }
    
    [self updateLayoutForButton:self.bindButton];
}

- (void)handleSegmentedControlEvent:(UISegmentedControl *)segmentedControl {
    if (segmentedControl == _imagePositionSegmented) {
        ((QMUIButton *)self.bindButton).imagePosition = segmentedControl.selectedSegmentIndex;
    } else if (segmentedControl == _horizontalAlignmentSegmented) {
        self.bindButton.contentHorizontalAlignment = segmentedControl.selectedSegmentIndex;
    } else if (segmentedControl == _verticalAlignmentSegmented) {
        self.bindButton.contentVerticalAlignment = segmentedControl.selectedSegmentIndex;
    }
    
    [self updateLayoutForButton:self.bindButton];
}

- (void)updateImageForButton:(UIButton *)button shouldShowImage:(BOOL)shouldShowImage shouldShowBigImage:(BOOL)shouldShowBigImage {
    if (!shouldShowImage) {
        [button setImage:nil forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage qmui_imageWithColor:UIColorBlue size:shouldShowBigImage ? CGSizeMake(80, 80) : CGSizeMake(20, 20) cornerRadius:0];
        [button setImage:image forState:UIControlStateNormal];
    }
}

- (void)updateTitleForButton:(UIButton *)button shouldShowTitle:(BOOL)shouldShowTitle shouldShowLongTitle:(BOOL)shouldShowLongTitle {
    if (!shouldShowTitle) {
        [button setTitle:nil forState:UIControlStateNormal];
    } else {
        NSString *title = shouldShowLongTitle ? @"很长很长的标题很长很长的标题很长很长的标题" : @"短标题";
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (void)updateLayoutForButton:(UIButton *)button {
    if (button.tag != TagForStaticSizeView) {
        [button sizeToFit];
    }
    [button setNeedsLayout];
}

@end
