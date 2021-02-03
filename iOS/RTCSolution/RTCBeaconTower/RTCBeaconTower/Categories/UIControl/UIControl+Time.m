//
//  UIControl+Time.m
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/27.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import "UIControl+Time.h"
#import "BeaconHeader.h"

@interface UIControl()

@property (nonatomic, assign) NSTimeInterval ali_acceptEventTime;

@end


@implementation UIControl (Time)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval )filterTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setFilterTime:(NSTimeInterval)filterTime{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(filterTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSTimeInterval )ali_acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setAli_acceptEventTime:(NSTimeInterval)ali_acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(ali_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    //获取着两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method myMethod = class_getInstanceMethod(self, @selector(cjr_sendAction:to:forEvent:));
    SEL mySEL = @selector(cjr_sendAction:to:forEvent:);
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    //如果方法已经存在了
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
    }
}

- (void)cjr_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (NSDate.date.timeIntervalSince1970 - self.ali_acceptEventTime < self.filterTime) {
        return;
    }
    if (self.filterTime > 0) {
        self.ali_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    [self cjr_sendAction:action to:target forEvent:event];
}

@end
