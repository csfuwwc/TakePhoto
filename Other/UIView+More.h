//
//  UIView+More.h
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import <UIKit/UIKit.h>


//获取视图底部极限-约束
MASViewAttribute*  MD_SafeAreaInset_Masonry_Boom(UIView * view);

//获取视图顶部极限-约束
MASViewAttribute*  MD_SafeAreaInset_Masonry_Top(UIView * view);

//获取视图安全区域
UIEdgeInsets MD_SafeAreaInset(UIView * view);

/**
 *  view增加点击事件回调
 *
 *  @param view 点击view
 */
typedef void(^ClickBlock)(UIView * view);

@interface UIView(More)


/**
 *  起点
 */
@property CGPoint origin;
/**
 *  尺寸
 */
@property CGSize size;

/**
 *  横 中心坐标
 */
@property CGFloat centerX;
/**
 *  纵 中心坐标
 */
@property CGFloat centerY;

/**
 *  高度
 */
@property CGFloat height;
/**
 *  宽度
 */
@property CGFloat width;
/**
 *  Y坐标
 */
@property CGFloat top;

@property CGFloat boom;
/**
 *  距离左侧
 */
@property CGFloat left;

@property CGFloat right;

//点击回调
@property (copy, nonatomic) ClickBlock clickBlock;

//动画
@property (strong, nonatomic, readonly) CABasicAnimation * zoomAnimation;


- (void)showZoomAnimation;

- (void)addShadow;

@end
