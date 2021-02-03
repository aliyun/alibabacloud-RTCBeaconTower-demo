//
//  NSBundle+RTCBeaconTower.m
//  RTCBeaconTower
//
//  Created by Aliyun on 2020/6/30.
//

#import "NSBundle+RTCBeaconTower.h"
#import "MainViewController.h"
#import "NSBundle+RTCCommonView.h"


@implementation NSBundle (RTCBeaconTower)

+ (instancetype)RTC_BeaconTowerBundle
{
    static NSBundle *bundel = nil;
    if (bundel == nil) {
        NSString *bundlePath = [[NSBundle bundleForClass:[MainViewController class]] pathForResource:@"RTCBeaconTower" ofType:@"bundle"];
        bundel = [NSBundle bundleWithPath:bundlePath];
    }
    return bundel;
}

+ (UIImage *)RBT_imageWithName:(NSString *)name type:(NSString *)type
{
    int scale = [[UIScreen mainScreen] scale] <= 2 ? 2 : 3;
    NSString *fullName = [NSString stringWithFormat:@"%@@%dx",name,scale];
    NSString *path =  [[NSBundle RTC_BeaconTowerBundle] pathForResource:fullName ofType:type];
    UIImage *image = [UIImage imageNamed:path];
    //如果不存在 则直接加载name.type
      if (!image) {
          if (scale == 3) {
              fullName = [NSString stringWithFormat:@"%@@%dx",name,2];
              path =  [[NSBundle RTC_BeaconTowerBundle] pathForResource:fullName ofType:type];
              image = [UIImage imageNamed:path];
              if (image) {
                  return image;
              }
          }
          path =  [[NSBundle RTCCommonViewBundle] pathForResource:name ofType:type];
          image = [UIImage imageNamed:path];
          return image;
      }
    return image;
}

+ (UIImage *)RBT_pngImageWithName:(NSString *)name
{

    UIImage *image = [NSBundle  RBT_imageWithName:name type:@"png"];
    //从commonView中查找
    if (!image) {
        image = [NSBundle RCV_pngImageWithName:name];
    }
    
    return image;
}

+ (UIStoryboard *)RBT_storyboard
{
    return [UIStoryboard storyboardWithName:@"RTCBeaconTower"
                                     bundle:[NSBundle bundleForClass:[MainViewController class]]];
}

+ (NSString *)RBT_musicPathForResource:(NSString *)name {
    return [NSBundle RCV_pathForResource:name];
}
@end
