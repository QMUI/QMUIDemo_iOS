//
//  QDCustomToastContentView.h
//  qmuidemo
//
//  Created by QMUI Team on 2016/12/13.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDCustomToastContentView : UIView

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong, readonly) UILabel *textLabel;
@property(nonatomic, strong, readonly) UILabel *detailTextLabel;

- (void)renderWithImage:(UIImage *)image text:(NSString *)text detailText:(NSString *)detailText;

@end
