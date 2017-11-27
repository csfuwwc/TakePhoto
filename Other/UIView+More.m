//
//  UIView+More.m
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import "UIView+More.h"
#import <objc/runtime.h>

@implementation UIView(More)

-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGSize)size
{
    return self.frame.size;
}

-(void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGPoint)origin
{
    return self.frame.origin;
}



- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

-(CGFloat)top
{
    return self.frame.origin.y;
}

-(void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

-(void)setBoom:(CGFloat)boom
{
    CGRect frame = self.frame;
    frame.origin.y = boom - self.frame.size.height;
    self.frame = frame;
}
-(CGFloat)boom
{
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
-(CGFloat)left
{
    return self.frame.origin.x;
}

-(void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}
-(CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(void) setCenterY:(CGFloat) y
{
    CGPoint pt = self.center;
    pt.y = y;
    self.center = pt;
}

-(void) setCenterX:(CGFloat) x
{
    CGPoint pt = self.center;
    pt.x = x;
    self.center = pt;
}

-(CGFloat) centerX
{
    return self.center.x;
}

-(CGFloat) centerY
{
    return self.center.y;
}
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}



#pragma mark - 点击事件

ObjcKey(HMViewClickEventKey);

-(void)setClickBlock:(ClickBlock)clickBlock
{
    objc_setAssociatedObject(self, HMViewClickEventKey, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (clickBlock)
    {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = (id <UIGestureRecognizerDelegate>) self;
        [self addGestureRecognizer:tap];
    }
}
-(ClickBlock)clickBlock
{
    return  objc_getAssociatedObject(self, HMViewClickEventKey);
}

-(void)clickView:(UITapGestureRecognizer *)gesture
{
    
    ClickBlock block = objc_getAssociatedObject(self, HMViewClickEventKey);
    
    if (block)
    {
        block(self);
    }
}

#pragma mark - 点击缩放动画

- (void)showZoomAnimation
{
    if (!self.zoomAnimation)
    {
        
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.duration = 0.08;
        animation.repeatCount = 1;
        animation.autoreverses = YES;
        animation.removedOnCompletion = YES;
        animation.fromValue = [NSNumber numberWithFloat:0.8];
        animation.toValue = [NSNumber numberWithFloat:1.3];
        
        self.zoomAnimation = animation;
    }
    
    [self.layer addAnimation:self.zoomAnimation forKey:nil];}

ObjcKey(HMZoomAnimaitonKey);

- (void)setZoomAnimation:(CABasicAnimation *)zoomAnimation
{
    objc_setAssociatedObject(self, HMZoomAnimaitonKey, zoomAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CABasicAnimation *)zoomAnimation
{
    return objc_getAssociatedObject(self, HMZoomAnimaitonKey);
}

@end
