//
//  QDTableViewHeaderFooterViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/11/7.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDTableViewHeaderFooterViewController.h"

@interface QDTableViewInsetDebugPanelView : UIView

- (void)renderWithTableView:(UITableView *)tableView;
@end

@interface QDTableViewHeaderFooterViewController ()

@property(nonatomic, strong) QDTableViewInsetDebugPanelView *debugView;
@end

@implementation QDTableViewHeaderFooterViewController

- (void)initSubviews {
    [super initSubviews];
    self.debugView = [[QDTableViewInsetDebugPanelView alloc] init];
    [self.view addSubview:self.debugView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets margins = UIEdgeInsetsZero;
    CGFloat debugViewWidth = fmin(self.view.qmui_width, [QMUIHelper screenSizeFor55Inch].width) - UIEdgeInsetsGetHorizontalValue(margins);
    CGFloat debugViewHeight = 126;
    CGFloat debugViewMinX = CGFloatGetCenter(self.view.qmui_width, debugViewWidth);
    self.debugView.frame = CGRectMake(debugViewMinX, self.view.qmui_height - margins.bottom - debugViewHeight, debugViewWidth, debugViewHeight);
}

- (void)handleButtonEvent:(UIView *)view {
    // 通过这个方法获取到点击的按钮所处的 sectionHeader，可兼容 sectionHeader 停靠在列表顶部的场景
    NSInteger sectionIndexForView = [self.tableView qmui_indexForSectionHeaderAtView:view];
    if (sectionIndexForView != -1) {
        [QMUITips showWithText:[NSString stringWithFormat:@"点击了 section%@ 上的按钮", @(sectionIndexForView)] inView:self.view hideAfterDelay:1.2];
    } else {
        [QMUITips showError:@"无法定位被点击的按钮所处的 section" inView:self.view hideAfterDelay:1.2];
    }
}

// 下面这堆代码都不用看，主要看上面的 handle 方法

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.debugView renderWithTableView:self.tableView];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString qmui_stringWithNSInteger:indexPath.row];
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section%@", @(section)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QMUITableViewHeaderFooterView *headerView = (QMUITableViewHeaderFooterView *)[super tableView:tableView viewForHeaderInSection:section];
    QMUIButton *button = (QMUIButton *)headerView.accessoryView;
    if (!button) {
        button = [QDUIHelper generateLightBorderedButton];
        [button setTitle:@"Button" forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(14);
        button.contentEdgeInsets = UIEdgeInsetsMake(4, 12, 4, 12);
        [button sizeToFit];
        button.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
        button.qmui_outsideEdge = UIEdgeInsetsMake(-8, -8, -8, -8);
        [button addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        headerView.accessoryView = button;
    }
    return headerView;
}

@end

@interface QDTableViewInsetDebugPanelView ()

// 可视范围内的 sectionHeader 列表
@property(nonatomic, strong) UILabel *visibleHeadersLabel;
@property(nonatomic, strong) UILabel *visibleHeadersValue;

// 当前 pinned 的那个 section 序号
@property(nonatomic, strong) UILabel *pinnedHeaderLabel;
@property(nonatomic, strong) UILabel *pinnedHeaderValue;

// 某个指定的 section 的 pinned 状态
@property(nonatomic, strong) UILabel *headerPinnedLabel;
@property(nonatomic, strong) UILabel *headerPinnedValue;
@end

@implementation QDTableViewInsetDebugPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, .7);
        
        self.visibleHeadersLabel = [self generateTitleLabel];
        self.visibleHeadersLabel.text = @"可视的 sectionHeaders";
        self.visibleHeadersValue = [self generateValueLabel];
        
        self.pinnedHeaderLabel = [self generateTitleLabel];
        self.pinnedHeaderLabel.text = @"正在 pinned（悬浮）的 header";
        self.pinnedHeaderValue = [self generateValueLabel];
        
        self.headerPinnedLabel = [self generateTitleLabel];
        self.headerPinnedLabel.text = @"section0 和 section1 的 pinned";
        self.headerPinnedValue = [self generateValueLabel];
    }
    return self;
}

