//
//  QDThemeViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/5/10.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDThemeViewController.h"
#import "QMUIConfigurationTemplate.h"
#import "QMUIConfigurationTemplateGrapefruit.h"
#import "QMUIConfigurationTemplateGrass.h"
#import "QMUIConfigurationTemplatePinkRose.h"

@interface QDThemeButton : QMUIButton

@property(nonatomic, strong) UIColor *themeColor;
@property(nonatomic, copy) NSString *themeName;
@end

@interface QDThemeViewController ()

@property(nonatomic, copy) NSArray<NSObject<QDThemeProtocol> *> *themes;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray<QDThemeButton *> *themeButtons;
@end

@implementation QDThemeViewController

- (void)didInitialized {
    [super didInitialized];
    
    // 因为配置表在 QMUIConfiguration 里也可能会自动 init，所以这里为了避免重复 init，就做了复用处理
    NSMutableArray<NSObject<QDThemeProtocol> *> *themes = [[NSMutableArray alloc] init];
    NSArray<NSString *> *allThemeClassName = @[NSStringFromClass([QMUIConfigurationTemplate class]),
                                               NSStringFromClass([QMUIConfigurationTemplateGrapefruit class]),
                                               NSStringFromClass([QMUIConfigurationTemplateGrass class]),
                                               NSStringFromClass([QMUIConfigurationTemplatePinkRose class])];
    [allThemeClassName enumerateObjectsUsingBlock:^(NSString * _Nonnull className, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([QDThemeManager sharedInstance].currentTheme && [className isEqualToString:NSStringFromClass([QDThemeManager sharedInstance].currentTheme.class)]) {
            [themes addObject:[QDThemeManager sharedInstance].currentTheme];
        } else {
            [themes addObject:[[NSClassFromString(className) alloc] init]];
        }
    }];
    
    self.themes = [themes copy];
    self.themeButtons = [[NSMutableArray alloc] init];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    for (NSInteger i = 0, l = self.themes.count; i < l; i++) {
        NSObject<QDThemeProtocol> *theme = self.themes[i];
        BOOL isCurrentTheme = [theme isKindOfClass:[QDThemeManager sharedInstance].currentTheme.class];
        QDThemeButton *themeButton = [[QDThemeButton alloc] init];
        themeButton.themeColor = theme.themeTintColor;
        themeButton.themeName = theme.themeName;
        themeButton.selected = isCurrentTheme;
        [themeButton addTarget:self action:@selector(handleThemeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:themeButton];
        [self.themeButtons addObject:themeButton];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    
    UIEdgeInsets padding = UIEdgeInsetsMake(24, 24, 24, 24);
    CGFloat buttonSpacing = 24;
    CGSize buttonSize = CGSizeFlatted(CGSizeMake(CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(padding), 110));
    CGFloat buttonMinY = padding.top;
    for (NSInteger i = 0, l = self.themeButtons.count; i < l; i++) {
        QDThemeButton *themeButton = self.themeButtons[i];
        themeButton.frame = CGRectMake(padding.left, buttonMinY, buttonSize.width, buttonSize.height);
        buttonMinY = CGRectGetMaxY(themeButton.frame) + (i == l - 1 ? 0 : buttonSpacing);
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), buttonMinY + padding.bottom);
}

- (void)handleThemeButtonEvent:(QDThemeButton *)themeButton {
    [self.themeButtons enumerateObjectsUsingBlock:^(QDThemeButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = themeButton == obj;
    }];
    
    NSInteger themeIndex = [self.themeButtons indexOfObject:themeButton];
    [QDThemeManager sharedInstance].currentTheme = self.themes[themeIndex];
    [[NSUserDefaults standardUserDefaults] setObject:NSStringFromClass(self.themes[themeIndex].class) forKey:QDSelectedThemeClassName];
}

@end

@implementation QDThemeButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = UIFontMake(14);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = UIColorWhite;
        [self setTitleColor:UIColorGray3 forState:UIControlStateNormal];
        
        self.layer.borderWidth = PixelOne;
        self.layer.borderColor = UIColorMakeWithRGBA(0, 0, 0, .1).CGColor;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    self.backgroundColor = themeColor;
    [self setTitleColor:themeColor forState:UIControlStateSelected];
}

- (void)setThemeName:(NSString *)themeName {
    _themeName = themeName;
    [self setTitle:themeName forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.titleLabel.font = selected ? UIFontBoldMake(14) : UIFontMake(14);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelHeight = 36;
    self.titleLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - labelHeight, CGRectGetWidth(self.bounds), labelHeight);
}

@end
