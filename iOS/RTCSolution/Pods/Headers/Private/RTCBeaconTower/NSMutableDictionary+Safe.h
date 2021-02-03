//
//  NSMutableDictionary+Safe.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/14.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Safe)

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey;
- (id)safeObjectForKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
