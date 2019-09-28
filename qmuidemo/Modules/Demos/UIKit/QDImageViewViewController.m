//
//  QDImageViewViewController.m
//  qmuidemo
//
//  Created by MoLice on 2019/A/28.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import "QDImageViewViewController.h"

@interface QDImageViewTableViewCell : UITableViewCell

@end

@interface QDImageViewViewController ()

@property(nonatomic, assign) BOOL usingSmoothAnimation;
@property(nonatomic, strong) UIImage *animatedImage;
@end

@implementation QDImageViewViewController

- (void)didInitialize {
    [super didInitialize];
    self.usingSmoothAnimation = YES;
}

- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.animatedImage = [UIImage qmui_animatedImageNamed:@"animatedImage"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 140 : 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.section == 0 ? @"desc" : @"image";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ([identifier isEqualToString:@"desc"]) {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = TableViewCellBackgroundColor;
            cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:@"qmui_smoothAnimation" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.qd_mainTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:22]}];
            cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:@"UIImageView (QMUI) 默认打开了 qmui_smoothAnimation，以支持在 UIScrollView 内使用 animatedImage 时依然能保证界面的流畅（系统在这种情况下会有明显的卡顿）。可通过切换右边的开关来对比效果。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.qd_descriptionTextColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16]}];
            cell.detailTextLabel.numberOfLines = 0;
            UISwitch *switchControl = [[UISwitch alloc] init];
            [switchControl sizeToFit];
            switchControl.transform = CGAffineTransformMakeScale(.8, .8);
            [switchControl addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = switchControl;
        }
        ((UISwitch *)cell.accessoryView).on = self.usingSmoothAnimation;
    } else if ([identifier isEqualToString:@"image"]) {
        if (!cell) {
            cell = [[QDImageViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = TableViewCellBackgroundColor;
            cell.imageView.image = self.animatedImage;
        }
        cell.imageView.qmui_smoothAnimation = self.usingSmoothAnimation;
        if (!cell.imageView.qmui_smoothAnimation) {
            [cell.imageView startAnimating];
        }
    }
    
    return cell;
}

- (void)handleSwitchEvent:(UISwitch *)switchControl {
    self.usingSmoothAnimation = switchControl.on;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

@end

@implementation QDImageViewTableViewCell

// iOS 13 下系统无法正确地给 imageView 布局，size 总是为 0，所以这里写一个 subclass 专门布局 imageView
// iOS 12 及以下用系统的 UITableViewCell 就行了没啥问题
- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint imageViewOrigin = self.imageView.frame.origin;
    CGSize imageViewLimitSize = CGSizeMake(self.contentView.bounds.size.width - imageViewOrigin.x * 2, self.contentView.bounds.size.width - imageViewOrigin.y * 2);
    [self.imageView qmui_sizeToFitKeepingImageAspectRatioInSize:imageViewLimitSize];
    self.imageView.qmui_top = self.imageView.qmui_topWhenCenterInSuperview;
}

@end
