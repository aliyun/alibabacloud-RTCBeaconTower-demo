//
//  AliBaseViewController.m
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/26.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import "AliBaseViewController.h"
#import "BeaconHeader.h"

@interface AliBaseViewController ()


@end

@implementation AliBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(242, 242, 242);
    
    [self.view addSubview:self.navView];
    self.navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //
    //    });
    
    @weakify(self);
//    [[self.navView.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self);
////        [self backAction];
//    }];
    
    [[self.navView.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        
    }];
    
}

- (void)backAction {
    
}

- (CustomNavView *)navView {
    if (!_navView) {
        _navView = [[CustomNavView alloc] init];
        _navView.backgroundColor = [UIColor blueColor];
    }
    return _navView;
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
