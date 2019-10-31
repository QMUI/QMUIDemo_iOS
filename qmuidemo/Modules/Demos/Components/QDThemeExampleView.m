//
//  QDThemeExampleView.m
//  qmuidemo
//
//  Created by MoLice on 2019/J/27.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import "QDThemeExampleView.h"

@interface QDThemeExampleView ()

@property(nonatomic, assign) CGFloat itemInnerSpacing;
@property(nonatomic, assign) CGFloat itemMarginBottom;
@property(nonatomic, assign) CGFloat barHeight;// bar 高度会受到 safeAreaInsets 的影响，所以搞个固定的高度

@property(nonatomic, strong) UILabel *viewLabel;
@property(nonatomic, strong) UIView *view;

@property(nonatomic, strong) UILabel *textFieldLabel;
@property(nonatomic, strong) UITextField *textField;

@property(nonatomic, strong) UILabel *labelLabel;
@property(nonatomic, strong) UILabel *label;

@property(nonatomic, strong) UILabel *textViewLabel;
@property(nonatomic, strong) UITextView *textView;

@property(nonatomic, strong) UILabel *sliderLabel;
@property(nonatomic, strong) UISlider *slider;

@property(nonatomic, strong) UILabel *switchLabel;
@property(nonatomic, strong) UISwitch *switchControlOn;
@property(nonatomic, strong) UISwitch *switchControlOff;

@property(nonatomic, strong) UILabel *imageViewLabel;
@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIProgressView *progressView;

@property(nonatomic, strong) UILabel *visualEffectLabel;
@property(nonatomic, strong) UIVisualEffectView *visualEffectView;
@property(nonatomic, strong) UIImageView *visualEffectBackendImageView;

@property(nonatomic, strong) UILabel *navigationBarLabel;
@property(nonatomic, strong) UINavigationBar *navigationBar;

@property(nonatomic, strong) UILabel *tabBarLabel;
@property(nonatomic, strong) UITabBar *tabBar;

@property(nonatomic, strong) UILabel *toolbarLabel;
@property(nonatomic, strong) UIToolbar *toolbar;

@property(nonatomic, strong) UILabel *searchBarLabel;
@property(nonatomic, strong) UISearchBar *searchBar;

@end

