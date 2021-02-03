//
//  UIView+Loading.m
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/20.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import "UIView+Loading.h"
#import "BeaconHeader.h"
static NSString *loadingViewKey = @"nameKey"; //


@implementation UIView (Loading)

- (void)setLoadView:(UIActivityIndicatorView *)loadView {
    objc_setAssociatedObject(self, &loadingViewKey, loadView, OBJC_ASSOCIATION_RETAIN);
}

- (UIActivityIndicatorView *)loadView {
    return objc_getAssociatedObject(self, &loadingViewKey);

}

- (void)startLoadingAnimation {
    kMainQueue(^{
        if (!self.loadView) {
            self.loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            self.loadView.bounds = CGRectMake(0, 0, 80, 80);
            [self.loadView setCenter:CGPointMake(self.centerX, self.centerY)];
            [self addSubview:self.loadView];
        }
        [self.loadView startAnimating];
    });
}

- (void)stopLoadingAnimation {
    kMainQueue(^{
        [self.loadView stopAnimating];
    });
}

@end
