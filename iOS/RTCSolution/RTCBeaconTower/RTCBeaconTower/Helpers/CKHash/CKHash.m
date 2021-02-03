//
//  CKHash.m
//  AliRTCApp
//
//  Created by 黄浩 on 2019/12/30.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import "CKHash.h"

@interface CKHash()

@property (nonatomic, strong) NSMutableDictionary *mDictionary;
@end

@implementation CKHash

- (instancetype)init {
    if (self = [super init]) {
       _mDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(id)key {
    if (key) {
        return [self.mDictionary objectForKey:key];
    }
    return nil;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    if (object && key) {
        [self.mDictionary setObject:object forKey:key];
    }
}


- (void)setTableCellSelectedBlock:(void (^)(CKHash *hash, UITableView *tableView, NSIndexPath *indexPath))cellSelectedBlock {
    [self setCellSelectedBlock:cellSelectedBlock];
}

- (void)setTableCellGetHeightBlock:(CGFloat (^)(CKHash *hash, UITableView *tableView, NSIndexPath *indexPath))cellGetHeightBlock {
    [self setCellGetHeightBlock:cellGetHeightBlock];
}

- (void)setTableCellPrepareBlock:(UITableViewCell *(^)(CKHash *hash, UITableView *tableView, NSIndexPath *indexPath))cellPrepareBlock {
    [self setCellPrepareBlock:cellPrepareBlock];
}




- (void)setCellSelectedBlock:(CKCellSelectedBlock)cellSelectedBlock {
    [self setObject:[cellSelectedBlock copy] forKey:kCKCellSelected];
}

- (CKCellSelectedBlock)cellSelectedBlock {
    return [self objectForKey:kCKCellSelected];
}

- (void)setCellGetHeightBlock:(CKCellGetHeightBlock)cellGetHeightBlock {
    [self setObject:[cellGetHeightBlock copy] forKey:kCKCellGetHeight];
}

- (CKCellGetHeightBlock)cellGetHeightBlock {
    return [self objectForKey:kCKCellGetHeight];
}

- (void)setCellPrepareBlock:(CKCellPrepareBlock)cellPrepareBlock {
    [self setObject:[cellPrepareBlock copy] forKey:kCKCellPrepare];
}

- (CKCellPrepareBlock)cellPrepareBlock {
    return [self objectForKey:kCKCellPrepare];
}



@end
