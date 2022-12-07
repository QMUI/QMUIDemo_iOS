/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  QMUIBackBarButton.h
//  qmui
//
//  Created by QMUI Team on 20/12/03.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 系统提供了 UINavigationItem.backBarButtonItem 用于指定当前界面的所有下一级界面的返回按钮文字，但只有文字会生效，customView、target-action 事件都会被忽略，所以提供 QMUIBackBarButton 这个组件支持设置一个自定义 view 作为所有下一级界面的返回按钮（常见的场景例如微信聊天界面返回按钮可以显示一个圆形未读数）。
 
 测试要点：
 1. 检查是否可以通过 qmui_backBarButton = nil 恢复为系统返回按钮。
 2. 检查子界面设置 leftBarButtonItem(s) = nil 是否能继续显示 qmui_backBarButton。
 3. 检查是否可以正常与 UINavigationItem.leftItemsSupplementBackButton 搭配使用。
 4. 存在 qmui_backBarButton 并且子界面 leftItemsSupplementBackButton = NO 时，先设置一个 UIBarButtonItem 再设置为 nil，看是否能正确恢复 qmui_backBarButton 的显示。
 5. 不应当影响手势返回的使用。
 6. 假设下一级界面的 UINavigationBar 默认隐藏，当某个时机再次显示时，也应该正常看到 QMUIBackBarButton。
 7. 在 QMUI 里，不应当影响 pop 拦截功能。
 
 对侵入性的说明：
 1. 由于需要保证手势返回正常运转，所以会 hook 返回手势的 delegate 对象的 _gestureRecognizer:shouldReceiveEvent:、gestureRecognizer:shouldReceiveTouch: 方法，可查看本组件的源码确认对业务项目是否有影响。
 2. 当界面同时显示 QMUIBackBarButton 和其他 left UIBarButtonItem 时，对业务而言，相当于 leftBarButtonItems.count > 0 && leftItemsSupplementBackButton == YES，但由于 QMUIBackBarButton 本质上是一个自定义的 UIBarButtonItem，所以对系统而言，此时相当于 leftBarButtonItems.count > 1 && leftItemsSupplementBackButton == NO，也即组件需要修改 leftItemsSupplementBackButton 的逻辑，让业务在设置为 YES 时，对系统而言实际上是 NO，所以在使用 QMUIBackBarButton 后，leftItemsSupplementBackButton 的 getter/setter 逻辑会有变化，请知悉。
 */
@interface UINavigationItem (QMUIBackBarButton)

/**
 设置一个自定义的 view，令当前界面的所有下一级界面都使用这个 view 作为它们的返回按钮。
 */
@property(nullable, nonatomic, strong) __kindof UIView *qmui_backBarButton;
@end


@protocol QMUIBackBarButtonViewControllerSupport <NSObject>

@optional
/**
 默认情况下当界面 A 设置了 qmui_backBarButton，A push 到的所有子界面都会显示自定义的返回按钮，但如果子界面实现了 QMUIBackBarButtonViewControllerSupport 并在 shouldShowBackBarButton: 里返回 NO，则可以控制自己的返回按钮不要显示 qmui_backBarButton。
 默认不实现则视为要显示按钮。
 */
- (BOOL)shouldShowBackBarButton:(__kindof UIView *)button;

@end

NS_ASSUME_NONNULL_END