@implementation QDThemeExampleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.itemInnerSpacing = 8;
        self.itemMarginBottom = 32;
        self.barHeight = 44;
        
        UIFont *font = UIFontMake(14);
        UIFont *codeFont = CodeFontMake(font.pointSize);
        UIColor *textColor = UIColor.qd_descriptionTextColor;
        
        self.viewLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.viewLabel.text = @"UIView";
        [self.viewLabel sizeToFit];
        [self addSubview:self.viewLabel];
        
        self.view = [[UIView alloc] qmui_initWithSize:CGSizeMake(100, 40)];
        self.view.qmui_borderWidth = 3;
        self.view.qmui_borderPosition = QMUIViewBorderPositionTop|QMUIViewBorderPositionLeft|QMUIViewBorderPositionBottom|QMUIViewBorderPositionRight;
        self.view.qmui_borderColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [theme.themeTintColor colorWithAlphaComponent:.5];
        }];
        self.view.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [theme.themeTintColor colorWithAlphaComponent:.5];
        }];
        [self addSubview:self.view];
        
        self.textFieldLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.textFieldLabel.text = @"UITextField";
        [self.textFieldLabel sizeToFit];
        [self addSubview:self.textFieldLabel];
        
        self.textField = [[UITextField alloc] qmui_initWithSize:self.view.frame.size];
        self.textField.backgroundColor = self.view.backgroundColor;
        self.textField.tintColor = UIColor.qd_tintColor;
        self.textField.defaultTextAttributes = @{NSFontAttributeName: UIFontMake(14),
                                                 NSForegroundColorAttributeName: UIColor.qd_tintColor};
        self.textField.text = @" example text";
        [self addSubview:self.textField];
        
        self.labelLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.labelLabel.text = @"UILabel";
        [self.labelLabel sizeToFit];
        [self addSubview:self.labelLabel];
        
        self.label = [[UILabel alloc] init];
        self.label.attributedText = ({
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"example text..." attributes:@{NSFontAttributeName: UIFontMake(16),
                                                                                                                                  NSForegroundColorAttributeName: UIColor.qd_mainTextColor
                                                                                                                                  }];
            [string addAttribute:NSForegroundColorAttributeName value:UIColor.qd_tintColor range:NSMakeRange(0, @"example".length)];
            string.copy;
        });
        self.label.shadowColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [([identifier isEqualToString:QDThemeIdentifierDark] ? UIColorWhite : UIColorBlack) colorWithAlphaComponent:.5];
        }];
        self.label.shadowOffset = CGSizeMake(1, 1);
        [self.label sizeToFit];
        [self addSubview:self.label];
        
        self.textViewLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.textViewLabel.text = @"UITextView";
        [self.textViewLabel sizeToFit];
        [self addSubview:self.textViewLabel];
        
        self.textView = [[UITextView alloc] qmui_initWithSize:self.textField.frame.size];
        self.textView.backgroundColor = self.view.backgroundColor;
        self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(14),
                                           NSForegroundColorAttributeName: UIColor.qd_tintColor};
        self.textView.text = @"example text";
        [self addSubview:self.textView];
        
        self.sliderLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.sliderLabel.text = @"UISlider";
        [self.sliderLabel sizeToFit];
        [self addSubview:self.sliderLabel];
        
        self.slider = [[UISlider alloc] init];
        self.slider.minimumTrackTintColor = UIColor.qd_tintColor;
        self.slider.maximumTrackTintColor = UIColor.qd_separatorColor;
        self.slider.thumbTintColor = self.slider.minimumTrackTintColor;
        self.slider.value = .3;
        [self.slider sizeToFit];
        [self addSubview:self.slider];
        
        self.switchLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.switchLabel.text = @"UISwitch";
        [self.switchLabel sizeToFit];
        [self addSubview:self.switchLabel];
        
        self.switchControlOn = [[UISwitch alloc] init];
        self.switchControlOn.on = YES;
        [self.switchControlOn sizeToFit];
        self.switchControlOn.onTintColor = UIColor.qd_tintColor;
        self.switchControlOn.tintColor = self.switchControlOn.onTintColor;
        [self addSubview:self.switchControlOn];
        
        self.switchControlOff = [[UISwitch alloc] init];
        [self.switchControlOff sizeToFit];
        self.switchControlOff.onTintColor = self.switchControlOn.onTintColor;
        self.switchControlOff.tintColor = self.switchControlOff.onTintColor;
        [self addSubview:self.switchControlOff];
        
        self.imageViewLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.imageViewLabel.text = @"UIImage";
        [self.imageViewLabel sizeToFit];
        [self addSubview:self.imageViewLabel];
        
        UIImage *image = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
            return [UIImageMake(@"icon_grid_assetsManager") qmui_imageWithTintColor:theme.themeTintColor];
        }];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imageView];
        
        self.progressLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.progressLabel.text = @"UIProgressView";
        [self.progressLabel sizeToFit];
        [self addSubview:self.progressLabel];
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.progressTintColor = UIColor.qd_tintColor;
        self.progressView.trackTintColor = UIColor.qd_separatorColor;
        self.progressView.progress = .3;
        [self addSubview:self.progressView];
        
        self.visualEffectLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.visualEffectLabel.text = @"UIVisualEffectView";
        [self.visualEffectLabel sizeToFit];
        [self addSubview:self.visualEffectLabel];
        
        self.visualEffectBackendImageView = [[UIImageView alloc] initWithImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<QDThemeProtocol> * _Nullable theme) {
            return [UIImageMake(@"icon_grid_pieProgressView") qmui_imageWithTintColor:theme.themeTintColor];
        }]];
        [self addSubview:self.visualEffectBackendImageView];
        
        self.visualEffectView = [[UIVisualEffectView alloc] init];
        self.visualEffectView.effect = UIVisualEffect.qd_standardBlurEffect;
        [self addSubview:self.visualEffectView];
        
        self.navigationBarLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.navigationBarLabel.text = @"UINavigationBar";
        [self.navigationBarLabel sizeToFit];
        [self addSubview:self.navigationBarLabel];
        
        self.navigationBar = [[UINavigationBar alloc] init];
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.barTintColor = UIColor.qd_tintColor;
        [self addSubview:self.navigationBar];
        
        self.tabBarLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.tabBarLabel.text = @"UITabBar";
        [self.tabBarLabel sizeToFit];
        [self addSubview:self.tabBarLabel];
        
        self.tabBar = [[UITabBar alloc] init];
        self.tabBar.backgroundImage = nil;
        self.tabBar.barTintColor = UIColor.qd_tintColor;
        [self addSubview:self.tabBar];
        
        self.toolbarLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.toolbarLabel.text = @"UIToolbar";
        [self.toolbarLabel sizeToFit];
        [self addSubview:self.toolbarLabel];
        
        self.toolbar = [[UIToolbar alloc] init];
        [self.toolbar setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        self.toolbar.barTintColor = UIColor.qd_tintColor;
        [self addSubview:self.toolbar];
        
        self.searchBarLabel = [[UILabel alloc] qmui_initWithFont:codeFont textColor:textColor];
        self.searchBarLabel.text = @"UISearchBar";
        [self.searchBarLabel sizeToFit];
        [self addSubview:self.searchBarLabel];
        
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.barTintColor = UIColor.qd_tintColor;
        self.searchBar.tintColor = UIColor.qd_tintColor;
        [self.searchBar sizeToFit];
        [self addSubview:self.searchBar];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = self.viewLabel.qmui_height + self.itemInnerSpacing + self.view.qmui_height + self.itemMarginBottom;
    height += self.labelLabel.qmui_height + self.itemInnerSpacing + self.label.qmui_height + self.itemMarginBottom;
    height += self.sliderLabel.qmui_height + self.itemInnerSpacing + self.slider.qmui_height + self.itemMarginBottom;
    height += self.switchLabel.qmui_height + self.itemInnerSpacing + self.switchControlOn.qmui_height + self.itemMarginBottom;
    height += self.progressLabel.qmui_height + self.itemInnerSpacing + self.progressView.qmui_height + self.itemMarginBottom;
    height += self.visualEffectLabel.qmui_height + self.itemInnerSpacing + self.barHeight + self.itemMarginBottom;
    height += self.navigationBarLabel.qmui_height + self.itemInnerSpacing + self.barHeight + self.itemMarginBottom;
    height += self.tabBarLabel.qmui_height + self.itemInnerSpacing + self.barHeight + self.itemMarginBottom;
    height += self.toolbarLabel.qmui_height + self.itemInnerSpacing + self.barHeight + self.itemMarginBottom;
    height += self.searchBarLabel.qmui_height + self.itemInnerSpacing + self.searchBar.qmui_height + self.itemMarginBottom;
    size.height = height;
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.view.qmui_top = self.viewLabel.qmui_bottom + self.itemInnerSpacing;
    
    self.textField.qmui_top = self.view.qmui_top;
    self.textField.qmui_right = self.qmui_width;
    self.textFieldLabel.qmui_left = self.textField.qmui_left;
    
    self.labelLabel.qmui_top = self.view.qmui_bottom + self.itemMarginBottom;
    self.label.qmui_top = self.labelLabel.qmui_bottom + self.itemInnerSpacing;
    
    self.textView.qmui_top = self.label.qmui_top;
    self.textView.qmui_right = self.qmui_width;
    self.textViewLabel.qmui_left = self.textView.qmui_left;
    self.textViewLabel.qmui_top = self.labelLabel.qmui_top;
    
    self.sliderLabel.qmui_top = self.label.qmui_bottom + self.itemMarginBottom;
    self.slider.qmui_top = self.sliderLabel.qmui_bottom + self.itemInnerSpacing;
    self.slider.qmui_width = self.qmui_width * 2 / 3;
    
    self.switchLabel.qmui_top = self.slider.qmui_bottom + self.itemMarginBottom;
    self.switchControlOn.qmui_top = self.switchLabel.qmui_bottom + self.itemInnerSpacing;
    self.switchControlOff.qmui_top = self.switchControlOn.qmui_top;
    self.switchControlOff.qmui_left = self.switchControlOn.qmui_right + 36;
    
    self.imageViewLabel.qmui_left = self.textViewLabel.qmui_left;
    self.imageViewLabel.qmui_top = self.switchLabel.qmui_top;
    self.imageView.qmui_top = self.imageViewLabel.qmui_bottom + self.itemInnerSpacing;
    self.imageView.qmui_left = self.imageViewLabel.qmui_left;
    
    self.progressLabel.qmui_top = self.switchControlOn.qmui_bottom + self.itemMarginBottom;
    self.progressView.qmui_top = self.progressLabel.qmui_bottom + self.itemInnerSpacing;
    
    self.visualEffectLabel.qmui_top = self.progressView.qmui_bottom + self.itemMarginBottom;
    self.visualEffectView.qmui_top = self.visualEffectLabel.qmui_bottom + self.itemInnerSpacing;
    self.visualEffectView.qmui_width = self.qmui_width;
    self.visualEffectView.qmui_height = self.barHeight;
    self.visualEffectBackendImageView.center = self.visualEffectView.center;
    
    self.navigationBarLabel.qmui_top = self.visualEffectView.qmui_bottom + self.itemMarginBottom;
    self.navigationBar.qmui_top = self.navigationBarLabel.qmui_bottom + self.itemInnerSpacing;
    self.navigationBar.qmui_width = self.qmui_width;
    self.navigationBar.qmui_height = self.barHeight;
    
    self.tabBarLabel.qmui_top = self.navigationBar.qmui_bottom + self.itemMarginBottom;
    self.tabBar.qmui_top = self.tabBarLabel.qmui_bottom + self.itemInnerSpacing;
    self.tabBar.qmui_width = self.qmui_width;
    self.tabBar.qmui_height = self.barHeight;
    
    self.toolbarLabel.qmui_top = self.tabBar.qmui_bottom + self.itemMarginBottom;
    self.toolbar.qmui_top = self.toolbarLabel.qmui_bottom + self.itemInnerSpacing;
    self.toolbar.qmui_width = self.qmui_width;
    self.toolbar.qmui_height = self.barHeight;
    
    self.searchBarLabel.qmui_top = self.toolbar.qmui_bottom + self.itemMarginBottom;
    self.searchBar.qmui_top = self.searchBarLabel.qmui_bottom + self.itemInnerSpacing;
    self.searchBar.qmui_width = self.qmui_width;
}

@end
