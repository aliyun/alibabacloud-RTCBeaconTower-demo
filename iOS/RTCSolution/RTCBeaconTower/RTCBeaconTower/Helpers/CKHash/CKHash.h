//
//  CKHash.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/12/30.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CKHash;

#define kCKCellPrepare      @"__preparecell"
#define kCKCellSelected     @"__selectcell"
#define kCKCellGetHeight    @"__getcellheight"

NS_ASSUME_NONNULL_BEGIN


typedef void (^CKCellSelectedBlock)(CKHash *hash, __kindof UIScrollView *view, NSIndexPath *indexPath);
typedef CGFloat (^CKCellGetHeightBlock)(CKHash *hash, __kindof UIScrollView *view, NSIndexPath *indexPath);
typedef __kindof UIView *_Nullable(^CKCellPrepareBlock)(CKHash *hash, __kindof UIScrollView *view, NSIndexPath *indexPath);


@interface CKHash : NSObject

@property (nonatomic, copy) NSString *midentity;


- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id<NSCopying>)key;


@property (nonatomic) void (^cellSelectedBlock)(CKHash *hash, __kindof UIScrollView *view, NSIndexPath *indexPath);
@property (nonatomic) CGFloat (^cellGetHeightBlock)(CKHash *hash, __kindof UIScrollView *view, NSIndexPath *indexPath);
@property (nonatomic) __kindof UIView *(^cellPrepareBlock)(CKHash *hash, __kindof UIScrollView *view, NSIndexPath *indexPath);



- (void)setTableCellSelectedBlock:(void (^)(CKHash *hash, UITableView *tableView, NSIndexPath *indexPath))block;
- (void)setTableCellGetHeightBlock:(CGFloat (^)(CKHash *hash, UITableView *tableView, NSIndexPath *indexPath))block;

- (void)setTableCellPrepareBlock:(UITableViewCell *(^)(CKHash *hash, UITableView *tableView, NSIndexPath *indexPath))block;


@end

NS_ASSUME_NONNULL_END
