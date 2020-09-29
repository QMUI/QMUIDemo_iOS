//
//  QDAllSystemFontsViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 16/9/20.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDAllSystemFontsViewController.h"

@interface QDAllSystemFontsViewController ()

@property(nonatomic, strong) NSMutableArray<UIFont *> *allFonts;
@property(nonatomic, strong) NSMutableArray<UIFont *> *searchResultFonts;
@end

@implementation QDAllSystemFontsViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.shouldShowSearchBar = YES;
        self.allFonts = [[NSMutableArray alloc] init];
        self.searchResultFonts = [[NSMutableArray alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSString *familyName in [UIFont familyNames]) {// 注意，familyNames 获取到的字体大全里不包含系统默认字体（iOS 13 是 .SFUI，iOS 12 及以前是 .SFUIText）
                for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
                    [self.allFonts addObject:[UIFont fontWithName:fontName size:16]];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self isViewLoaded]) {
                    [self.tableView reloadData];
                }
            });
        });
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray<UIFont *> *fonts = tableView == self.tableView ? self.allFonts : self.searchResultFonts;
    return fonts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<UIFont *> *fonts = tableView == self.tableView ? self.allFonts : self.searchResultFonts;
    NSString *fontName = fonts[indexPath.row].fontName;
    if ([fontName containsString:@"Zapfino"]) {
        // 这个字体很飘逸，不够高是显示不全的
        return TableViewCellNormalHeight + 60;
    }
    return TableViewCellNormalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<UIFont *> *fonts = tableView == self.tableView ? self.allFonts : self.searchResultFonts;
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = UIColor.qd_mainTextColor;
        cell.detailTextLabel.textColor = UIColor.qd_descriptionTextColor;
    }
    
    UIFont *font = fonts[indexPath.row];
    cell.textLabel.font = font;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @(indexPath.row + 1), font.fontName];
    cell.detailTextLabel.font = font;
    cell.detailTextLabel.text = @"中文的效果";
    
    return cell;
}

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    [self.searchResultFonts removeAllObjects];
    for (UIFont *font in self.allFonts) {
        if ([font.fontName.lowercaseString containsString:searchString.lowercaseString]) {
            [self.searchResultFonts addObject:font];
        }
    }
    [searchController.tableView reloadData];
}

@end
