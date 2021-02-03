//
//  RTCMacro.h
//  Pods
//
//  Created by aliyun on 2020/8/11.
//

#ifndef RTCMacro_h
#define RTCMacro_h

#define RTCScreenWidth  [UIScreen mainScreen].bounds.size.width
#define RTCScreenHeight  [UIScreen mainScreen].bounds.size.height

#define RTCSafeTop (([[UIScreen mainScreen] bounds].size.height<812) ? 20 : 44)
#define RTCSafeBottom (([[UIScreen mainScreen] bounds].size.height<812) ? 0 : 34)

#define RTCRGBA(R,G,B,A)  [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:A]

#endif /* RTCMacro_h */
