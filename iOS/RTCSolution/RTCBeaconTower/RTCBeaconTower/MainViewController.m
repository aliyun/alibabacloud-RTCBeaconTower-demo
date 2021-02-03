//
//  ViewController.m
//  RtcVideo
//
//  Created by 黄浩 on 2020/2/18.
//  Copyright © 2020 RtcVideo. All rights reserved.
//

#import "MainViewController.h"
#import "ChatRoomViewController.h"
#import "NoNetworkView.h" 
#import "BeaconHeader.h"
#import "UIImage+Color.h"
#define disEnableColor RGB(0, 193, 222)
#define enableColor  RGB(0, 193, 222)

@interface MainViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *nameTextfield;
@property (nonatomic, strong) UITextField *channeltextfield;
@property (nonatomic, strong) UIButton *joinMeetingBtn;
@property (nonatomic, strong) UIButton *createMeetingBtn;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIImageView *headImageV;
@property (nonatomic, strong) UIImageView *headbgImageV;
@property (nonatomic, strong) UIImageView *topbgImageV;
@property (nonatomic, strong) UIImageView *errorImageV;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIView *joinBtnLayer;
@property (nonatomic, strong) UIView *createBtnLayer;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = RGBHex(0x1D212C);
    [self setupUI];
    [self manage];
    [self createTapGesture];
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait;
}


- (BOOL)number:(NSString *)string {
    NSString *reges = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reges];
    BOOL result = [predicate evaluateWithObject:string];
    return result;
}

- (void)manage {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"nameid"];
    if (name.length) {
        self.nameTextfield.text = name;
    }
    @weakify(self);
    [[[self.nameTextfield rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 0 && !(self.channeltextfield.text.length > 0));
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.createMeetingBtn.backgroundColor = [x boolValue] ? enableColor : disEnableColor;
        self.createMeetingBtn.enabled = [x boolValue];
        self.createBtnLayer.hidden = [x boolValue];
    }];
    
    
    [[[self.channeltextfield rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        return @(value.length > 0 && value.length <= 12 && [self number:value]);
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.joinMeetingBtn.backgroundColor = [x boolValue] ? enableColor : disEnableColor;
        self.joinMeetingBtn.enabled = [x boolValue];
        self.joinBtnLayer.hidden = [x boolValue];
        
        if (self.channeltextfield.text.length) {
            self.errorLabel.hidden = self.errorImageV.hidden = [x boolValue];
            if ([x boolValue]) {
                self.channeltextfield.layer.borderWidth = 1;
                self.channeltextfield.layer.borderColor = enableColor.CGColor;
            } else {
                self.channeltextfield.layer.borderWidth = 1;
                self.channeltextfield.layer.borderColor = RGBHex(0xFC4347).CGColor;
            }
            
            self.createMeetingBtn.backgroundColor = disEnableColor;
            self.createMeetingBtn.enabled = NO;
            self.createBtnLayer.hidden = NO;
        } else {
            self.errorLabel.hidden = self.errorImageV.hidden = YES;
            self.channeltextfield.layer.borderWidth = 1;
            self.channeltextfield.layer.borderColor = [UIColor clearColor].CGColor;
                    
            self.createMeetingBtn.backgroundColor = self.nameTextfield.text.length ? enableColor : disEnableColor;
            self.createMeetingBtn.enabled = self.nameTextfield.text.length;
            self.createBtnLayer.hidden = self.createMeetingBtn.enabled;
        }
        
    }];
    
    [[self.joinMeetingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.nameTextfield.text.length <= 0) {
            [Toast showToastWithMessage:@"请输入用户名" type:AliToastTypeNormal];
            return ;
        }
        
        BOOL network = [Tool haveNetwork];
        if (!network) {
            NoNetworkView *noNetView = [[NoNetworkView alloc] init];
            [self.view addSubview:noNetView];
            @weakify(noNetView);
            noNetView.againBlock = ^{
                @strongify(self);
                @strongify(noNetView);
                [noNetView removeFromSuperview];
                [self loginRequestName:self.nameTextfield.text channelName:self.channeltextfield.text isCreate:NO];
            };
            [noNetView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.equalTo(self.titleLabel.mas_bottom);
            }];
            return ;
        }
        [self loginRequestName:self.nameTextfield.text channelName:self.channeltextfield.text isCreate:NO];
    }];
    
    
    [[self.createMeetingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        BOOL network = [Tool haveNetwork];
        if (!network) {
            NoNetworkView *noNetView = [[NoNetworkView alloc] init];
            @weakify(noNetView);
            [self.view addSubview:noNetView];
            noNetView.againBlock = ^{
                @strongify(self);
                @strongify(noNetView);
                [noNetView removeFromSuperview];
                [self createRequest];
            };
            [noNetView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.equalTo(self.titleLabel.mas_bottom);
            }];
            return ;
        }
        [self createRequest];
    }];
}

