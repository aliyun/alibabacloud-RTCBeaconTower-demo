//
//  NoNetworkView.m
//  BeaconTowner
//
//  Created by 黄浩 on 2020/3/9.
//  Copyright © 2020 BeaconTowner. All rights reserved.
//

#import "NoNetworkView.h"
#import "BeaconHeader.h"

@implementation NoNetworkView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = RGBHex(0x1D212C);
        
        [self addSubview:self.imageV];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.againBtn];
        
        @weakify(self);
        [[self.againBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.againBlock) {
                self.againBlock();
            }
        }];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.mas_equalTo(77);
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(165);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(7);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(28);
    }];
    
    [self.againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(180);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [NSBundle RBT_pngImageWithName:@"nonetwork"];
    }
    return _imageV;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"网络连接失败";
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"请检查你的网络设置或重试";;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.textColor = RGB(192, 192, 192);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (UIButton *)againBtn {
    if (!_againBtn) {
        _againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_againBtn setTitle:@"重试" forState:UIControlStateNormal];
        _againBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _againBtn.backgroundColor = RGB(0, 193, 222);
        _againBtn.layer.cornerRadius = 3;
        _againBtn.clipsToBounds = YES;
    }
    return _againBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
