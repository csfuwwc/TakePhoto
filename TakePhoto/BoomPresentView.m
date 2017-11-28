//
//  BoomPresentView.m
//  Dreamore
//
//  Created by 李彦鹏 on 15/5/29.
//  Copyright (c) 2015年 李彦鹏. All rights reserved.
//
#define Height 150
#define Button_W_H 44
#import "BoomPresentView.h"

@interface BoomPresentView()
{
    CGFloat  currentHeight;
}
@property (nonatomic, strong) UIControl * mbView;
@property (nonatomic, strong) UIView * superView;
@end
@implementation BoomPresentView
-(id)initWithSuperView:(UIView *)superView withTitle:(NSString *)title withDes:(NSString *)des withButtonNames:(NSArray *)buttons
{
    if (self = [super init])
    {
        currentHeight = 0;
        [self initNormalUIWithSuperView:superView  withTitle:title withDes:des withButtonNames:buttons index:-1];

    }
    return self;
}
-(id)initWithSuperView:(UIView *)superView WithButtonNames:(NSArray *)names withSelectedIndex:(NSInteger)index
{
    if (self = [super init])
    {
        currentHeight = 0;
        [self initNormalUIWithSuperView:superView withTitle:nil withDes:nil withButtonNames:names index:index];
    }
    return self;
}

-(void)initNormalUIWithSuperView:(UIView *)superView withTitle:title withDes:des  withButtonNames:buttonNames index:(NSInteger)index
{
    //背景蒙板
    self.superView = superView;
    self.mbView = [[UIControl alloc]initWithFrame:superView.bounds];
    self.mbView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [self.mbView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.mbView.backgroundColor = [UIColor blackColor];
    self.mbView.alpha = 0;
    [superView addSubview:self.mbView];
    
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, Height);
    self.backgroundColor = [UIColor whiteColor];
    [superView addSubview:self];
    
    MySheetCustomBtn * titleBtn = [[MySheetCustomBtn alloc] initWithFrame:CGRectZero];
    titleBtn.userInteractionEnabled = NO;
    [self addSubview:titleBtn];
    //标题
    if ([title length]>0)
    {
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 20)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = title;
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = UIColorFromRGB(0x444444);
        [titleBtn addSubview:titleLab];
        
        currentHeight += 15+20;
    }
    

    //描述
    if ([des length]>0)
    {
        if (currentHeight==0)
        {
            currentHeight += 15;
        }
        else
        {
            currentHeight += 8;
        }
        
        CGSize size = [SystemManager getSizeWithWidth:ScreenWidth-40 content:des font:14 lineSpace:2] ;
        UILabel * desLab = [[UILabel alloc] initWithFrame:CGRectMake(20, currentHeight, ScreenWidth-40, size.height)];
        desLab.font = [UIFont systemFontOfSize:14];
        desLab.textColor = UIColorFromRGB(0x888888);
        desLab.text = des;
        
        //单行居中
        if (size.height<21)
        {
            desLab.textAlignment = NSTextAlignmentCenter;
        }
        //多行居左
        else
        {
            desLab.textAlignment = NSTextAlignmentLeft;
        }
        desLab.numberOfLines = 0;
        [titleBtn addSubview:desLab];
        
        currentHeight += size.height + 15;
        
        titleBtn.frame = CGRectMake(0, 0, ScreenWidth, currentHeight);
    }
    
    //按钮
    for (NSString * btnTitle in buttonNames)
    {
        UIColor * color = [UIColor blackColor];
        if (index==[buttonNames indexOfObject:btnTitle])
        {
            color = [UIColor redColor];
        }
        MySheetCustomBtn * btn = [[MySheetCustomBtn alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) withTitle:btnTitle withColor:color];
        if (currentHeight==0)
        {
            btn.frame = CGRectMake(0, currentHeight+[buttonNames indexOfObject:btnTitle]*(44+1)+1, ScreenWidth,44);
        }
        else
        {
            btn.frame = CGRectMake(0, currentHeight+1, ScreenWidth,44);
        }

        btn.tag = [buttonNames indexOfObject:btnTitle];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        currentHeight += 44+1;
    }
    
    
    
    MySheetCustomBtn * cancenlBtn = [[MySheetCustomBtn alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) withTitle:@"取消"];
    cancenlBtn.frame = CGRectMake(0, currentHeight+ +10, ScreenWidth, 44);
    [cancenlBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancenlBtn];
    
    currentHeight += 44 +10;
    
    self.frame = CGRectMake(0,  ScreenHeight, ScreenWidth, currentHeight);
    
    

    
    
    
    
    
}

-(void)buttonClick:(UIButton *)btn
{
    
    if (self.buttonBlock)
    {
        self.buttonBlock(btn.tag);
    }
    
    [self cancel:btn];
}
-(void)cancel:(UIButton *)btn
{
    [self dismiss];
}
-(void)dismiss
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.25 animations:^{
        weakSelf.top = weakSelf.superView.height;
        weakSelf.mbView.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (weakSelf.dismissComplete)
        {
            weakSelf.dismissComplete(finished);
        }
        [weakSelf removeFromSuperview];
        [weakSelf.mbView removeFromSuperview];
        
    }];
}

-(void)show
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.25 animations:^{
        weakSelf.top = weakSelf.superView.height - weakSelf.height;
        weakSelf.mbView.alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
}

@end


@implementation MySheetCustomBtn

-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color  withFont:(UIFont*)font
{
    if (self = [self init])
    {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        lab.textColor =  color;
        lab.text = title;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = font;
        lab.userInteractionEnabled = NO;
        [self addSubview:lab];
        
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color
{
    if (self = [self init])
    {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        lab.textColor =  color;
        lab.text = title;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:17];
        lab.userInteractionEnabled = NO;
        [self addSubview:lab];
        
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title
{
    if (self = [self init])
    {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        lab.textColor =  [UIColor blackColor];
        lab.text = title;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:17];
        lab.userInteractionEnabled = NO;
        [self addSubview:lab];
        
    }
    return self;
}
-(id)init
{
    if (self=[super init])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

@end
