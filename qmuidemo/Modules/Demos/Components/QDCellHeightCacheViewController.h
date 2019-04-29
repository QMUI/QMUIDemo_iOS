//
//  QDCellHeightCacheViewController.h
//  qmuidemo
//
//  Created by MoLice on 2019/J/9.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 对应 QMUICellHeightCache.h 的示例 Demo，只要求 cell 在 sizeThatFits: 里返回当前的大小，不要求 tableView 开启 estimatedRowHeight 效果
@interface QDCellHeightCacheViewController : QDCommonTableViewController

@end

NS_ASSUME_NONNULL_END
