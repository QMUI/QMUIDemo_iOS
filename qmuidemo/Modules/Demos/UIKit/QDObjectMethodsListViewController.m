//
//  QDObjectMethodsListViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/3/24.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDObjectMethodsListViewController.h"

@interface QDObjectMethodsListViewController ()

@property(nonatomic, strong) NSMutableArray<NSString *> *properties;// 如果存在 property 则它放在 section0
@property(nonatomic, strong) NSMutableArray<NSString *> *ivarNames;// 如果存在 ivar 则它放在 section1
@property(nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *> *selectorNames;
@property(nonatomic, strong) NSMutableArray<NSString *> *indexesString;
@property(nonatomic, strong) NSMutableArray<NSAttributedString *> *searchResults;
@end

@implementation QDObjectMethodsListViewController

- (instancetype)initWithClass:(Class)aClass {
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        
        // 显示搜索框
        self.shouldShowSearchBar = YES;
        self.searchResults = [[NSMutableArray alloc] init];
        
        // 属性
        self.properties = [[NSMutableArray alloc] init];
        [NSObject qmui_enumratePropertiesOfClass:aClass includingInherited:NO usingBlock:^(objc_property_t property, NSString *propertyName) {
            QMUIPropertyDescriptor *descriptor = [QMUIPropertyDescriptor descriptorWithProperty:property];
            [self.properties addObject:descriptor.description];
        }];
        self.properties = [[[NSOrderedSet alloc] initWithArray:self.properties].array sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
        
        // 成员变量
        self.ivarNames = [[NSMutableArray alloc] init];
        [NSObject qmui_enumrateIvarsOfClass:aClass includingInherited:NO usingBlock:^(Ivar ivar, NSString *ivarName) {
            [self.ivarNames addObject:ivarName];
        }];
        self.ivarNames = [self.ivarNames sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
        
        // 方法
        self.selectorNames = [[NSMutableArray alloc] init];
        NSMutableArray<NSString *> *selectorNames = [[NSMutableArray alloc] init];
        [NSObject qmui_enumrateInstanceMethodsOfClass:aClass includingInherited:NO usingBlock:^(Method method, SEL selector) {
            [selectorNames addObject:[NSString stringWithFormat:@"- %@", NSStringFromSelector(selector)]];
        }];
        selectorNames = [selectorNames sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
        
        self.indexesString = [[NSMutableArray alloc] init];
        NSMutableArray<NSString *> *selectorNamesInCurrentSection = nil;
        for (NSInteger i = 0; i < selectorNames.count; i++) {
            NSString *selectorName = selectorNames[i];
            NSString *index = [selectorName substringWithRange:NSMakeRange(2, 1)];
            if (![self.indexesString containsObject:index]) {
                [self.indexesString addObject:index];
                
                selectorNamesInCurrentSection = [[NSMutableArray alloc] init];
                [self.selectorNames addObject:selectorNamesInCurrentSection];
            }
            [selectorNamesInCurrentSection addObject:selectorName];
        }
        
        // 处理完 selectorName 再将 ivars 插入 dataSource，是为了避免 selectorName 里也存在字母“V”，会导致一些逻辑判断错误
        if (self.ivarNames.count > 0) {
            [self.indexesString insertObject:@"V" atIndex:0];
        }
        
        if (self.properties.count > 0) {
            [self.indexesString insertObject:@"P" atIndex:0];
        }
        
        self.titleView.subtitle = [NSString stringWithFormat:@"%@个属性，%@个成员变量，%@个方法", @(self.properties.count), @(self.ivarNames.count), @(selectorNames.count)];
        self.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    }
    return self;
}

- (void)initTableView {
    [super initTableView];
    self.tableView.rowHeight = 50;
}

- (void)initSearchController {
    [super initSearchController];
    self.searchBar.placeholder = @"支持模糊搜索";
}

- (BOOL)isPropertiesSection:(NSInteger)section {
    return self.properties.count > 0 && section == 0;
}

- (BOOL)isIvarSection:(NSInteger)section {
    return self.ivarNames.count > 0 && ((self.properties.count > 0 && section == 1) || (self.properties.count <=0 && section == 0));
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.selectorNames.count + (self.properties.count > 0 ? 1 : 0) + (self.ivarNames.count > 0 ? 1 : 0);
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if ([self isPropertiesSection:section]) {
            return self.properties.count;
        }
        if ([self isIvarSection:section]) {
            return self.ivarNames.count;
        }
        return self.selectorNames[section - (self.properties.count > 0 ? 1 : 0) - (self.ivarNames.count > 0 ? 1 : 0)].count;
    }
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    if (tableView == self.tableView) {
        cell.textLabel.font = CodeFontMake(14);
        cell.textLabel.textColor = TableViewCellTitleLabelColor;
        NSString *name = nil;
        if ([self isPropertiesSection:indexPath.section]) {
            name = self.properties[indexPath.row];
        } else if ([self isIvarSection:indexPath.section]) {
            name = self.ivarNames[indexPath.row];
        } else {
            name = self.selectorNames[indexPath.section - ((self.properties.count ? 1 : 0)) - (self.ivarNames.count ? 1 : 0)][indexPath.row];
        }
        cell.textLabel.text = name;
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
        if ([self isPropertiesSection:section]) {
            return @"Properties";
        }
        if ([self isIvarSection:section]) {
            return @"Ivars";
        }
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
    
    void (^searchBlock)(NSString *obj, BOOL *stop) = ^(NSString *obj, BOOL *stop) {
        NSUInteger lastLocation = NSNotFound;
        NSMutableArray<NSNumber *> *highlightedLocation = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < searchStringArray.count; i++) {
            NSString *searchChar = searchStringArray[i].lowercaseString;
            NSString *selectorString = lastLocation == NSNotFound ? obj : [obj substringFromIndex:lastLocation + 1];// 从上一次查询到的位置往后查询，避免某个字符在 obj 里重复出现，则每次都会取到第一次出现的 location，就不准了
            NSUInteger location = [selectorString.lowercaseString rangeOfString:searchChar].location;
            if (location != NSNotFound) {
                location += (lastLocation == NSNotFound ? 0 : lastLocation + 1);
            }
            if (location == NSNotFound || (lastLocation != NSNotFound && location < lastLocation)) {
                lastLocation = NSNotFound;
                return;
            }
            lastLocation = location;
            [highlightedLocation addObject:@(location)];
        }
        if (lastLocation != NSNotFound) {
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:obj attributes:@{NSFontAttributeName: CodeFontMake(14), NSForegroundColorAttributeName: TableViewCellTitleLabelColor}];
            for (NSInteger i = 0; i < highlightedLocation.count; i++) {
                [result addAttribute:NSForegroundColorAttributeName value:QDThemeManager.currentTheme.themeCodeColor range:NSMakeRange(highlightedLocation[i].unsignedIntegerValue, 1)];
            }
            [self.searchResults addObject:result];
        }
    };
    
    [self.properties enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        searchBlock(obj, stop);
    }];
    [self.ivarNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        searchBlock(obj, stop);
    }];
    [self.selectorNames qmui_enumerateNestedArrayWithBlock:searchBlock];
    
    [searchController.tableView reloadData];
}

@end
