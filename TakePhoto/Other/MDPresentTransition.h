//
//  MDPresentTransition.h
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 17/5/15.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Transiton_Camera_Present,//相机弹出
    Transiton_Camera_Dissmiss,//相机消失
} TransitonType;

@interface MDPresentTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)transitonType:(TransitonType)type;

- (instancetype)initWithTransitonType:(TransitonType)type;

@end
