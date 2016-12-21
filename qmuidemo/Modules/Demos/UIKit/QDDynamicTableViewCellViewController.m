//
//  QDDynamicTableViewCellViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 2016/10/11.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDDynamicTableViewCellViewController.h"

static UIEdgeInsets const kInsets = {15, 16, 15, 16};
static CGFloat const kAvatarSize = 30;
static CGFloat const kAvatarMarginRight = 12;
static CGFloat const kAvatarMarginBottom = 6;
static CGFloat const kContentMarginBotom = 10;

@interface QDDynamicTableViewCell : QMUITableViewCell

@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *timeLabel;

- (void)renderWithNameText:(NSString *)nameText contentText:(NSString *)contentText;

@end

@implementation QDDynamicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UIImage *avatarImage = [UIImage imageWithStrokeColor:[UIColor randomColor] size:CGSizeMake(kAvatarSize, kAvatarSize) lineWidth:3 cornerRadius:6];
    _avatarImageView = [[UIImageView alloc] initWithImage:avatarImage];
    [self.contentView addSubview:self.avatarImageView];
    
    _nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = UIFontBoldMake(16);
    self.nameLabel.textColor = UIColorGray2;
    [self.contentView addSubview:self.nameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = UIFontMake(17);
    self.contentLabel.textColor = UIColorGray1;
    self.contentLabel.textAlignment = NSTextAlignmentJustified;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    _timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = UIFontMake(13);
    self.timeLabel.textColor = UIColorGray;
    [self.contentView addSubview:self.timeLabel];
    
}

- (void)renderWithNameText:(NSString *)nameText contentText:(NSString *)contentText {
    
    self.nameLabel.text = nameText;
    self.contentLabel.attributedText = [self attributeStringWithString:contentText lineHeight:26];
    self.timeLabel.text = @"昨天 18:24";
    
    [self setNeedsLayout];
}

- (NSAttributedString *)attributeStringWithString:(NSString *)textString lineHeight:(CGFloat)lineHeight {
    if (!textString.trim && textString.trim.length <= 0) return nil;
    NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:textString attributes:@{NSParagraphStyleAttributeName:[NSMutableParagraphStyle paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByTruncatingTail]}];
    return attriString;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(size.width, 0);
    CGFloat contentLabelWidth = size.width - UIEdgeInsetsGetHorizontalValue(kInsets);
    
    CGFloat resultHeight = UIEdgeInsetsGetHorizontalValue(kInsets) + CGRectGetHeight(self.avatarImageView.bounds) + kAvatarMarginBottom;
    
    if (self.contentLabel.text.length > 0) {
        CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        resultHeight += (contentSize.height + kContentMarginBotom);
    }
    
    if (self.timeLabel.text.length > 0) {
        CGSize timeSize = [self.timeLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        resultHeight += timeSize.height;
    }
    
    resultSize.height = resultHeight;
    return resultSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentLabelWidth = CGRectGetWidth(self.contentView.bounds) - UIEdgeInsetsGetHorizontalValue(kInsets);
    self.avatarImageView.frame = CGRectSetXY(self.avatarImageView.frame, kInsets.left, kInsets.top);
    if (self.nameLabel.text.length > 0) {
        CGFloat nameLabelWidth = contentLabelWidth - CGRectGetWidth(self.avatarImageView.bounds) - kAvatarMarginRight;
        CGSize nameSize = [self.nameLabel sizeThatFits:CGSizeMake(nameLabelWidth, CGFLOAT_MAX)];
        self.nameLabel.frame = CGRectFlatMake(CGRectGetMaxX(self.avatarImageView.frame) + kAvatarMarginRight, CGRectGetMinY(self.avatarImageView.frame) + (CGRectGetHeight(self.avatarImageView.bounds) - nameSize.height) / 2, nameLabelWidth, nameSize.height);
    }
    if (self.contentLabel.text.length > 0) {
        CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        self.contentLabel.frame = CGRectFlatMake(kInsets.left, CGRectGetMaxY(self.avatarImageView.frame) + kAvatarMarginBottom, contentLabelWidth, contentSize.height);
    }
    if (self.timeLabel.text.length > 0) {
        CGSize timeSize = [self.timeLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        self.timeLabel.frame = CGRectFlatMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.contentLabel.frame) + kContentMarginBotom, contentLabelWidth, timeSize.height);
    }
}

@end

@interface QDDynamicTableViewCellViewController ()

@property(nonatomic, copy) NSArray *names;
@property(nonatomic, copy) NSArray *contents;

@end

@implementation QDDynamicTableViewCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.names = @[@"粽子", @"zhoonchen", @"橙黄", @"chantchen", @"茉莉", @"MoLice", @"TQ", @"产品经理", @"谷哥", @"KayoLi", @"飞哥"];
    self.contents = @[@"QMUI Web 是一个专注 Web UI 开发，帮助开发者快速实现特定的一整套设计的框架。", @"框架主要由一个强大的 SASS 方法合集与内置的工作流构成。", @"通过 QMUI Web，开发者可以很轻松地提高 Web UI 开发的效率，同时保持了项目的高可维护性与稳健。如果你需要方便地控制项目的整体样式，或者需要应对频繁的界面变动，那么 QMUI Web 框架将会是你最好的解决方案。", @"通过内置的公共组件和对应的 SASS 配置表，你只需修改简单的配置即可快速实现所需样式的组件。（QMUI SASS 配置表和公共组件如何帮忙开发者快速搭建项目基础 UI？）", @"QMUI Web 包含70个 SASS mixin/function/extend，涉及布局、外观、动画、设备适配、数值计算以及 SASS 原生能力增强等多个方面，可以大幅提升开发效率。", @"QMUI Web 内置的工作流拥有从初始化项目到变更文件的各种自动化处理，包含了模板引擎，图片集中管理与自动压缩，静态资源合并、压缩与变更以及冗余文件清理等功能。", @"推荐配合使用的桌面 App：QMUI Web Desktop", @"感谢你的支持和贡献", @"另外为了方便调试，QMUI Web 带有 Debug 模式", @"通过 GUI 界面处理 QMUI Web 的服务开启/关闭，使框架的使用变得更加便捷", @"推荐使用 Yeoman 脚手架 generator-qmui 安装和配置 QMUI Web。该工具可以帮助你完成 QMUI Web 的所有安装和配置。"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(self.names.count, self.contents.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    return [self.tableView heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell renderWithNameText:[self.names objectAtIndex:indexPath.row] contentText:[self.contents objectAtIndex:indexPath.row]];
    }];
}

- (UITableViewCell *)qmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    QDDynamicTableViewCell *cell = (QDDynamicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QDDynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    QDDynamicTableViewCell *cell = (QDDynamicTableViewCell *)[self qmui_tableView:tableView cellWithIdentifier:cellIdentifier];
    [cell renderWithNameText:[self.names objectAtIndex:indexPath.row] contentText:[self.contents objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView clearsSelection];
}

@end
