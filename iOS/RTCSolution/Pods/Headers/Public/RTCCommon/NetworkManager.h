//
//  NetworkManager.h
//  LectureHall
//
//  Created by Aliyun on 2020/5/22.
//  Copyright © 2020 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

+ (void)GET:(NSString *)url
 parameters:(id _Nullable)parameters
completionHandler:(void (^)(NSString *__nullable errString,id _Nullable result))handle;

+ (void)POST:(NSString *)url
 parameters:(id _Nullable)parameters
completionHandler:(void (^)(NSString *__nullable errString,id _Nullable result))handle;
@end

NS_ASSUME_NONNULL_END
