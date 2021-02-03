//
//  NSBundle+RTCCommonView.h
//  Pods
//
//  Created by aliyun on 2020/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (RTCCommonView)

+ (instancetype)RTCCommonViewBundle;

+ (UIImage *)RCV_imageWithName:(NSString *)name type:(NSString *)type;

+ (UIImage *)RCV_pngImageWithName:(NSString *)name;

+ (UIStoryboard *)RCV_storyboard;

+ (NSString *)RCV_pathForResource:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
