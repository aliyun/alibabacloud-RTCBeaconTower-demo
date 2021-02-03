//
//  RTCDoubleActionsAlertController.m
//  RTCVideoLiveRoom
//
//  Created by aliyun on 2020/8/19.
//

#import "RTCDoubleActionsAlertController.h"
#import "NSBundle+RTCCommonView.h"

@interface RTCDoubleActionsAlertController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contentLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *leftButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *rightButton;

@property (copy,nonatomic) NSString *alertTitle;
@property (copy,nonatomic) NSString *message;
@property (copy,nonatomic) NSString *leftActionTitle;
@property (copy,nonatomic) NSString *rightActionTitle;
@property (copy,nonatomic) void(^leftAction)(void);
@property (copy,nonatomic) void(^rightAction)(void);

@end

@implementation RTCDoubleActionsAlertController

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftActionTitle:(NSString *)leftTitle
                   leftAction:(void(^)(void))leftAction
             rightActionTitle:(NSString *)rightTitle
                   rightAction:(void(^)(void))rightAction
{
    UIStoryboard *storyboard = [NSBundle RCV_storyboard];
    self =  [storyboard instantiateViewControllerWithIdentifier:@"RTCDoubleActionsAlertController"];
    self.alertTitle = title;
    self.message = message;
    self.leftActionTitle = leftTitle;
    self.rightActionTitle = rightTitle;
    self.leftAction = leftAction;
    self.rightAction = rightAction;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = self.alertTitle;
    self.contentLabel.text = self.message;
    [self.leftButton setTitle:self.leftActionTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:self.rightActionTitle forState:UIControlStateNormal];
}

- (IBAction)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.leftAction) {
        self.leftAction();
    }
   
}

- (IBAction)rightClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.rightAction) {
        self.rightAction();
    }
   
}


@end
