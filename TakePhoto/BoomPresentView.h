//
//  BoomPresentView.h
//  Dreamore
//
//  Created by 李彦鹏 on 15/5/29.
//  Copyright (c) 2015年 李彦鹏. All rights reserved.
//
typedef void(^ButtonClickBlock)(NSInteger index);


#import <UIKit/UIKit.h>

@interface BoomPresentView : UIView

/**
 弹窗显示选项框

 @param superView 依赖视图
 @param title 顶部标题<非必选>
 @param desc 文案描述<非必选>
 @param buttons 按钮名称数组<必选>
 */
+ (void)showWithSuperView:(UIView *)superView title:(NSString *)title desc:(NSString *)desc
              buttonNames:(NSArray *)buttons resultBlock:(void(^)(NSInteger index))resultBlock;

@end


@interface MySheetCustomBtn : UIButton


-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title;

-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color;

-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color  withFont:(UIFont*)font;

@end
