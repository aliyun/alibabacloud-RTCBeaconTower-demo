//
//  RTCSingleActionAlertController.m
//  RTCVideoLiveRoom
//
//  Created by aliyun on 2020/8/19.
//
#import "NSBundle+RTCCommonView.h"
#import "RTCSingleActionAlertController.h"

@interface RTCSingleActionAlertController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contentLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *confirmButton;

@property (copy,nonatomic) NSString *alertTitle;
@property (copy,nonatomic) NSString *message;
@property (copy,nonatomic) NSString *actionTitle;

@property (copy,nonatomic) void(^action)(void);
@end

@implementation RTCSingleActionAlertController

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              actionTitle:(NSString *)actionTitle
                   action:(void(^)(void))action
{
    UIStoryboard *storyboard = [NSBundle RCV_storyboard];
    self =  [storyboard instantiateViewControllerWithIdentifier:@"RTCSingleActionAlertController"];
    self.alertTitle = title;
    self.message = message;
    self.actionTitle = actionTitle;
//
    self.action = action;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentLabel.text = self.message;
    self.titleLabel.text = self.alertTitle;
    [self.confirmButton setTitle:self.actionTitle
                            forState:UIControlStateNormal];
}

- (IBAction)confirm:(id)sender
{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.action) {
             self.action();
         }
}


@end
