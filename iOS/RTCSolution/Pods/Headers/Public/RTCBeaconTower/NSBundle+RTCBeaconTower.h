//
//  NSBundle+RTCBeaconTower
//  RTCBeaconTower
//
//  Created by Aliyun on 2020/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (RTCBeaconTower)

+ (instancetype)RTC_BeaconTowerBundle;

+ (UIImage *)RBT_imageWithName:(NSString *)name type:(NSString *)type;

+ (UIImage *)RBT_pngImageWithName:(NSString *)name;
 
+ (UIStoryboard *)RBT_storyboard;

+ (NSString *)RBT_musicPathForResource:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
