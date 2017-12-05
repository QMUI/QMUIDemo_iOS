//
//  QDColorViewController.m
//  qmui
//
//  Created by MoLice on 14-7-13.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDColorViewController.h"

#define spaceBetweenIconAndCircle 30    // 图标（如箭头、加号）和圆之间的距离

@interface QDColorViewController ()

@end

@implementation QDColorViewController

#pragma mark - 生命周期函数

- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat topInset = 32;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), topInset)];
}

#pragma mark - TableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 300;
    }
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QDColorTableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [[QDColorCellThatGenerateFromHex alloc] init];
            break;
        case 1:
            cell = [[QDColorCellThatGetColorInfo alloc] init];
            break;
        case 2:
            cell = [[QDColorCellThatResetAlpha alloc] init];
            break;
        case 3:
            cell = [[QDColorCellThatInverseColor alloc] init];
            break;
        case 4:
            cell = [[QDColorCellThatNeutralizeColors alloc] init];
            break;
        case 5:
            cell = [[QDColorCellThatBlendColors alloc] init];
            break;
        case 6:
            cell = [[QDColorCellThatAdjustAlphaAndBlend alloc] init];
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentViewInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    return cell;
}



@end


@implementation QDColorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabelMarginBottom = 12;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.titleLabel = [[QMUILabel alloc] init];
    self.titleLabel.font = UIFontMake(14);
    [self.titleLabel qmui_calculateHeightAfterSetAppearance];
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(self.contentViewInsets.left, 0, CGRectGetWidth(self.contentView.bounds) - self.contentViewInsets.left - self.contentViewInsets.right, CGRectGetHeight(self.titleLabel.bounds));
}

- (void)setContentViewInsets:(UIEdgeInsets)contentViewInsets {
    _contentViewInsets = contentViewInsets;
    [self setNeedsLayout];
}

// 生成一个圆形的view
- (UIView *)generateCircleWithColor:(UIColor *)color {
    CGFloat diameter = 44;
    
    UIView *circle = [[UIView alloc] init];
    circle.backgroundColor = color;
    circle.frame = CGRectMake(0, 0, diameter, diameter);
    circle.layer.cornerRadius = diameter / 2;
    
    return circle;
}

// 生成一个向右的箭头imageView
- (UIImageView *)generateArrowIcon {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:UIImageMake(@"arrowRight")];
    return imageView;
}

- (UIImageView *)generatePlusIcon {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:UIImageMake(@"plus")];
    return imageView;
}

@end

// 通过HEX创建
@implementation QDColorCellThatGenerateFromHex {
    UIView *_circle;
    QMUILabel *_label;
}

