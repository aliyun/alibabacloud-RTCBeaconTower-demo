//
//  NSArray+Safe.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/14.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Safe)

+ (instancetype)safeArrayWithObject:(id)object;
- (id)safeObjectAtIndex:(NSUInteger)index;
- (NSArray *)safeSubarrayWithRange:(NSRange)range;
- (NSUInteger)safeIndexOfObject:(id)anObject;

//通过Plist名取到Plist文件中的数组
+ (NSArray *)arrayNamed:(NSString *)name;
// 数组转成json 字符串
- (NSString *)toJSONStringForArray;

@end

NS_ASSUME_NONNULL_END
