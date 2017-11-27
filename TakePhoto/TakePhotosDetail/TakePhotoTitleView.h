//
//  TakePhotoTitleView.h
//  MoDianZhongChou
//
//  Created by 李彦鹏 on 2017/6/23.
//  Copyright © 2017年 Modian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhotoTitleView : UIView

//标题
@property (strong, nonatomic) UILabel * titleLab;
//右侧箭头
@property (strong, nonatomic) UIImageView * rightArrow;
//是否正在显示
@property (assign, nonatomic) BOOL isShow;

-(id)initWithFrame:(CGRect)rect title:(NSString *)title;

@end
