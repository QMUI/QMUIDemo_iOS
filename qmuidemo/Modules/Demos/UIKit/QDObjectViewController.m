//
//  QDObjectViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/3/24.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDObjectViewController.h"
#import "QDObjectMethodsListViewController.h"

@interface QDObjectViewController ()

@property(nonatomic, strong) NSMutableArray<NSString *> *allClasses;
@property(nonatomic, strong) NSMutableArray<NSString *> *autocompletionClasses;
@end

@implementation QDObjectViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.shouldShowSearchBar = YES;
        
        self.autocompletionClasses = [[NSMutableArray alloc] init];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.allClasses = [self allClassesArray];
        });
    }
    return self;
}

- (void)initSearchController {
    [super initSearchController];
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchBar.placeholder = @"请输入 Class 名称，不区分大小写";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showEmptyViewWithText:@"NSObject (QMUI) 支持列出给定的 Class、Protocol 的方法。本示例允许你查看任意 Class 的实例方法，请通过上方搜索框搜索。" detailText:nil buttonTitle:nil buttonAction:NULL];
}

- (void)showEmptyView {
    [super showEmptyView];
    self.emptyView.textLabel.qmui_textAttributes = @{NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24]};
}

- (NSMutableArray<NSString *> *)allClassesArray {
    NSMutableArray<NSString *> *allClasses = [[NSMutableArray alloc] init];
    Class *classes = nil;
    int numberOfClasses = objc_getClassList(nil, 0);
    if (numberOfClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
        numberOfClasses = objc_getClassList(classes, numberOfClasses);
        for (int i = 0; i < numberOfClasses; i++) {
            Class c = classes[i];
            [allClasses addObject:NSStringFromClass(c)];
        }
        free(classes);
    }
    return allClasses;
}

- (double)matchingWeightForResult:(NSString *)className withSearchString:(NSString *)searchString {
    /**
     排序方式：
     1. 每个 className 都有一个基准的匹配权重，权重取值范围 [0-1]，这个权重简单地以字符串长度来计算，匹配到的 className 里长度越短的 className 认为匹配度越高
     2. 基于步骤 1 得到的匹配权重进行分段，以搜索词开头的 className 权重最高，以下划线开头的 className 权重最低（如果搜索词本来就以下划线开头则不计入此种情况），其他情况权重中等。
     3. 特别的，如果 className 与搜索词完全匹配，则权重最高，为 1
     4. 最终权重越高者排序越靠前
     */
    
    className = className.lowercaseString;
    searchString = searchString.lowercaseString;
    
    if ([className isEqualToString:searchString]) {
        return 1;
    }
    
    double matchingWeight = (double)searchString.length / (double)className.length;
    if ([className hasPrefix:searchString]) {
        return matchingWeight * 1.0 / 3.0 + 2.0 / 3.0;
    }
    if ([className hasPrefix:@"_"] && ![searchString hasPrefix:@"_"]) {
        return matchingWeight * 1.0 / 3.0;
    }
    matchingWeight = matchingWeight * 1.0 / 3.0 + 1.0 / 3.0;
    
    return matchingWeight;
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.autocompletionClasses.count;
}

- (UITableViewCell *)qmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withReuseIdentifier:identifier];
        cell.textLabel.numberOfLines = 0;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [self qmui_tableView:tableView cellWithIdentifier:@"cell"];
    NSString *className = self.autocompletionClasses[indexPath.row];
    NSRange matchingRange = [className.lowercaseString rangeOfString:self.searchBar.text.lowercaseString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:className attributes:@{NSFontAttributeName: CodeFontMake(14), NSForegroundColorAttributeName: UIColorGray1}];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[QDThemeManager sharedInstance].currentTheme.themeTintColor range:matchingRange];
    cell.textLabel.attributedText = attributedString;
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.autocompletionClasses[indexPath.row];
    Class aClass = NSClassFromString(className);
    QDObjectMethodsListViewController *methodsListController = [[QDObjectMethodsListViewController alloc] initWithClass:aClass];
    methodsListController.title = className;
    [self.navigationController pushViewController:methodsListController animated:YES];
}

#pragma mark - <QMUISearchControllerDelegate>

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    [self.autocompletionClasses removeAllObjects];
    
    if (searchString.length > 2) {
        for (NSString *className in self.allClasses) {
            if ([className.lowercaseString containsString:searchString.lowercaseString]) {
                [self.autocompletionClasses addObject:className];
            }
        }
        
        [self.autocompletionClasses sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            double matchingWeight1 = [self matchingWeightForResult:obj1 withSearchString:searchString];
            double matchingWeight2 = [self matchingWeightForResult:obj2 withSearchString:searchString];
            NSComparisonResult result = matchingWeight1 == matchingWeight2 ? NSOrderedSame : (matchingWeight1 > matchingWeight2 ? NSOrderedAscending : NSOrderedDescending);
            if ([obj1 isEqualToString:@"PLUIView"] && [obj2 isEqualToString:@"UIViewAnimation"]) {
                NSLog(@"1, searchString = %@, %@ vs. %@ = %.3f, %.3f", searchString, obj1, obj2, matchingWeight1, matchingWeight2);
            } else if ([obj1 isEqualToString:@"UIViewAnimation"] && [obj2 isEqualToString:@"PLUIView"]) {
                NSLog(@"2, searchString = %@, %@ vs. %@ = %.3f, %.3f", searchString, obj1, obj2, matchingWeight1, matchingWeight2);
            }
            return result;
        }];
    }
    
    [searchController.tableView reloadData];
}

@end
