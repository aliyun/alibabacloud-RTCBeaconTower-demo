//
//  UIView+Frame.m
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/12.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - get方法
- (CGPoint)origin {
    return self.frame.origin;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

#pragma mark - set方法
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setMaxX:(CGFloat)maxX {
    // 1.必须通过结构体赋值.直接赋值,涉及到计算时会出错.
    // 2.必须将x,y,当做已知条件;宽,高当做未知条件.涉及到计算时,才能正确计算出在父控件中的位置.
    // ❌错误方法 frame.origin.x = maxX - frame.size.width;
    // 错误原因:可能此时的宽度还没有值,所以计算出来的值是错误的.
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxX - self.frame.origin.x, self.frame.size.height);
}

- (void)setMaxY:(CGFloat)maxY {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, maxY - self.frame.origin.y);
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

#pragma mark - 私有方法 一般不会用到
/// 返回最顶层视图
- (UIView *)topSuperView {
    // 假定当前视图的父视图,就是最上层的视图
    // 取出父视图
    UIView *topSuperView = self.superview;
    
    // 判断是否有父视图
    if (topSuperView == nil) {
        // 当前视图没有父视图,自己就是最上层视图.
        topSuperView = self;
    } else {
        // 当前视图有父视图,此时 topSuperView = self.superview
        // 然后,通过while循环,继续取出父视图的父视图,直到取出最上层的父视图.赋值给topSuperView
        while (topSuperView.superview) {
            topSuperView = topSuperView.superview;
        }
    }
    
    return topSuperView;
}

- (void)centerEqualToView:(UIView *)view {
    // *******************重点
    // center属性是指当前view在其父view上的位置，center.x和center.y是以父view为参考系的。
        // 三目运算符
    // 取出参数view的父视图
    UIView *superView = view.superview ? view.superview : view;
    // 将参数view的中心点的坐标,从父视图的坐标系,转换到最上层的坐标系中.(可以理解为window的坐标系)
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    // 将参数view中心点的坐标,从最上层的坐标系,转换到当前视图的父视图的坐标系中.
    // center属性是指当前view在其父view上的位置
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    
    self.center = centerPoint;
}

@end
