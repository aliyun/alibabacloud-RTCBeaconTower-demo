//
//  CALayer+Category.m 
//

#import "CALayer+Sublayer.h"

@implementation CALayer (Sublayer)

+ (CALayer *)addSubLayerWithFrame:(CGRect)frame
                  backgroundColor:(UIColor *)color
                         backView:(UIView *)baseView{
    CALayer * layer = [[CALayer alloc]init];
    layer.frame = frame;
    layer.backgroundColor = [color CGColor];
    [baseView.layer addSublayer:layer];
    return layer;
}

@end
