//
//  CustomNavView.m
//  AliRTCApp
//
//  Created by 黄浩 on 2020/2/7.
//  Copyright © 2020 AliRTCApp. All rights reserved.
//

#import "CustomNavView.h"
#import "BeaconHeader.h"
@implementation CustomNavView
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.backBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(self.frame.size.width / 2.0 - 75, self.frame.size.height - 40, 150, 30);
    self.backBtn.frame = CGRectMake(0, self.frame.size.height - 40, 50, 30);
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[NSBundle RBT_pngImageWithName:@"back_icon"] forState:UIControlStateNormal];
    }
    return _backBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