//创建频道请求
- (void)createRequest {
    int num = (arc4random() % 1000000);
    NSString *channelId = [NSString stringWithFormat:@"%.6d", num];
    [self loginRequestName:self.nameTextfield.text channelName:channelId isCreate:YES];
    
}

//登陆请求
- (void)loginRequestName:(NSString *)name channelName:(NSString *)channelName isCreate:(BOOL)isCreate{
    ChatRoomViewController *chatRoom = [[ChatRoomViewController alloc] init];
    chatRoom.channelNumber = channelName;
    chatRoom.userName = name; 
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatRoom];
    nav.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:NO completion:^{
        if (isCreate) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = channelName;
            [Toast showToastWithMessage:[NSString stringWithFormat:@"会议码:%@已被复制",channelName]];
        }
    }];
    
        
}

- (void)setupUI {
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageWithColor:[[UIColor whiteColor]colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[NSBundle RBT_pngImageWithName:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.topbgImageV];
    [self.view addSubview:self.headbgImageV];
    [self.view addSubview:self.headImageV];
    [self.view addSubview:self.nameTextfield];
    [self.view addSubview:self.channeltextfield];
    [self.view addSubview:self.joinMeetingBtn];
    [self.view addSubview:self.joinBtnLayer];
    [self.view addSubview:self.createMeetingBtn];
    [self.view addSubview:self.createBtnLayer];
    [self.view addSubview:self.describeLabel];

    [self.view addSubview:self.errorImageV];
    [self.view addSubview:self.errorLabel];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.topbgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(50);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(160);
    }];
    
    [self.headbgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(302);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.topbgImageV.mas_centerY).offset(0);
    }];
    
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(90);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.topbgImageV.mas_centerY);
    }];
    
    [self.nameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headbgImageV.mas_bottom).offset(-40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
        make.height.mas_equalTo(48);
    }];
    
    [self.channeltextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.top.equalTo(self.nameTextfield.mas_bottom).offset(16);
        make.right.mas_equalTo(-32);
        make.height.mas_equalTo(48);
    }];
    
    [self.joinMeetingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.channeltextfield.mas_right).offset(-80);
        make.top.equalTo(self.channeltextfield.mas_top).offset(0.5);
        make.right.equalTo(self.channeltextfield.mas_right);
        make.height.mas_equalTo(47);
    }];
    
    [self.joinBtnLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.joinMeetingBtn);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
    }];
    
    [self.errorImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.equalTo(self.channeltextfield.mas_bottom).offset(12);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.errorImageV.mas_right).offset(12);
        make.top.equalTo(self.errorImageV.mas_top);
        make.height.mas_equalTo(24);
    }];
    
    [self.createMeetingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.errorImageV.mas_bottom).offset(10);
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
        make.height.mas_equalTo(48);
    }];
    
    [self.createBtnLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.createMeetingBtn);
    }];
}

- (void)createTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
    [self.channeltextfield resignFirstResponder];
    [self.nameTextfield resignFirstResponder];
}
- (BOOL)judgeName {
    if (self.nameTextfield.text.length > 0) {
        return YES;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请填写用户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    return NO;
}

- (UITextField *)nameTextfield {
    if (!_nameTextfield) {
        _nameTextfield = [[UITextField alloc] init];
        _nameTextfield.borderStyle = UITextBorderStyleRoundedRect;
        _nameTextfield.backgroundColor = RGB(48, 51, 58);
        _nameTextfield.textColor = [UIColor whiteColor];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName:RGBHex(0x888888),NSFontAttributeName : kfont(15)}];
        _nameTextfield.attributedPlaceholder = attrString;
    }
    return _nameTextfield;
}

