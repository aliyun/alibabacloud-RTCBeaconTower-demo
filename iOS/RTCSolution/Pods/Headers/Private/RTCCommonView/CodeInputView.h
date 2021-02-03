//
//  CodeInputView.h
//  
//

#import <UIKit/UIKit.h>

typedef void(^SelectCodeBlock)(NSString *);

@interface CodeInputView : UIView

@property(nonatomic,copy) SelectCodeBlock CodeBlock;

@property(nonatomic,assign) NSInteger inputNum;//验证码输入个数（4或6个）

@property (nonatomic,copy) NSString *text;

- (instancetype)initWithFrame:(CGRect)frame inputType:(NSInteger)inputNum selectCodeBlock:(SelectCodeBlock)CodeBlock;

- (void)endEdit;

- (void)beginEdit;


@end
