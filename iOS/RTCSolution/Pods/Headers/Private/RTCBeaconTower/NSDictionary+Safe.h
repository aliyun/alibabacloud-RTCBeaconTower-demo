//
//  NSDictionary+Safe.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/14.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Safe)

- (id)safeObjectForKey:(NSString *)key;
- (void)safeSetObject:(id)object forKey:(id)key;
- (id)objectForKeyCustom:(id)aKey;
- (id)safeKeyForValue:(id)value;

- (NSString *)toJSONStringForDictionary;

@end

NS_ASSUME_NONNULL_END
