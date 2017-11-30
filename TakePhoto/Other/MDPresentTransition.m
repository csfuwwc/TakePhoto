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


@end
