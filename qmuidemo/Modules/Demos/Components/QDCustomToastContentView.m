//
//  QDCustomToastContentView.m
//  qmuidemo
//
//  Created by zhoonchen on 2016/12/13.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDCustomToastContentView.h"

static UIEdgeInsets const kInsets = {12, 12, 12, 12};
static CGFloat const kImageViewHeight = 86;
static CGFloat const kImageViewMarginRight = 12;
static CGFloat const kTextLabelMarginBottom = 4;

@implementation QDCustomToastContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    _imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 4;
    [self addSubview:self.imageView];
    
    _textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = UIColorWhite;
    self.textLabel.font = UIFontBoldMake(17);
    self.textLabel.opaque = NO;
    [self addSubview:self.textLabel];
    
    _detailTextLabel = [[UILabel alloc] init];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.textAlignment = NSTextAlignmentJustified;
    self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.detailTextLabel.textColor = UIColorWhite;
    self.detailTextLabel.font = UIFontMake(14);
    self.detailTextLabel.opaque = NO;
    [self addSubview:self.detailTextLabel];
}

- (void)renderWithImage:(UIImage *)image text:(NSString *)text detailText:(NSString *)detailText {
    self.imageView.image = image;
    self.textLabel.text = text;
    self.detailTextLabel.text = detailText;
    [self.imageView sizeToFit];
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat width = fmin(size.width, [QMUIHelper screenSizeFor55Inch].width);
    CGFloat height = kImageViewHeight + UIEdgeInsetsGetVerticalValue(kInsets);
    return CGSizeMake(fmin(size.width, width), fmin(size.height, height));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView qmui_sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(CGFLOAT_MAX, kImageViewHeight)];
    
    CGFloat contentWidth = CGRectGetWidth(self.bounds);
    CGFloat maxContentWidth = contentWidth - UIEdgeInsetsGetHorizontalValue(kInsets);
    CGFloat labelWidth = maxContentWidth - CGRectGetWidth(self.imageView.frame) - kImageViewMarginRight;
    
    self.imageView.frame = CGRectSetXY(self.imageView.frame, kInsets.left, kInsets.top);
    
    self.textLabel.frame = CGRectFlatMake(CGRectGetMaxX(self.imageView.frame) + kImageViewMarginRight, CGRectGetMinY(self.imageView.frame) + 5, labelWidth, CGRectGetHeight(self.textLabel.bounds));
    
    CGFloat detailLimitHeight = CGRectGetHeight(self.bounds) - CGRectGetMaxY(self.textLabel.frame) - kTextLabelMarginBottom - kInsets.bottom;
    CGSize detailSize = [self.detailTextLabel sizeThatFits:CGSizeMake(labelWidth, detailLimitHeight)];
    self.detailTextLabel.frame = CGRectFlatMake(CGRectGetMinX(self.textLabel.frame), CGRectGetMaxY(self.textLabel.frame) + kTextLabelMarginBottom, labelWidth, fmin(detailLimitHeight, detailSize.height));
}

@end
