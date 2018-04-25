//
//  QDObjectMethodsListViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/3/24.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDObjectMethodsListViewController.h"

@interface QDObjectMethodsListViewController ()

@property(nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *> *selectorNames;
@property(nonatomic, strong) NSMutableArray<NSString *> *indexesString;
@property(nonatomic, strong) NSMutableArray<NSAttributedString *> *searchResults;
@end

@implementation QDObjectMethodsListViewController

- (instancetype)initWithClass:(Class)aClass {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.shouldShowSearchBar = YES;
        
        self.selectorNames = [[NSMutableArray alloc] init];
        
        NSMutableArray<NSString *> *selectorNames = [[NSMutableArray alloc] init];
        [NSObject qmui_enumrateInstanceMethodsOfClass:aClass usingBlock:^(SEL selector) {
            [selectorNames addObject:[NSString stringWithFormat:@"- %@", NSStringFromSelector(selector)]];
        }];
        
        self.titleView.subtitle = [NSString stringWithFormat:@"%@ 个方法", @(selectorNames.count)];
        self.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
        
        NSArray<NSString *> *sortedSelectorNames = [selectorNames sortedArrayUsingSelector:@selector(compare:)];
        
        self.indexesString = [[NSMutableArray alloc] init];
        NSMutableArray<NSString *> *selectorNamesInCurrentSection = nil;
        for (NSInteger i = 0; i < sortedSelectorNames.count; i++) {
            NSString *selectorName = sortedSelectorNames[i];
            NSString *index = [selectorName substringWithRange:NSMakeRange(2, 1)];
            if (![self.indexesString containsObject:index]) {
                [self.indexesString addObject:index];
                
                selectorNamesInCurrentSection = [[NSMutableArray alloc] init];
                [self.selectorNames addObject:selectorNamesInCurrentSection];
            }
            [selectorNamesInCurrentSection addObject:selectorName];
        }
        
        self.searchResults = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initTableView {
    [super initTableView];
    self.tableView.rowHeight = 50;
}

- (void)initSearchController {
    [super initSearchController];
    self.searchBar.placeholder = @"支持模糊搜索方法名";
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.selectorNames.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.selectorNames[section].count;
    }
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
    }
    
    if (tableView == self.tableView) {
        cell.textLabel.font = CodeFontMake(14);
        cell.textLabel.textColor = UIColorGray1;
        cell.textLabel.text = self.selectorNames[indexPath.section][indexPath.row];
    } else {
        // 有时候清空了 searchResults 后还会因为一些原因导致 tableView reload，然后就会越界，所以这里做个保护
        if (indexPath.row < self.searchResults.count) {
            cell.textLabel.attributedText = self.searchResults[indexPath.row];
        }
    }
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.indexesString[section];
    }
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.indexesString;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - <QMUISearchControllerDelegate>

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    [self.searchResults removeAllObjects];
    
    NSArray<NSString *> *searchStringArray = searchString.qmui_toTrimmedArray;
    if (!searchStringArray.count) return;
    
    [self.selectorNames qmui_enumerateNestedArrayWithBlock:^(NSString *obj, BOOL *stop) {
        NSUInteger lastLocation = NSNotFound;
        NSMutableArray<NSNumber *> *highlightedLocation = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < searchStringArray.count; i++) {
            NSString *searchChar = searchStringArray[i].lowercaseString;
            NSString *selectorString = lastLocation == NSNotFound ? obj : [obj substringFromIndex:lastLocation];// 从上一次查询到的位置往后查询，避免某个字符在 obj 里重复出现，则每次都会取到第一次出现的 location，就不准了
            NSUInteger location = [selectorString.lowercaseString rangeOfString:searchChar].location;
            if (location != NSNotFound) {
                location += (lastLocation == NSNotFound ? 0 : lastLocation);
            }
            if (location == NSNotFound || (lastLocation != NSNotFound && location < lastLocation)) {
                lastLocation = NSNotFound;
                return;
            }
            lastLocation = location;
            [highlightedLocation addObject:@(location)];
        }
        if (lastLocation != NSNotFound) {
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:obj attributes:@{NSFontAttributeName: CodeFontMake(14), NSForegroundColorAttributeName: UIColorGray1}];
            for (NSInteger i = 0; i < highlightedLocation.count; i++) {
                [result addAttribute:NSForegroundColorAttributeName value:[QDThemeManager sharedInstance].currentTheme.themeCodeColor range:NSMakeRange(highlightedLocation[i].unsignedIntegerValue, 1)];
            }
            [self.searchResults addObject:result];
        }
    }];
    
    [searchController.tableView reloadData];
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
