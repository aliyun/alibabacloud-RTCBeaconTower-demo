//
//  TableViewBaseView.m
//  AliRTCApp
//
//  Created by 黄浩 on 2020/1/2.
//  Copyright © 2020 AliRTCApp. All rights reserved.
//

#import "TableViewBaseView.h"
#import "BeaconHeader.h"


@interface TableViewBaseView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TableViewBaseView

- (instancetype)init {
    if (self = [super init]) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)createUITableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:tableView];
//    if (@available(iOS 11.0, *)) {
//       tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    self.tableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CKHash *hash = self.dataArray[indexPath.section][indexPath.row];
    if (hash.cellPrepareBlock) {
        return hash.cellPrepareBlock(hash,tableView,indexPath);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKHash *hash = self.dataArray[indexPath.section][indexPath.row];
    if (hash.cellGetHeightBlock) {
        return hash.cellGetHeightBlock(hash,tableView,indexPath);
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CKHash *hash = self.dataArray[indexPath.section][indexPath.row];
    if (hash.cellSelectedBlock) {
        hash.cellSelectedBlock(hash, tableView, indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *head = [[UIView alloc] init];
    head.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.1);
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *foot = [[UIView alloc] init];
    foot.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    return foot;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