- (UITextField *)channeltextfield {
    if (!_channeltextfield) {
        _channeltextfield = [[UITextField alloc] init];
        _channeltextfield.clearButtonMode = UITextFieldViewModeAlways;
        _channeltextfield.borderStyle = UITextBorderStyleRoundedRect;
        _channeltextfield.keyboardType  = UIKeyboardTypeNumberPad;
        _channeltextfield.returnKeyType = UIReturnKeyGo;
        _channeltextfield.backgroundColor = RGB(48, 51, 58);
        _channeltextfield.layer.cornerRadius = 3;
        _channeltextfield.clipsToBounds = YES;
        _channeltextfield.textColor = [UIColor whiteColor];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入会议码" attributes:@{NSForegroundColorAttributeName:RGBHex(0x888888),NSFontAttributeName : kfont(15)}];
        _channeltextfield.attributedPlaceholder = attrString;
    }
    return _channeltextfield;
}

- (UIButton *)joinMeetingBtn {
    if (!_joinMeetingBtn) {
        _joinMeetingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinMeetingBtn setTitle:@"加入会议" forState:UIControlStateNormal];
        _joinMeetingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _joinMeetingBtn.backgroundColor = disEnableColor;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 80, 47) byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 80, 47);
        maskLayer.path = maskPath.CGPath;
        _joinMeetingBtn.layer.mask = maskLayer;
    }
    return _joinMeetingBtn;
}

- (UIButton *)createMeetingBtn {
    if (!_createMeetingBtn) {
        _createMeetingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createMeetingBtn setTitle:@"创建频道" forState:UIControlStateNormal];
        _createMeetingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _createMeetingBtn.layer.cornerRadius = 3;
        _createMeetingBtn.clipsToBounds = YES;
        _createMeetingBtn.backgroundColor = disEnableColor;
    }
    return _createMeetingBtn;
}

- (UIView *)createBtnLayer {
    if (!_createBtnLayer) {
        _createBtnLayer = [[UIView alloc] init];
        _createBtnLayer.layer.cornerRadius = 3;
        _createBtnLayer.clipsToBounds = YES;
        _createBtnLayer.hidden = YES;
        _createBtnLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _createBtnLayer;
}

- (UIView *)joinBtnLayer {
    if (!_joinBtnLayer) {
        _joinBtnLayer = [[UIView alloc] init];
        _joinBtnLayer.hidden = YES;
        _joinBtnLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 80, 47) byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 80, 47);
        maskLayer.path = maskPath.CGPath;
        _joinBtnLayer.layer.mask = maskLayer;
    }
    return _joinBtnLayer;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = kfont(12);
        _describeLabel.textColor = [UIColor whiteColor];
        _describeLabel.text = @"阿里云音视频通信RTC提供基础通信服务";
        _describeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _describeLabel;
}

- (UIImageView *)headImageV {
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc] init];
        _headImageV.image = [NSBundle RBT_pngImageWithName:@"face"];
        _headImageV.layer.cornerRadius = 45;
        _headImageV.clipsToBounds = YES;
    }
    return _headImageV;
}

- (UIImageView *)headbgImageV {
    if (!_headbgImageV) {
        _headbgImageV = [[UIImageView alloc] init];
        _headbgImageV.image = [NSBundle RBT_pngImageWithName:@"headbg"];

    }
    return _headbgImageV;
}

- (UIImageView *)topbgImageV {
    if (!_topbgImageV) {
        _topbgImageV = [[UIImageView alloc] init];
        _topbgImageV.image = [NSBundle RBT_pngImageWithName:@"topg"];
    }
    return _topbgImageV;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"视频通话";
    }
    return _titleLabel;
}

- (UIImageView *)errorImageV {
    if (!_errorImageV) {
        _errorImageV = [[UIImageView alloc] init];
        _errorImageV.image = [NSBundle RBT_pngImageWithName:@"alivc_video_icon_error"];
        _errorImageV.hidden  = YES;
    }
    return _errorImageV;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.font = kfont(12);
        _errorLabel.textColor = RGB(252, 67, 71);
        _errorLabel.text = @"输入格式错误，请重新输入";
        _errorLabel.hidden  = YES;
    }
    return _errorLabel;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
