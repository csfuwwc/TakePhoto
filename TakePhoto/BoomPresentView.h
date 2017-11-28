//
//  BoomPresentView.h
//  Dreamore
//
//  Created by 李彦鹏 on 15/5/29.
//  Copyright (c) 2015年 李彦鹏. All rights reserved.
//

typedef void(^ButtonClickBlock)(NSInteger index);
typedef void(^DismissComplete)(BOOL isComplete);

#import <UIKit/UIKit.h>

@interface BoomPresentView : UIView
@property(strong,nonatomic)ButtonClickBlock buttonBlock;
@property(strong,nonatomic)DismissComplete dismissComplete;
/**
 *  下方弹出视图初始化方法
 *
 *  @param superView 出现的view
 *  @param title     标题
 *  @param des       描述
 *  @param buttons   按钮列表名字，不包含取消按钮
 *
 *  @return
 */
-(id)initWithSuperView:(UIView *)superView withTitle:(NSString *)title withDes:(NSString *)des withButtonNames:(NSArray *)buttons;
/**
 *  消失
 */
-(void)dismiss;
/**
 *  弹起
 */
-(void)show;
/**
 *  下方弹出纯按钮视图初始化方法
 *
 *  @param superView 父视图
 *  @param names     按钮标题数组
 *  @param index     当前选中列表
 *
 *  @return 
 */
-(id)initWithSuperView:(UIView *)superView WithButtonNames:(NSArray *)names withSelectedIndex:(NSInteger)index;
@end


@interface MySheetCustomBtn : UIButton
-(id)initWithFrame:(CGRect)frame    withTitle:(NSString *)title;
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color;
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color  withFont:(UIFont*)font;

@end
