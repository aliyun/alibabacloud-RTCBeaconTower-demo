//
//  RTCOffLineController.m
//  RTCCommonView
//
//  Created by aliyun on 2020/8/19.
//

#import "RTCOffLineController.h"
#import "NSBundle+RTCCommonView.h"
#import "RTCCommon.h"

@interface RTCOffLineController ()
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *closeButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *retryButton;

@property (copy,nonatomic) void(^closeAction)(void);
@property (copy,nonatomic) void(^retryAction)(void);

@end

@implementation RTCOffLineController

- (instancetype)initWithcloseAction:(void(^)(void))closeAction
                        retryAction:(void(^)(void))retryAction
{
    self = [[NSBundle RCV_storyboard] instantiateViewControllerWithIdentifier:@"RTCOffLineController"];
    self.closeAction = closeAction;
    self.retryAction = retryAction;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageView setImage:[NSBundle RCV_pngImageWithName:@"lostConnection"]];
    
     [self.closeButton setImage:[NSBundle RCV_pngImageWithName:@"close"] forState:UIControlStateNormal];
    
    self.retryButton.layer.cornerRadius = 26;
    self.retryButton.layer.borderWidth = 1;
    self.retryButton.layer.borderColor = [UIColor colorWithHex:0x18BFFF].CGColor;
    
}

- (IBAction)close:(id)sender
{
    if (self.closeAction) {
        self.closeAction();
    }
}
- (IBAction)retry:(id)sender
{
    if (self.retryAction) {
        self.retryAction();
    }
}

@end
