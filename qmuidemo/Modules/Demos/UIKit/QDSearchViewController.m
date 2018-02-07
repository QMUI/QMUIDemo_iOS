//
//  QDSearchViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/5/25.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDSearchViewController.h"

@interface QDRecentSearchView : UIView

@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;
@end

@implementation QDRecentSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        
        self.titleLabel = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorGray2];
        self.titleLabel.text = @"最近搜索";
        self.titleLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
        [self.titleLabel sizeToFit];
        self.titleLabel.qmui_borderPosition = QMUIBorderViewPositionBottom;
        [self addSubview:self.titleLabel];
        
        self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
        self.floatLayoutView.padding = UIEdgeInsetsZero;
        self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);
        [self addSubview:self.floatLayoutView];
        
        NSArray<NSString *> *suggestions = @[@"Helps", @"Maintain", @"Liver", @"Health", @"Function", @"Supports", @"Healthy", @"Fat"];
        for (NSInteger i = 0; i < suggestions.count; i++) {
            QMUIGhostButton *button = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorGray];
            [button setTitle:suggestions[i] forState:UIControlStateNormal];
            button.titleLabel.font = UIFontMake(14);
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
            [self.floatLayoutView addSubview:button];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsConcat(UIEdgeInsetsMake(26, 26, 26, 26), self.qmui_safeAreaInsets);
    CGFloat titleLabelMarginTop = 20;
    self.titleLabel.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.titleLabel.frame));
    
    CGFloat minY = CGRectGetMaxY(self.titleLabel.frame) + titleLabelMarginTop;
    self.floatLayoutView.frame = CGRectMake(padding.left, minY, CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.bounds) - minY);
}

@end

@interface QDSearchViewController ()<QMUISearchControllerDelegate>

@property(nonatomic, strong) NSArray<NSString *> *keywords;
@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property(nonatomic, strong) QMUISearchController *mySearchController;
@end

@implementation QDSearchViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        
        // 这个属性默认就是 NO，这里依然写出来只是为了提醒 QMUICommonTableViewController 默认就集成了 QMUISearchController，如果你的界面本身就是 QMUICommonTableViewController 的子类，则也可以直接通过将这个属性改为 YES 来创建 QMUISearchController
        self.shouldShowSearchBar = NO;
        
        self.keywords = @[@"Helps", @"Maintain", @"Liver", @"Health", @"Function", @"Supports", @"Healthy", @"Fat", @"Metabolism", @"Nuturally"];
        self.searchResultsKeywords = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.mySearchController.launchView = [[QDRecentSearchView alloc] init];// launchView 会自动布局，无需处理 frame
    self.mySearchController.searchBar.qmui_usedAsTableHeaderView = YES;// 以 tableHeaderView 的方式使用 searchBar 的话，将其置为 YES，以辅助兼容一些系统 bug
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
}

#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.keywords.count;
    }
    return self.searchResultsKeywords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withReuseIdentifier:identifier];
    }
    
    if (tableView == self.tableView) {
        cell.textLabel.text = self.keywords[indexPath.row];
    } else {
        NSString *keyword = self.searchResultsKeywords[indexPath.row];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:keyword attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        NSRange range = [keyword rangeOfString:self.mySearchController.searchBar.text];
        if (range.location != NSNotFound) {
            [attributedString addAttributes:@{NSForegroundColorAttributeName: [QDThemeManager sharedInstance].currentTheme.themeTintColor} range:range];
        }
        cell.textLabel.attributedText = attributedString;
    }
    
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - <QMUISearchControllerDelegate>

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    [self.searchResultsKeywords removeAllObjects];
    
    for (NSString *keyword in self.keywords) {
        if ([keyword containsString:searchString]) {
            [self.searchResultsKeywords addObject:keyword];
        }
    }
    
    [searchController.tableView reloadData];
    
    if (self.searchResultsKeywords.count == 0) {
        [searchController showEmptyViewWithText:@"没有匹配结果" detailText:nil buttonTitle:nil buttonAction:NULL];
    } else {
        [searchController hideEmptyView];
    }
}

- (void)willPresentSearchController:(QMUISearchController *)searchController {
    [QMUIHelper renderStatusBarStyleDark];
}

- (void)willDismissSearchController:(QMUISearchController *)searchController {
    BOOL oldStatusbarLight = NO;
    if ([self respondsToSelector:@selector(shouldSetStatusBarStyleLight)]) {
        oldStatusbarLight = [self shouldSetStatusBarStyleLight];
    }
    if (oldStatusbarLight) {
        [QMUIHelper renderStatusBarStyleLight];
    } else {
        [QMUIHelper renderStatusBarStyleDark];
    }
}

@end
