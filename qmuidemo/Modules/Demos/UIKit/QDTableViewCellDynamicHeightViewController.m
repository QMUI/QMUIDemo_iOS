//
//  QDTableViewCellDynamicHeightViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 2016/10/11.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDTableViewCellDynamicHeightViewController.h"

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
    
    UIImage *avatarImage = [UIImage qmui_imageWithStrokeColor:[QDCommonUI randomThemeColor] size:CGSizeMake(kAvatarSize, kAvatarSize) lineWidth:3 cornerRadius:6];
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
    
    self.contentLabel.textAlignment = NSTextAlignmentJustified;
    
    [self setNeedsLayout];
}

- (NSAttributedString *)attributeStringWithString:(NSString *)textString lineHeight:(CGFloat)lineHeight {
    if (!textString.qmui_trim && textString.qmui_trim.length <= 0) return nil;
    NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:textString attributes:@{NSParagraphStyleAttributeName:[NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByTruncatingTail]}];
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

@interface QDTableViewCellDynamicHeightViewController ()

@property(nonatomic, copy) NSArray *names;
@property(nonatomic, copy) NSArray *contents;

@end

@implementation QDTableViewCellDynamicHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.names = @[@"张三 的想法", @"李四 的想法", @"张三 的想法", @"李四 的想法", @"张三 的想法", @"李四 的想法", @"张三 的想法", @"李四 的想法", @"张三 的想法", @"李四 的想法", @"张三 的想法"];
    self.contents = @[@"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。", @"丰富的 UI 控件：提供丰富且常用的 UI 控件，使用方便灵活，并且支持自定义控件的样式。", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。", @"iOS UI 解决方案：QMUI iOS 的设计目的是用于辅助快速搭建一个具备基本设计还原效果的 iOS 项目，同时利用自身提供的丰富控件及兼容处理，让开发者能专注于业务需求而无需耗费精力在基础代码的设计上。不管是新项目的创建，或是已有项目的维护，均可使开发效率和项目质量得到大幅度提升。", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。", @"丰富的 UI 控件：提供丰富且常用的 UI 控件，使用方便灵活，并且支持自定义控件的样式。", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。", @"iOS UI 解决方案：QMUI iOS 的设计目的是用于辅助快速搭建一个具备基本设计还原效果的 iOS 项目，同时利用自身提供的丰富控件及兼容处理，让开发者能专注于业务需求而无需耗费精力在基础代码的设计上。不管是新项目的创建，或是已有项目的维护，均可使开发效率和项目质量得到大幅度提升。"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(self.names.count, self.contents.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    return [self.tableView qmui_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
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
    [self.tableView qmui_clearsSelection];
}

@end
