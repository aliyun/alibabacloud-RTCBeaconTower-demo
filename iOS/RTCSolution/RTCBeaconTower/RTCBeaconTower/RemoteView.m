//
//  RemoteView.m
//  AliChatRoom
//
//  Created by 黄浩 on 2020/2/14.
//  Copyright © 2020 AliChatRoom. All rights reserved.
//

#import "RemoteView.h"
#import "BeaconHeader.h"

#define remoteWidth 120
#define offset_x 10

@implementation RemoteView

- (void)dealloc {
    
    NSLog(@"RemoteView dealloc");
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = RGBHex(0x1D212C);
        _screenView = [[AliRenderView alloc] init];
//        _screenView.backgroundColor = [UIColor blackColor];
        [self addSubview:_screenView];
        
        _screenCanvas = [[AliVideoCanvas alloc] init];
        _screenCanvas.view = _screenView;
        _screenCanvas.renderMode = AliRtcRenderModeAuto;
        _screenCanvas.mirrorMode = AliRtcRenderMirrorModeOnlyFrontCameraPreviewEnabled;
        
        _remoteView = [[AliRenderView alloc] init];
//        _remoteView.backgroundColor = [UIColor blackColor];
        [self addSubview:_remoteView];
        
        
        
        _canvas = [[AliVideoCanvas alloc] init];
        _canvas.view = _remoteView;
        _canvas.renderMode = AliRtcRenderModeAuto;
        _canvas.mirrorMode = AliRtcRenderMirrorModeOnlyFrontCameraPreviewEnabled;
        
        
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = [NSBundle RBT_pngImageWithName:@"video_head_bg"];
        [self addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        UITapGestureRecognizer *tapGrseture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGrseture];
        
        
//        _screenView.backgroundColor = [UIColor redColor];
//        _remoteView.backgroundColor = [UIColor greenColor];
//        _headImageView.backgroundColor = [UIColor yellowColor];
        
    }
    return self;
}

- (void)setUid:(NSString *)uid {
    _uid = uid;
    if (uid.length <= 0) {
        self.headImageView.hidden = YES;
    }
}

- (void)setIsLocal:(BOOL)isLocal {
    _isLocal = isLocal;
    self.nameLabel.hidden = isLocal;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    if (self.tapBlock) {
        self.tapBlock(self.uid,self);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    _screenView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _remoteView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _nameLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
    _headImageView.bounds = CGRectMake(0, 0, 50, 50);
    _headImageView.center = CGPointMake(self.frame.size.width /2.0, self.frame.size.height/2.0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation PositionView

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = RGBHex(0x1D212C);
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [NSBundle RBT_pngImageWithName:@"video_head_bg"];
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _nameLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
    _imageView.bounds = CGRectMake(0, 0, 50, 50);
    _imageView.center = CGPointMake(self.frame.size.width /2.0, self.frame.size.height/2.0);
}
@end
