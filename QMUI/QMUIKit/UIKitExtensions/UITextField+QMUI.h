/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  UITextField+QMUI.h
//  qmui
//
//  Created by QMUI Team on 2017/3/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (QMUI)

/// UITextView 在输入框开头继续按删除按键，也会触发 shouldChange 的 delegate，但 UITextField 没这个行为，所以提供这个属性，当置为 YES 时，行为与 UITextView 一致，在输入框开头删除也会询问 delegate 并传 range(0, 0) 和空的 text。
/// 默认为 NO。
@property(nonatomic, assign) BOOL qmui_respondsToDeleteActionAtLeading;

/// UITextField 只有 selectedTextRange 属性（在 UITextInput 协议里定义），相对而言没有 NSRange 那么直观，因此这里提供 NSRange 类型的操作方式可以主动设置光标的位置或选中的区域
@property(nonatomic, assign) NSRange qmui_selectedRange;

/// 输入框右边的 clearButton，在 UITextField 初始化后就存在
@property(nullable, nonatomic, weak, readonly) UIButton *qmui_clearButton;

/// 自定义 clearButton 的图片，设置成nil，恢复到系统默认的图片
@property(nullable, nonatomic, strong) UIImage *qmui_clearButtonImage UI_APPEARANCE_SELECTOR;

/**
 *  convert UITextRange to NSRange, for example, [self qmui_convertNSRangeFromUITextRange:self.markedTextRange]
 */
- (NSRange)qmui_convertNSRangeFromUITextRange:(UITextRange *)textRange;

/**
 *  convert NSRange to UITextRange
 *  @return return nil if range is invalidate.
 */
- (nullable UITextRange *)qmui_convertUITextRangeFromNSRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