- (void)initSubviews {
    [super initSubviews];
    self.titleLabel.text = @"通过HEX创建";

    UIColor *resultColor = [UIColor qmui_colorWithHexString:@"#cddc39"]; // 关键方法
    
    _circle = [self generateCircleWithColor:resultColor];
    [self.contentView addSubview:_circle];
    
    _label = [[QMUILabel alloc] init];
    _label.text = @"[UIColor qmui_colorWithHexString:@\"#cddc39\"]";
    _label.font = UIFontMake(12);
    [_label sizeToFit];
    _label.textColor = UIColorGray7;
    [self.contentView addSubview:_label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _circle.frame = CGRectSetXY(_circle.frame, self.contentViewInsets.left, CGRectGetMaxY(self.titleLabel.frame) + self.titleLabelMarginBottom);
    _label.frame = CGRectSetXY(_label.frame, self.contentViewInsets.left, CGRectGetMaxY(_circle.frame) + 5);
}

@end

// 获取颜色信息
@implementation QDColorCellThatGetColorInfo {
    QMUIGridView *_gridView;
    UIView *_circle;
    
    NSMutableArray *_labels;
}

- (void)initSubviews {
    [super initSubviews];
    self.titleLabel.text = @"获取颜色信息";
    
    _labels = [NSMutableArray array];
    
    UIColor *rawColor = [[UIColor qmui_colorWithHexString:@"#e69832"] colorWithAlphaComponent:0.75];
    // 关键方法
    CGFloat alpha = [rawColor qmui_alpha];
    CGFloat red = [rawColor qmui_red];
    CGFloat green = [rawColor qmui_green];
    CGFloat blue = [rawColor qmui_blue];
    CGFloat hue = [rawColor qmui_hue];
    CGFloat saturation = [rawColor qmui_saturation];
    CGFloat brightness = [rawColor qmui_brightness];
    NSString *hex = [rawColor qmui_hexString];
    BOOL isDark = [rawColor qmui_colorIsDark];
    
    _circle = [self generateCircleWithColor:rawColor];
    [self.contentView addSubview:_circle];
    
    _gridView = [[QMUIGridView alloc] initWithColumn:4 rowHeight:60];
    NSArray *infos = @[
                       @{@"title" : @"ALPHA", @"content" : [NSString stringWithFormat:@"%.3f", alpha]},
                       @{@"title" : @"RED", @"content" : [NSString stringWithFormat:@"%.3f", red]},
                       @{@"title" : @"GREEN", @"content" : [NSString stringWithFormat:@"%.3f", green]},
                       @{@"title" : @"BLUE", @"content" : [NSString stringWithFormat:@"%.3f", blue]},
                       @{@"title" : @"色相", @"content" : [NSString stringWithFormat:@"%.3f", hue]},
                       @{@"title" : @"饱和度", @"content" : [NSString stringWithFormat:@"%.3f", saturation]},
                       @{@"title" : @"亮度", @"content" : [NSString stringWithFormat:@"%.3f", brightness]},
                       @{@"title" : @"HEX", @"content" : hex},
                       @{@"title" : @"是否是深色系", @"content" : isDark ? @"YES" : @"NO"},
                    ];
    for (NSDictionary *dict in infos) {
        UIView *wrapperView = [[UIView alloc] init];
        
        QMUILabel *titleLabel = [[QMUILabel alloc] init];
        titleLabel.text = dict[@"title"];
        titleLabel.font = UIFontMake(12);
        titleLabel.textColor = UIColorGray7;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel sizeToFit];
        [_labels addObject:titleLabel];
        [wrapperView addSubview:titleLabel];
        
        QMUILabel *contentLabel = [[QMUILabel alloc] init];
        contentLabel.text = dict[@"content"];
        contentLabel.font = UIFontMake(12);
        contentLabel.textColor = UIColorGray3;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [contentLabel sizeToFit];
        contentLabel.frame = CGRectSetY(contentLabel.frame, CGRectGetMaxY(titleLabel.frame) + 3);
        [_labels addObject:contentLabel];
        [wrapperView addSubview:contentLabel];
        
        [_gridView addSubview:wrapperView];
    }
    [self.contentView addSubview:_gridView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _circle.frame = CGRectSetXY(_circle.frame, self.contentViewInsets.left, CGRectGetMaxY(self.titleLabel.frame) + self.titleLabelMarginBottom);

    CGSize gridViewSize = [_gridView sizeThatFits:CGSizeMake(CGRectGetWidth(self.contentView.bounds) - self.contentViewInsets.left - self.contentViewInsets.right, CGFLOAT_MAX)];
    _gridView.frame = CGRectMake(self.contentViewInsets.left, CGRectGetMaxY(_circle.frame) + 25, gridViewSize.width, gridViewSize.height);
    for (UILabel *label in _labels) {
        label.frame = CGRectSetWidth(label.frame, gridViewSize.width / 4);
    }
}

@end

// 去除alpha通道
@implementation QDColorCellThatResetAlpha {
    UIView *_circle1;
    UIView *_circle2;
    UIView *_arrow;
    QMUILabel *_label1;
    QMUILabel *_label2;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.titleLabel.text = @"去除alpha通道";
    
    UIColor *rawColor = [UIColorMakeWithHex(@"#e91e63") colorWithAlphaComponent:0.6];
    UIColor *resultColor = rawColor.qmui_colorWithoutAlpha;  // 关键方法
    
    _circle1 = [self generateCircleWithColor:rawColor];
    [self.contentView addSubview:_circle1];
    
    _arrow = [self generateArrowIcon];
    [self.contentView addSubview:_arrow];
    
    _circle2 = [self generateCircleWithColor:resultColor];
    [self.contentView addSubview:_circle2];
    
    _label1 = [[QMUILabel alloc] init];
    _label1.text = @"0.5 ALPHA";
    _label1.font = UIFontMake(12);
    _label1.textColor = UIColorGray7;
    [_label1 sizeToFit];
    [self.contentView addSubview:_label1];
    
    _label2 = [[QMUILabel alloc] init];
    _label2.text = @"1.0 ALPHA";
    [_label2 qmui_setTheSameAppearanceAsLabel:_label1];
    [_label2 sizeToFit];
    [self.contentView addSubview:_label2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _circle1.frame = CGRectSetXY(_circle1.frame, self.contentViewInsets.left, CGRectGetMaxY(self.titleLabel.frame) + self.titleLabelMarginBottom);
    _arrow.frame = CGRectSetXY(_arrow.frame, CGRectGetMaxX(_circle1.frame) + spaceBetweenIconAndCircle, CGRectGetMaxY(_circle1.frame) - CGRectGetMidY(_circle1.bounds) - CGRectGetMidY(_arrow.bounds));
    _circle2.frame = CGRectSetXY(_circle2.frame, CGRectGetMaxX(_arrow.frame) + spaceBetweenIconAndCircle, CGRectGetMinY(_circle1.frame));
    _label1.frame = CGRectSetXY(_label1.frame, CGRectGetMidX(_circle1.frame) - CGRectGetMidX(_label1.bounds), CGRectGetMaxY(_circle1.frame) + 6);
    _label2.frame = CGRectSetXY(_label1.frame, CGRectGetMidX(_circle2.frame) - CGRectGetMidX(_label2.bounds), CGRectGetMaxY(_circle2.frame) + 6);
}

@end

// 计算反色
@implementation QDColorCellThatInverseColor {
    UIView *_circle1;
    UIView *_circle2;
    UIView *_arrow;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.titleLabel.text = @"计算反色";
    
    UIColor *rawColor = UIColorMakeWithHex(@"#ff9800");
    UIColor *resultColor = [rawColor qmui_inverseColor]; // 关键方法
    
    _circle1 = [self generateCircleWithColor:rawColor];
    [self.contentView addSubview:_circle1];
    
    _arrow = [self generateArrowIcon];
    [self.contentView addSubview:_arrow];
    
    _circle2 = [self generateCircleWithColor:resultColor];
    [self.contentView addSubview:_circle2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _circle1.frame = CGRectSetXY(_circle1.frame, self.contentViewInsets.left, CGRectGetMaxY(self.titleLabel.frame) + self.titleLabelMarginBottom);
    _arrow.frame = CGRectSetXY(_arrow.frame, CGRectGetMaxX(_circle1.frame) + spaceBetweenIconAndCircle, CGRectGetMinYVerticallyCenter(_circle1.frame, _arrow.frame));
    _circle2.frame = CGRectSetXY(_circle2.frame, CGRectGetMaxX(_arrow.frame) + spaceBetweenIconAndCircle, CGRectGetMinY(_circle1.frame));
}

@end

// 计算中间色
@implementation QDColorCellThatNeutralizeColors {
    UIView *_circle1;
    UIView *_circle2;
    UIView *_circle3;
    UIView *_plus;
    UIView *_arrow;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.titleLabel.text = @"计算过渡色";
    
    UIColor *rawColor1 = UIColorMakeWithHex(@"#b1dcff");
    UIColor *rawColor2 = UIColorMakeWithHex(@"#0e4068");
    UIColor *resultColor = [UIColor qmui_colorFromColor:rawColor1 toColor:rawColor2 progress:0.5]; // 关键方法
    
    _circle1 = [self generateCircleWithColor:rawColor1];
    [self.contentView addSubview:_circle1];
    
    _plus = [self generatePlusIcon];
    [self.contentView addSubview:_plus];
    
    _circle2 = [self generateCircleWithColor:rawColor2];
    [self.contentView addSubview:_circle2];
    
    _arrow = [self generateArrowIcon];
    [self.contentView addSubview:_arrow];
    
    _circle3 = [self generateCircleWithColor:resultColor];
    [self.contentView addSubview:_circle3];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _circle1.frame = CGRectSetXY(_circle1.frame, self.contentViewInsets.left, CGRectGetMaxY(self.titleLabel.frame) + self.titleLabelMarginBottom);
    _plus.frame = CGRectSetXY(_plus.frame, CGRectGetMaxX(_circle1.frame) + spaceBetweenIconAndCircle, CGRectGetMinYVerticallyCenter(_circle1.frame, _plus.frame));
    _circle2.frame = CGRectSetXY(_circle2.frame, CGRectGetMaxX(_plus.frame) + spaceBetweenIconAndCircle, CGRectGetMinY(_circle1.frame));
    _arrow.frame = CGRectSetXY(_arrow.frame, CGRectGetMaxX(_circle2.frame) + spaceBetweenIconAndCircle, CGRectGetMinYVerticallyCenter(_circle2.frame, _arrow.frame));
    _circle3.frame = CGRectSetXY(_circle3.frame, CGRectGetMaxX(_arrow.frame) + spaceBetweenIconAndCircle, CGRectGetMinY(_circle2.frame));
    
}
@end

// 计算叠加色（两个颜色里至少要有一个半透明色）
@implementation QDColorCellThatBlendColors {
    UIView *_circle1;
    UIView *_circle2;
    UIView *_circle3;
    UIView *_arrow;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.titleLabel.text = @"计算叠加色";
    
    UIColor *rawColor1 = UIColorMakeWithHex(@"#68a0ce");
    UIColor *rawColor2 = [UIColorMakeWithHex(@"#e91e63") colorWithAlphaComponent:0.5];
    UIColor *resultColor = [UIColor qmui_colorWithBackendColor:rawColor1 frontColor:rawColor2];  // 关键方法
    
    _circle1 = [self generateCircleWithColor:rawColor1];
    [self.contentView addSubview:_circle1];
    
    _circle2 = [self generateCircleWithColor:rawColor2];
    [self.contentView addSubview:_circle2];
    
    _arrow = [self generateArrowIcon];
    [self.contentView addSubview:_arrow];
    
    _circle3 = [self generateCircleWithColor:resultColor];
    [self.contentView addSubview:_circle3];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _circle1.frame = CGRectSetXY(_circle1.frame, self.contentViewInsets.left, CGRectGetMaxY(self.titleLabel.frame) + self.titleLabelMarginBottom);
    _circle2.frame = CGRectSetXY(_circle2.frame, CGRectGetMidX(_circle1.frame), CGRectGetMinY(_circle1.frame));
    _arrow.frame = CGRectSetXY(_arrow.frame, CGRectGetMaxX(_circle2.frame) + spaceBetweenIconAndCircle, CGRectGetMinYVerticallyCenter(_circle2.frame, _arrow.frame));
    _circle3.frame = CGRectSetXY(_circle3.frame, CGRectGetMaxX(_arrow.frame) + spaceBetweenIconAndCircle, CGRectGetMinY(_circle2.frame));
}
@end

@implementation QDColorCellThatAdjustAlphaAndBlend {
    UIView *_circle1;
    UIView *_circle2;
    UIView *_circle3;
    UIView *_arrow;
    UIView *_plus1;
    UIView *_plus2;
    QMUILabel *_label;
}

- (void)initSubviews {
    [super initSubviews];

    self.titleLabel.text = @"先更改alpha，再与另一个颜色叠加";
    
    UIColor *rawColor1 = UIColorMakeWithHex(@"#795548");
    UIColor *rawColor2 = UIColorMakeWithHex(@"#cddc39");
    UIColor *resultColor = [rawColor1 qmui_colorWithAlpha:0.5 backgroundColor:rawColor2];    // 关键方法
    
    _circle1 = [self generateCircleWithColor:rawColor1];
    [self.contentView addSubview:_circle1];
    
    _plus1 = [self generatePlusIcon];
    [self.contentView addSubview:_plus1];
    
    _label = [[QMUILabel alloc] init];
    _label.text = @"0.5 ALPHA";
    _label.textColor = UIColorGray7;;
    _label.font = UIFontMake(12);
    [_label sizeToFit];

    [self.contentView addSubview:_label];
    
    _plus2 = [self generatePlusIcon];
    [self.contentView addSubview:_plus2];
    
    _circle2 = [self generateCircleWithColor:rawColor2];
    [self.contentView addSubview:_circle2];
    
    _arrow = [self generateArrowIcon];
    [self.contentView addSubview:_arrow];
    
    _circle3 = [self generateCircleWithColor:resultColor];
    [self.contentView addSubview:_circle3];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat spacingBetweenIconAndCircle = 8;
    
    _circle1.frame = CGRectSetXY(_circle1.frame, self.contentViewInsets.left, CGRectGetMaxY(self.titleLabel.frame) + self.titleLabelMarginBottom);
    _plus1.frame = CGRectSetXY(_plus1.frame, CGRectGetMaxX(_circle1.frame) + spacingBetweenIconAndCircle, CGRectGetMinYVerticallyCenter(_circle1.frame, _plus1.frame));
    _label.frame = CGRectSetXY(_label.frame, CGRectGetMaxX(_plus1.frame) + spacingBetweenIconAndCircle, CGRectGetMinYVerticallyCenter(_plus1.frame, _label.frame));
    _plus2.frame = CGRectSetXY(_plus1.frame, CGRectGetMaxX(_label.frame) + spacingBetweenIconAndCircle, CGRectGetMinY(_plus1.frame));
    _circle2.frame = CGRectSetXY(_circle2.frame, CGRectGetMaxX(_plus2.frame) + spacingBetweenIconAndCircle, CGRectGetMinY(_circle1.frame));
    _arrow.frame = CGRectSetXY(_arrow.frame, CGRectGetMaxX(_circle2.frame) + spacingBetweenIconAndCircle, CGRectGetMinYVerticallyCenter(_circle2.frame, _arrow.frame));
    _circle3.frame = CGRectSetXY(_circle3.frame, CGRectGetMaxX(_arrow.frame) + spacingBetweenIconAndCircle, CGRectGetMinY(_circle2.frame));
}

@end
