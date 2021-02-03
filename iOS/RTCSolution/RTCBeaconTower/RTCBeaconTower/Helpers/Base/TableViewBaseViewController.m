//
//  TableViewBaseViewController.m
//  AliRTCApp
//
//  Created by 黄浩 on 2019/12/30.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import "TableViewBaseViewController.h"

@interface TableViewBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TableViewBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
}

//
- (void)createUITableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:tableView];
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


- (void)reloadCellWithIdentify:(NSString *)identify {
    if (!identify) {
        return;
    }
    __block NSInteger section = 0;
    __block NSInteger row = 0;
    __block BOOL find = false;
    
    [self.dataArray enumerateObjectsUsingBlock:^(NSArray *sectionArray, NSUInteger idx, BOOL * _Nonnull stop) {
        section = idx;
        [sectionArray enumerateObjectsUsingBlock:^(CKHash *hash, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if ([identify isEqualToString:hash.midentity]) {
                row = idx1;
                find = YES;
                *stop1 = YES;
                *stop = YES;
            }
        }];
    }];
    if (find) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
