//
//  CodeInputView.m 
//

#import "CodeInputView.h"
#import "CALayer+Sublayer.h"

//#define K_W 59.5
//#define K_Screen_Width               [UIScreen mainScreen].bounds.size.width
#define K_Screen_Height              [UIScreen mainScreen].bounds.size.height
#define K_InputView_TintColor                  [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1]
#define K_InputView_FontColor                  [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1]
@interface CodeInputView()<UITextViewDelegate>
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)NSMutableArray <CAShapeLayer *> * lines;
@property(nonatomic,strong)NSMutableArray <UILabel *> * labels;
@end

@implementation CodeInputView

- (instancetype)initWithFrame:(CGRect)frame inputType:(NSInteger)inputNum selectCodeBlock:(SelectCodeBlock)CodeBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.CodeBlock = CodeBlock;
        self.inputNum = inputNum;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat W = CGRectGetWidth(self.frame);
    CGFloat H = CGRectGetHeight(self.frame);
    CGFloat Padd = 20;
    [self addSubview:self.textView];
    self.textView.frame = CGRectMake(0, 0, W, H);
    CGFloat K_W = (W - (_inputNum -1) *Padd)/_inputNum;
    //默认编辑第一个.
//    [self beginEdit];
    for (int i = 0; i < _inputNum; i ++) {
        UIView *subView = [UIView new];
        subView.frame = CGRectMake((K_W+Padd)*i, 0, K_W, H);
        subView.userInteractionEnabled = NO;
        [self addSubview:subView];
        [CALayer addSubLayerWithFrame:CGRectMake(0, H-2, K_W, 1) backgroundColor:K_InputView_TintColor backView:subView];
        //Label
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, K_W, H);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = K_InputView_FontColor;
        label.font = [UIFont systemFontOfSize:16];
        [subView addSubview:label];
        //光标
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(K_W / 2, 15, 2, H - 30)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  K_InputView_TintColor.CGColor;
        [subView.layer addSublayer:line];
        if (i == 0) {
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            //高亮颜色
            line.hidden = NO;
        }else {
            line.hidden = YES;
        }
        //把光标对象和label对象装进数组
        [self.lines addObject:line];
        [self.labels addObject:label];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
    
    
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //每次响应的时候 清空原来数据
    self.text = @"";
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self endEdit];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    NSString *verStr = textView.text;
    if (verStr.length > _inputNum) {
        textView.text = [textView.text substringToIndex:_inputNum];
    }
    //赋值
     _text = textView.text;
    
    //大于等于最大值时, 结束编辑
    if (verStr.length >= _inputNum) {
        [self endEdit];
    }
    if (self.CodeBlock) {
        self.CodeBlock(textView.text);
    }
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        
        if (i < verStr.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
        }else {
            [self changeViewLayerIndex:i linesHidden:i == verStr.length ? NO : YES];
            //textView的text为空的时候
            if (!verStr && verStr.length == 0) {
                [self changeViewLayerIndex:0 linesHidden:NO];
            }
            bgLabel.text = @"";
        }
    }
}
//设置光标显示隐藏
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    CAShapeLayer *line = self.lines[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        line.hidden = hidden;
    }];
}
//开始编辑
- (void)beginEdit{
    [self.textView becomeFirstResponder];
}
//结束编辑
- (void)endEdit{
    [self.textView resignFirstResponder];
    for (int i = 0; i < _inputNum; i++) {
        [self changeViewLayerIndex:i linesHidden:YES];
    }
}
//闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}
//对象初始化
- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textView;
}


- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = self.text;
    [self textViewDidChange:self.textView];
}
@end
