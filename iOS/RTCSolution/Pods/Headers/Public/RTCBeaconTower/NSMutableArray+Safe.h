//
//  NSMutableArray+Safe.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/14.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Safe)

- (void)safeAddObject:(id)object;
- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index;
- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs;
- (void)safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)safeRemoveObjectsInRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
