//
//  NSDictionary+Safe.m
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/14.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

- (id)safeObjectForKey:(NSString *)key {
    if (key == nil || [self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    id object = [self objectForKey:key];
    if (object==nil || object == [NSNull null]) {
        return @"";
    }
    return object;
}


- (void)safeSetObject:(id)object forKey:(id)key {
    if ([key isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        [self setValue:@"" forKey:key];
    }else{
        [self setValue:object forKey:key];
    }
}

- (id)objectForKeyCustom:(id)aKey {
    id object   = nil;
    
    // 检查是否字典对象
    if (![self isKindOfClass:[NSDictionary class]]) {
        return object;
    }
    
    // 保证key必须为字符串
    if (aKey && [aKey isKindOfClass:[NSString class]]) {
        object  = [self objectForKeyCustom:aKey];
    }
    
    return object;
}

- (id)safeKeyForValue:(id)value {
    for (id key in self.allKeys) {
        if ([value isEqual:[self objectForKey:key]]) {
            return key;
        }
    }
    return nil;
}

- (NSString *)toJSONStringForDictionary
{
    NSData *paramsJSONData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:paramsJSONData encoding:NSUTF8StringEncoding];
}

@end
