//
//  TableViewBaseViewController.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/12/30.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKHash.h"
#import "BeaconHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewBaseViewController : AliBaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)createUITableView;
- (void)reloadCellWithIdentify:(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
