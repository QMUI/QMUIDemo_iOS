//
//  QDAllSystemFontsViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/9/20.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDAllSystemFontsViewController.h"

@interface QDAllSystemFontsViewController ()

@property(nonatomic, strong) NSMutableArray<UIFont *> *allFonts;
@end

@implementation QDAllSystemFontsViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.allFonts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            [self.allFonts addObject:[UIFont fontWithName:fontName size:16]];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allFonts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontName = self.allFonts[indexPath.row].fontName;
    if ([fontName includesString:@"Zapfino"]) {
        // 这个字体很飘逸，不够高是显示不全的
        return TableViewCellNormalHeight + 60;
    }
    return TableViewCellNormalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = UIColorBlack;
        cell.detailTextLabel.textColor = UIColorGray3;
    }
    
    UIFont *font = self.allFonts[indexPath.row];
    cell.textLabel.font = font;
    cell.textLabel.text = font.fontName;
    cell.detailTextLabel.font = font;
    cell.detailTextLabel.text = @"中文的效果";
    
    return cell;
}

@end
