//
//  LoadingButton.m
//  VoiceCall
//
//  Created by aliyun on 2020/4/20.
//

#import "LoadingButton.h"

@interface LoadingButton()

@property (weak,nonatomic) UIActivityIndicatorView *indicatorView;


@end

@implementation LoadingButton


- (void)layoutSubviews {
    [super layoutSubviews];
    //更新indicator 位置
    CGFloat x =  self.titleLabel.frame.origin.x - 30;
    CGFloat y = self.bounds.size.height * 0.5;
    //    self.titleLabel.backgroundColor = [UIColor redColor];
    self.indicatorView.center  = CGPointMake(x, y);
}

- (void)startLoading {
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    self.userInteractionEnabled  = NO;
    self.selected = YES;
    
}

- (void)stopLoading {
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
    self.userInteractionEnabled = YES;
    self.selected = NO;
}


- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [self addSubview:indicator];
        indicator.hidden = YES;
        indicator.userInteractionEnabled = YES;
        [indicator setColor:[UIColor whiteColor]];
        _indicatorView = indicator;
    }
    return _indicatorView;
}

- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state {
    UIImage *image = [self createImageWithColor:color];
    [self setBackgroundImage:image forState:state];
}
- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
