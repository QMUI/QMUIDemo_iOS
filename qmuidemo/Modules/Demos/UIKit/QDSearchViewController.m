//
//  QDSearchViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/5/25.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDSearchViewController.h"

@interface QDSearchViewController ()<QMUISearchControllerDelegate>

@property(nonatomic,strong) NSArray<NSString *> *keywords;
@property(nonatomic,strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property(nonatomic,strong) QMUISearchController *mySearchController;
@end

@implementation QDSearchViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.keywords = @[@"Helps", @"Maintain", @"Liver", @"Health", @"Function", @"Supports", @"Healthy", @"Fat", @"Metabolism", @"Nuturally"];
        self.searchResultsKeywords = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
}

#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>

- (BOOL)shouldShowSearchBarInTableView:(QMUITableView *)tableView {
    return YES;
}

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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView == self.tableView) {
        cell.textLabel.text = self.keywords[indexPath.row];
    } else {
        NSString *keyword = self.searchResultsKeywords[indexPath.row];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:keyword attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        NSRange range = [keyword rangeOfString:self.mySearchController.searchBar.text];
        if (range.location != NSNotFound) {
            [attributedString addAttributes:@{NSForegroundColorAttributeName: UIColorBlue} range:range];
        }
        cell.textLabel.attributedText = attributedString;
    }
    
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

#pragma mark - <QMUISearchControllerDelegate>

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    [self.searchResultsKeywords removeAllObjects];
    
    for (NSString *keyword in self.keywords) {
        if ([keyword qmui_includesString:searchString]) {
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
