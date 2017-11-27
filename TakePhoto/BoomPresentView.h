//
//  BoomPresentView.h
//  Dreamore
//
//  Created by 李彦鹏 on 15/5/29.
//  Copyright (c) 2015年 zhangbo. All rights reserved.
//





#import <UIKit/UIKit.h>

typedef void(^ButtonClickBlock)(NSInteger index);
typedef void(^DismissComplete)(BOOL isComplete);

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
-(void)dismiss;
-(void)show;
@end
