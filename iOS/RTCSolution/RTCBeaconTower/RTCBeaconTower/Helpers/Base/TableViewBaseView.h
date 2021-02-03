//
//  TableViewBaseView.h
//  AliRTCApp
//
//  Created by 黄浩 on 2020/1/2.
//  Copyright © 2020 AliRTCApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKHash.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewBaseView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)createUITableView;

@end

NS_ASSUME_NONNULL_END