- (UILabel *)generateTitleLabel {
    UILabel *label = [[UILabel alloc] qmui_initWithFont:UIFontMake(12) textColor:UIColorWhite];
    [label qmui_calculateHeightAfterSetAppearance];
    [self addSubview:label];
    return label;
}

- (UILabel *)generateValueLabel {
    UILabel *label = [[UILabel alloc] qmui_initWithFont:UIFontMake(12) textColor:UIColorWhite];
    label.textAlignment = NSTextAlignmentRight;
    [label qmui_calculateHeightAfterSetAppearance];
    [self addSubview:label];
    return label;
}

- (void)renderWithTableView:(UITableView *)tableView {
    self.visibleHeadersValue.text = [tableView.qmui_indexForVisibleSectionHeaders componentsJoinedByString:@", "];
    
    NSInteger indexOfPinnedSectionHeader = tableView.qmui_indexOfPinnedSectionHeader;
    NSString *pinnedHeaderString = [NSString qmui_hexStringWithInteger:indexOfPinnedSectionHeader];
    self.pinnedHeaderValue.text = pinnedHeaderString;
    self.pinnedHeaderValue.textColor = indexOfPinnedSectionHeader == -1 ? UIColorRed : UIColorWhite;
    
    BOOL isSectionHeader0Pinned = [tableView qmui_isHeaderPinnedForSection:0];
    BOOL isSectionHeader1Pinned = [tableView qmui_isHeaderPinnedForSection:1];
    NSMutableAttributedString *headerPinnedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0: %@ | 1: %@", StringFromBOOL(isSectionHeader0Pinned), StringFromBOOL(isSectionHeader1Pinned)] attributes:@{NSFontAttributeName: self.pinnedHeaderValue.font, NSForegroundColorAttributeName: UIColorWhite}];
    
    NSRange range0 = isSectionHeader0Pinned ? NSMakeRange(3, 3) : NSMakeRange(3, 2);
    NSRange range1 = isSectionHeader1Pinned ? NSMakeRange(headerPinnedString.length - 3, 3) : NSMakeRange(headerPinnedString.length - 2, 2);
    [headerPinnedString addAttribute:NSForegroundColorAttributeName value:isSectionHeader0Pinned ? UIColorGreen : UIColorRed range:range0];
    [headerPinnedString addAttribute:NSForegroundColorAttributeName value:isSectionHeader1Pinned ? UIColorGreen : UIColorRed range:range1];
    self.headerPinnedValue.attributedText = headerPinnedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsConcat(UIEdgeInsetsMake(24, 24, 24, 24), self.qmui_safeAreaInsets);
    NSArray<UILabel *> *leftLabels = @[self.visibleHeadersLabel, self.pinnedHeaderLabel, self.headerPinnedLabel];
    NSArray<UILabel *> *rightLabels = @[self.visibleHeadersValue, self.pinnedHeaderValue, self.headerPinnedValue];
    
    CGFloat contentWidth = self.qmui_width - UIEdgeInsetsGetHorizontalValue(padding);
    CGFloat labelHorizontalSpacing = 16;
    CGFloat labelVerticalSpacing = 16;
    CGFloat minY = padding.top;
    
    // 左边的 label
    CGFloat leftLabelWidth = flat((contentWidth - labelHorizontalSpacing) * 3 / 5);
    for (NSInteger i = 0; i < leftLabels.count; i++) {
        UILabel *label = leftLabels[i];
        label.frame = CGRectFlatMake(padding.left, minY, leftLabelWidth, label.qmui_height);
        minY = label.qmui_bottom + labelVerticalSpacing;
    }
    
    // 右边的 label
    minY = padding.top;
    CGFloat rightLabelMinX = leftLabels.firstObject.qmui_right + labelHorizontalSpacing;
    CGFloat rightLabelWidth = flat(contentWidth - leftLabelWidth - labelHorizontalSpacing);
    for (NSInteger i = 0; i < rightLabels.count; i++) {
        UILabel *label = rightLabels[i];
        label.frame = CGRectFlatMake(rightLabelMinX, minY, rightLabelWidth, label.qmui_height);
        minY = label.qmui_bottom + labelVerticalSpacing;
    }
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
}

@end
