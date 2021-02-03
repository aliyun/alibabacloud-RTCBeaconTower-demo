//
//  RTCModuleItemCCell.m
//  AliyunVideoClient_Entrance
//
//  Created by Aliyun on 2018/4/4.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "RTCModuleItemCCell.h"
#import "RTCModuleDefine.h"

@interface RTCModuleItemCCell ()
@property (weak, nonatomic) IBOutlet UILabel *raceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotIcon;
@end

@implementation RTCModuleItemCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    self.layer.borderColor = [UIColor colorWithRed:196/255.0 green:203/255.0 blue:215/255.0 alpha:0.5].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = true;
    
    self.raceLabel.layer.cornerRadius = 9;
    self.raceLabel.clipsToBounds = YES;
}

- (void)configWithModule:(RTCModuleDefine *)aDefine{
    
    BOOL isShowRaceIcon = NO;
//    #if (SDK_VERSION == SDK_VERSION_CUSTOM)
//        isShowRaceIcon = aDefine.type==RTC_ModuleType_VideoShooting;
//    #else
//        isShowRaceIcon = NO;
//    #endif
    
    self.raceLabel.hidden = !isShowRaceIcon;
    self.hotIcon.hidden = !isShowRaceIcon;
    
    self.moduleLabel.text = aDefine.name;
    [self.moduleLabel sizeToFit];
    
    self.moduleImageView.image = aDefine.image;
    self.moduleImageView.contentMode = UIViewContentModeLeft;
}


@end
