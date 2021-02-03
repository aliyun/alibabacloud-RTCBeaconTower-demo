//
//  BottomControlView.m
//  RtcVideo
//
//  Created by 黄浩 on 2020/2/19.
//  Copyright © 2020 RtcVideo. All rights reserved.
//

#import "BottomControlView.h"
#import "BeaconHeader.h"

@implementation BottomControlView

- (void)dealloc {
    
    NSLog(@"BottomControlView dealloc");
}
- (instancetype)init {
    if (self = [super init]) {
        
        self.muteAudioBtn = [[CustomView alloc] init];
        [self.muteAudioBtn.actionBtn setImage:[NSBundle RBT_pngImageWithName:@"alivc_video_call_mute"] forState:UIControlStateNormal];
        self.muteAudioBtn.nameLabel.text = @"静音";
        self.muteAudioBtn.type = StateTypeDisEnable;
        [self addSubview:self.muteAudioBtn];
        
        self.muteCameraBtn = [[CustomView alloc] init];
        [self.muteCameraBtn.actionBtn setImage:[NSBundle RBT_pngImageWithName:@"alivc_video_call_mute_local_camera"] forState:UIControlStateNormal];
        self.muteCameraBtn.type = StateTypeDisEnable;
        self.muteCameraBtn.nameLabel.text = @"摄像头";
        [self addSubview:self.muteCameraBtn];
        
        
        self.phoneBtn = [[CustomView alloc] init];
        [self.phoneBtn.actionBtn setImage:[NSBundle RBT_pngImageWithName:@"alivc_video_call_handsfree"] forState:UIControlStateNormal];
        self.phoneBtn.nameLabel.text = @"免提";
        [self addSubview:self.phoneBtn];
        
                
        self.hangBtn = [[CustomView alloc] init];
        [self.hangBtn.actionBtn setImage:[NSBundle RBT_pngImageWithName:@"hangup"] forState:UIControlStateNormal];
        self.hangBtn.nameLabel.text = @"取消";
        self.hangBtn.actionBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self addSubview:self.hangBtn];
        
        
        self.cameraTurnBtn = [[CustomView alloc] init];
        [self.cameraTurnBtn.actionBtn setImage:[NSBundle RBT_pngImageWithName:@"alivc_video_call_switch_camera"] forState:UIControlStateNormal];
        self.cameraTurnBtn.nameLabel.text = @"镜头反转";
        [self addSubview:self.cameraTurnBtn];
        
    
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = 64;
    CGFloat height = 100;
    
    CGFloat off_x = self.frame.size.width > 321 ? 40 : 30;
    
    CGFloat off_y = 10;
    
    [self.muteAudioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-(width/2.0 + off_x));
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.muteCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(width/2.0 + off_x);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(width/2.0 + off_x);
        make.top.mas_equalTo(height + off_y);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.hangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(-width/2.0);
        make.top.mas_equalTo(height + off_y);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.cameraTurnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.muteAudioBtn.mas_left);
        make.top.mas_equalTo(height + off_y);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation CustomView

- (instancetype)init {
    if (self = [super init]) {
        
        
        self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionBtn.layer.cornerRadius = 32;
        self.actionBtn.clipsToBounds = YES;
        self.actionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.actionBtn.layer.borderWidth = 1;
        [self addSubview:self.actionBtn];
        
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = kfont(12);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(64);
            make.top.mas_equalTo(0);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.actionBtn.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}

- (void)setType:(StateType)type {
    switch (type) {
        case StateTypeNormal:
        {
            self.actionBtn.backgroundColor = [UIColor clearColor];
            self.actionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            self.actionBtn.enabled = YES;
            
        }
            break;
        case StateTypeSelected:
        {
            self.actionBtn.backgroundColor = RGB(0, 193, 222);
            self.actionBtn.layer.borderColor = [UIColor clearColor].CGColor;
            self.actionBtn.enabled = YES;
        }
            break;
        case StateTypeDisEnable:
        {
            self.actionBtn.backgroundColor = [UIColor clearColor];
            self.actionBtn.layer.borderColor = RGB(157, 158, 162).CGColor;
            self.actionBtn.enabled = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
