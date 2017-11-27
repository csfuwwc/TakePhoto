//
//  MDPresentTransition.m
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 17/5/15.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import "MDPresentTransition.h"

@interface MDPresentTransition ()<CAAnimationDelegate>

@property (nonatomic, assign) TransitonType type;

@end

@implementation MDPresentTransition
- (instancetype)initWithTransitonType:(TransitonType)type
{
    if (self = [super init])
    {
        self.type = type;
    }
    return self;
}
+ (instancetype)transitonType:(TransitonType)type
{
    return [[self alloc] initWithTransitonType:type];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.type)
    {
        case Transiton_Camera_Present:
        {
            return 0.3;
        }
            break;
        case Transiton_Camera_Dissmiss:
        {
            return 0.3;
        }
        default:
        {
            return 0.5;
        }
            break;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.type)
    {
        case Transiton_HomeSearch_Present:
        {
            //搜索框弹出
            [self homeSearch_presentAnimaiton:transitionContext];
        }
            break;
        case Transiton_HomeSearch_Dissmiss:
        {
            //搜索框消失
            [self homeSearch_dismissAnimation:transitionContext];
        }
            break;
        case Transiton_Camera_Present:
        {
            //相机弹出
            [self camera_presentAnimaiton:transitionContext];
        }
            break;
        case Transiton_Camera_Dissmiss:
        {
            //相机消失
            [self camera_dismissAnimation:transitionContext];
        }
        default:
            break;
    }
}


#pragma mark 搜索框

- (void)homeSearch_presentAnimaiton:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    //画两个圆路径
    UIBezierPath *startCycle =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(ScreenWidth-85, 40, 85, 85)];
    CGFloat x = (ScreenWidth);
    CGFloat y = (ScreenHeight);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    //将maskLayer作为toVC.View的遮盖
    toVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

}


- (void)homeSearch_dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];


    UIView *containerView = [transitionContext containerView];
    
    //画两个圆路径
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(ScreenWidth-85, 40, 85, 85)];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor redColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    fromVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

}


#pragma mark 相机


- (void)camera_presentAnimaiton:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromVC];
    
    fromVC.view.frame = fromFrame;
    toVC.view.frame = CGRectOffset(fromFrame, fromFrame.size.width, 0);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        toVC.view.frame = fromFrame;
        
    } completion:^(BOOL finished) {

        BOOL isCancelled = [transitionContext transitionWasCancelled];
        
        if (isCancelled)
        {
            [toVC.view removeFromSuperview];
        }
        
        [transitionContext completeTransition:!isCancelled];
    }];
}


- (void)camera_dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    
    
    fromVC.view.frame = toFrame;
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.frame = CGRectOffset(toFrame, toFrame.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        BOOL isCancelled = [transitionContext transitionWasCancelled];
        
        if (!isCancelled)
        {
            [fromVC.view removeFromSuperview];
        }

        [transitionContext completeTransition:!isCancelled];
    }];

}



- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    switch (_type)
    {
        case Transiton_HomeSearch_Present:
        {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
            [transitionContext viewControllerForKey:UITransitionContextToViewKey].view.layer.mask = nil;
        }
            break;
        case Transiton_HomeSearch_Dissmiss:
        {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled])
            {
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
        }
            break;
        default:
            break;
    }
}

@end
