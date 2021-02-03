//
//  NSBundle+RTCCommonView.m
//  Pods
//
//  Created by aliyun on 2020/8/6.
//

#import "NSBundle+RTCCommonView.h"
#import "LoadingButton.h"

@implementation NSBundle (RTCCommonView)

+ (instancetype)RTCCommonViewBundle
{
    static NSBundle *bundel = nil;
    if (bundel == nil) {
        NSString *bundlePath = [[NSBundle bundleForClass:[LoadingButton class]] pathForResource:@"RTCCommonView" ofType:@"bundle"];
        bundel = [NSBundle bundleWithPath:bundlePath];
    }
    return bundel;
}

+ (UIImage *)RCV_imageWithName:(NSString *)name type:(NSString *)type
{
    int scale = [[UIScreen mainScreen] scale] <= 2 ? 2 : 3;
    NSString *fullName = [NSString stringWithFormat:@"%@@%dx",name,scale];
    NSString *path =  [[NSBundle RTCCommonViewBundle] pathForResource:fullName ofType:type];
    UIImage *image = [UIImage imageNamed:path];
    //如果不存在 则直接加载name.type
    if (!image) {
        path =  [[NSBundle RTCCommonViewBundle] pathForResource:name ofType:type];
        image = [UIImage imageNamed:path];
    }
    return image;
}

+ (UIImage *)RCV_pngImageWithName:(NSString *)name
{

    UIImage *image =  [NSBundle  RCV_imageWithName:name type:@"png"];
    
    return image;
}

+ (UIStoryboard *)RCV_storyboard
{
    return [UIStoryboard storyboardWithName:@"RTCCommonView"
                                     bundle:[NSBundle bundleForClass:[LoadingButton class]]];
}

+ (NSString *)RCV_pathForResource:(NSString *)name
{
    return [[NSBundle RTCCommonViewBundle] pathForResource:name ofType:nil];
}
@end
