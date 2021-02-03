//
//  AVC_ET_ModuleItemCCell.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/4.
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
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:1 blue:1 alpha:0.05];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = true;
    
    self.raceLabel.layer.cornerRadius = 9;
    self.raceLabel.clipsToBounds = YES;
}

- (void)configWithModule:(RTCModuleDefine *)aDefine{
    
    BOOL isShowRaceIcon;
    #if (SDK_VERSION == SDK_VERSION_CUSTOM)
        isShowRaceIcon = aDefine.type==AVC_ET_ModuleType_VideoShooting;
    #else
        isShowRaceIcon = NO;
    #endif
    
    self.raceLabel.hidden = !isShowRaceIcon;
    self.hotIcon.hidden = !isShowRaceIcon;
    
    self.moduleLabel.text = aDefine.name;
    [self.moduleLabel sizeToFit];
    
    self.moduleImageView.image = aDefine.image;
    self.moduleImageView.contentMode = UIViewContentModeLeft;
}


@end
