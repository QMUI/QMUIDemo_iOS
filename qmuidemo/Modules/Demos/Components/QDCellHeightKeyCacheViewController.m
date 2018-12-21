//
//  QDTableViewCellDynamicHeightViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/03/16.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDCellHeightKeyCacheViewController.h"

static NSString * const kCellIdentifier = @"cell";
const UIEdgeInsets kInsets = {15, 16, 15, 16};
const CGFloat kAvatarSize = 30;
const CGFloat kAvatarMarginRight = 12;
const CGFloat kAvatarMarginBottom = 6;
const CGFloat kContentMarginBotom = 10;

// 这个 cell 只是为了展示每个 cell 高度不一样，这样才有被 cache 的意义，至于这个 cell 里的代码可以不看
@interface QDDynamicHeightTableViewCell : QMUITableViewCell

@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *timeLabel;

- (void)renderWithNameText:(NSString *)nameText contentText:(NSString *)contentText;

@end

@interface QDCellHeightKeyCacheViewController ()

@property(nonatomic, strong) QMUIOrderedDictionary *dataSource;
@end

@implementation QDCellHeightKeyCacheViewController

- (void)didInitializeWithStyle:(UITableViewStyle)style {
    [super didInitializeWithStyle:style];
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"张三 的想法", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"李四 的想法", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"王五 的想法", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"QMUI Team 的想法", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       
                       @"张三 的想法1", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"李四 的想法1", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"王五 的想法1", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"QMUI Team 的想法1", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       
                       @"张三 的想法2", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"李四 的想法2", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"王五 的想法2", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"QMUI Team 的想法2", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       
                       @"张三 的想法3", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"李四 的想法3", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"王五 的想法3", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"QMUI Team 的想法3", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       nil];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStyleDone target:self action:@selector(handleRightBarButtonItem)];
}

- (void)initTableView {
    [super initTableView];
    // 如果需要自动缓存 cell 高度的计算结果，则打开这个属性，然后实现 - [QMUITableViewDelegate qmui_tableView:cacheKeyForRowAtIndexPath:] 方法即可
    // 只要打开这个属性，cell 的 self-sizing 特性也会被开启，所以请保证你的 cell 正确重写了 sizeThatFits: 方法（Auto-Layout 的忽略这句话）
    self.tableView.estimatedRowHeight = 300;// 注意，QMUI 通过配置表的开关 TableViewEstimatedHeightEnabled，默认在所有 iOS 版本打开 estimatedRowHeight（系统是在 iOS 11 之后默认打开），所以图方便的话这一句也可以不用写。
    self.tableView.qmui_cacheCellHeightByKeyAutomatically = YES;
}

- (void)handleRightBarButtonItem {
    // 在 key 没变的情况下，如果要令某个 cell 的高度重新计算，可以参照下方这么写：
    // 如果 key 变化了，则直接调用系统的 reloadRowsAtIndexPaths 就行了，不用手动去 invalidate 缓存的高度
    NSIndexPath *indexPathForSpecificRow = [NSIndexPath indexPathForRow:2 inSection:0];
    id<NSCopying> cacheKeyForSpecificRow = [self.tableView.delegate qmui_tableView:self.tableView cacheKeyForRowAtIndexPath:indexPathForSpecificRow];
    [self.tableView.qmui_currentCellHeightKeyCache invalidateHeightForKey:cacheKeyForSpecificRow];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathForSpecificRow] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - <QMUITableViewDelegate, QMUITableViewDataSource>

- (id<NSCopying>)qmui_tableView:(UITableView *)tableView cacheKeyForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 返回一个用于标记当前 cell 高度的 key，只要 key 不变，高度就不会重新计算，所以建议将有可能影响 cell 高度的数据字段作为 key 的一部分（例如 username、content.md5 等），这样当数据发生变化时，只要触发 cell 的渲染，高度就会自动更新
    NSString *keyName = self.dataSource.allKeys[indexPath.row];
    NSString *contentText = [self.dataSource objectForKey:keyName];
    return @(contentText.length);// 这里简单处理，认为只要长度不同，高度就不同（但实际情况下长度就算相同，高度也有可能不同，要注意）
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QDDynamicHeightTableViewCell *cell = (QDDynamicHeightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[QDDynamicHeightTableViewCell alloc] initForTableView:tableView withReuseIdentifier:kCellIdentifier];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    NSString *keyName = self.dataSource.allKeys[indexPath.row];
    [cell updateCellAppearanceWithIndexPath:indexPath];
    [cell renderWithNameText:[NSString stringWithFormat:@"%@ - %@", @(indexPath.row), keyName] contentText:[self.dataSource objectForKey:keyName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView qmui_clearsSelection];
}

@end

@implementation QDDynamicHeightTableViewCell

- (void)didInitializeWithStyle:(UITableViewCellStyle)style {
    [super didInitializeWithStyle:style];
    
    UIImage *avatarImage = [UIImage qmui_imageWithStrokeColor:[QDCommonUI randomThemeColor] size:CGSizeMake(kAvatarSize, kAvatarSize) lineWidth:3 cornerRadius:6];
    _avatarImageView = [[UIImageView alloc] initWithImage:avatarImage];
    [self.contentView addSubview:self.avatarImageView];
    
    _nameLabel = [[UILabel alloc] qmui_initWithFont:UIFontBoldMake(16) textColor:UIColorGray2];
    [self.contentView addSubview:self.nameLabel];
    
    _contentLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(17) textColor:UIColorGray1];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    _timeLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(13) textColor:UIColorGray];
    [self.contentView addSubview:self.timeLabel];
}

- (void)renderWithNameText:(NSString *)nameText contentText:(NSString *)contentText {
    
    self.nameLabel.text = nameText;
    self.contentLabel.attributedText = [self attributeStringWithString:contentText lineHeight:26];
    self.timeLabel.text = @"昨天 18:24";
    
    self.contentLabel.textAlignment = NSTextAlignmentJustified;
}

- (NSAttributedString *)attributeStringWithString:(NSString *)textString lineHeight:(CGFloat)lineHeight {
    if (textString.qmui_trim.length <= 0) return nil;
    NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:textString attributes:@{NSParagraphStyleAttributeName:[NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByTruncatingTail textAlignment:NSTextAlignmentJustified]}];
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
    NSLog(@"%@ 的 cell 的 sizeThatFits: 被调用（说明这个 cell 的高度重新计算了一遍）", self.nameLabel.text);
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
