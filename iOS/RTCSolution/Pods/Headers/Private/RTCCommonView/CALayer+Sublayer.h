//
//  CALayer+Category.h 
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (Sublayer)

+ (CALayer *)addSubLayerWithFrame:(CGRect)frame
                  backgroundColor:(UIColor *)color
                         backView:(UIView *)baseView;
@end
