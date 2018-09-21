//
//  QDCommonGridViewController.m
//  qmuidemo
//
//  Created by MoLice on 2016/10/10.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCommonGridViewController.h"

@interface QDCommonGridViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;
@end

@interface QDCommonGridButton : QMUIButton

@end

@implementation QDCommonGridViewController

- (void)didInitialize {
    [super didInitialize];
    [self initDataSource];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    _gridView = [[QMUIGridView alloc] init];
    for (NSInteger i = 0, l = self.dataSource.count; i < l; i++) {
        [self.gridView addSubview:[self generateButtonAtIndex:i]];
    }
    [self.scrollView addSubview:self.gridView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    
    CGFloat gridViewWidth = CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(self.scrollView.qmui_safeAreaInsets);
    
    if (CGRectGetWidth(self.view.bounds) <= [QMUIHelper screenSizeFor55Inch].width) {
        self.gridView.columnCount = 3;
        CGFloat itemWidth = flat(gridViewWidth / self.gridView.columnCount);
        self.gridView.rowHeight = itemWidth;
    } else {
        CGFloat minimumItemWidth = flat([QMUIHelper screenSizeFor55Inch].width / 3.0);
        CGFloat maximumItemWidth = flat(gridViewWidth / 5.0);
        CGFloat freeSpacingWhenDisplayingMinimumCount = gridViewWidth / maximumItemWidth - floor(gridViewWidth / maximumItemWidth);
        CGFloat freeSpacingWhenDisplayingMaximumCount = gridViewWidth / minimumItemWidth - floor(gridViewWidth / minimumItemWidth);
        if (freeSpacingWhenDisplayingMinimumCount < freeSpacingWhenDisplayingMaximumCount) {
            // 按每行最少item的情况来布局的话，空间利用率会更高，所以按最少item来
            self.gridView.columnCount = floor(gridViewWidth / maximumItemWidth);
            CGFloat itemWidth = floor(gridViewWidth / self.gridView.columnCount);
            self.gridView.rowHeight = itemWidth;
        } else {
            self.gridView.columnCount = floor(gridViewWidth / minimumItemWidth);
            CGFloat itemWidth = floor(gridViewWidth / self.gridView.columnCount);
            self.gridView.rowHeight = itemWidth;
        }
    }
    
    for (NSInteger i = 0; i < self.gridView.subviews.count; i++) {
        UIView *item = self.gridView.subviews[i];
        item.qmui_borderPosition = QMUIViewBorderPositionLeft | QMUIViewBorderPositionTop;
        if ((i % self.gridView.columnCount == self.gridView.columnCount - 1) || (i == self.gridView.subviews.count - 1)) {
            // 每行最后一个，或者所有的最后一个（因为它可能不是所在行的最后一个）
            item.qmui_borderPosition |= QMUIViewBorderPositionRight;
        }
        if (i + self.gridView.columnCount >= self.gridView.subviews.count) {
            // 那些下方没有其他 item 的 item，底部都加个边框
            item.qmui_borderPosition |= QMUIViewBorderPositionBottom;
        }
    }
    
    self.gridView.frame = CGRectMake(self.scrollView.qmui_safeAreaInsets.left, 0, gridViewWidth, QMUIViewSelfSizingHeight);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.gridView.frame), CGRectGetMaxY(self.gridView.frame));
}

- (QDCommonGridButton *)generateButtonAtIndex:(NSInteger)index {
    NSString *keyName = self.dataSource.allKeys[index];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:keyName attributes:@{NSForegroundColorAttributeName: UIColorGray6, NSFontAttributeName: UIFontMake(11), NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:12 lineBreakMode:NSLineBreakByTruncatingTail textAlignment:NSTextAlignmentCenter]}];
    UIImage *image = (UIImage *)[self.dataSource objectForKey:keyName];
    
    QDCommonGridButton *button = [[QDCommonGridButton alloc] init];
    UIColor *tintColor = [QDThemeManager sharedInstance].currentTheme.themeGridItemTintColor;
    if (tintColor) {
        button.tintColor = tintColor;
        button.adjustsImageTintColorAutomatically = YES;
    } else {
        button.tintColor = nil;
        button.adjustsImageTintColorAutomatically = NO;
    }
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.tag = index;
    [button addTarget:self action:@selector(handleGirdButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)handleGirdButtonEvent:(QDCommonGridButton *)button {
    NSString *keyName = self.dataSource.allKeys[button.tag];
    [self didSelectCellWithTitle:keyName];
}

#pragma mark - <QDChangingThemeDelegate>

- (void)themeBeforeChanged:(NSObject<QDThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<QDThemeProtocol> *)themeAfterChanged {
    [super themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
    for (QDCommonGridButton *button in self.gridView.subviews) {
        UIColor *tintColor = themeAfterChanged.themeGridItemTintColor;
        if (tintColor) {
            button.tintColor = tintColor;
            button.adjustsImageTintColorAutomatically = YES;
        } else {
            button.tintColor = nil;
            button.adjustsImageTintColorAutomatically = NO;
        }
    }
}

@end

@implementation QDCommonGridViewController (UISubclassingHooks)

- (void)initDataSource {
    
}

- (void)didSelectCellWithTitle:(NSString *)title {
    
}

@end

@implementation QDCommonGridButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.numberOfLines = 2;
        self.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
        self.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
    }
    return self;
}

- (void)layoutSubviews {
    // 不用父类的，自己计算
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets));
    CGPoint center = CGPointMake(flat(self.contentEdgeInsets.left + contentSize.width / 2), flat(self.contentEdgeInsets.top + contentSize.height / 2));
    
    self.imageView.center = CGPointMake(center.x, center.y - 12);
    
    self.titleLabel.frame = CGRectFlatMake(self.contentEdgeInsets.left, center.y + PreferredValueForiPhone(27, 27, 21, 21), contentSize.width, QMUIViewSelfSizingHeight);
}

@end
