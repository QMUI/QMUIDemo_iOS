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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initDataSource];
    }
    return self;
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
    
    if (CGRectGetWidth(self.view.bounds) <= [QMUIHelper screenSizeFor55Inch].width) {
        self.gridView.columnCount = 3;
        CGFloat itemWidth = flatf(CGRectGetWidth(self.scrollView.bounds) / self.gridView.columnCount);
        self.gridView.rowHeight = itemWidth;
    } else {
        CGFloat minimumItemWidth = flatf([QMUIHelper screenSizeFor55Inch].width / 3.0);
        CGFloat maximumItemWidth = flatf(CGRectGetWidth(self.view.bounds) / 5.0);
        CGFloat freeSpacingWhenDisplayingMinimumCount = CGRectGetWidth(self.scrollView.bounds) / maximumItemWidth - floorf(CGRectGetWidth(self.scrollView.bounds) / maximumItemWidth);
        CGFloat freeSpacingWhenDisplayingMaximumCount = CGRectGetWidth(self.scrollView.bounds) / minimumItemWidth - floorf(CGRectGetWidth(self.scrollView.bounds) / minimumItemWidth);
        if (freeSpacingWhenDisplayingMinimumCount < freeSpacingWhenDisplayingMaximumCount) {
            // 按每行最少item的情况来布局的话，空间利用率会更高，所以按最少item来
            self.gridView.columnCount = floorf(CGRectGetWidth(self.scrollView.bounds) / maximumItemWidth);
            CGFloat itemWidth = floorf(CGRectGetWidth(self.scrollView.bounds) / self.gridView.columnCount);
            self.gridView.rowHeight = itemWidth;
        } else {
            self.gridView.columnCount = floorf(CGRectGetWidth(self.scrollView.bounds) / minimumItemWidth);
            CGFloat itemWidth = floorf(CGRectGetWidth(self.scrollView.bounds) / self.gridView.columnCount);
            self.gridView.rowHeight = itemWidth;
        }
    }
    
    CGFloat gridViewHeight = [self.gridView sizeThatFits:CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGFLOAT_MAX)].height;
    self.gridView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), gridViewHeight);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.gridView.frame));
}

- (QDCommonGridButton *)generateButtonAtIndex:(NSInteger)index {
    NSString *keyName = self.dataSource.allKeys[index];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:keyName attributes:@{NSForegroundColorAttributeName: UIColorGray6, NSFontAttributeName: UIFontMake(11), NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:12 lineBreakMode:NSLineBreakByTruncatingTail textAlignment:NSTextAlignmentCenter]}];
    UIImage *image = (UIImage *)[self.dataSource objectForKey:keyName];
    
    QDCommonGridButton *button = [[QDCommonGridButton alloc] init];
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
        self.qmui_needsTakeOverTouchEvent = YES;
        self.qmui_borderPosition = QMUIBorderViewPositionRight | QMUIImageBorderPositionBottom;
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
    CGPoint center = CGPointMake(flatf(self.contentEdgeInsets.left + contentSize.width / 2), flatf(self.contentEdgeInsets.top + contentSize.height / 2));
    
    self.imageView.center = CGPointMake(center.x, center.y - 12);
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:contentSize];
    self.titleLabel.frame = CGRectFlatMake(self.contentEdgeInsets.left, center.y + PreferredVarForDevices(27, 27, 21, 21), contentSize.width, titleLabelSize.height);
}

@end
