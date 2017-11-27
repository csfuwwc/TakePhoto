//
//  BoomPresentView.m
//  Dreamore
//
//  Created by 李彦鹏 on 15/5/29.
//  Copyright (c) 2015年 zhangbo. All rights reserved.
//
#define Height 150
#define Button_W_H 44
#import "BoomPresentView.h"
#import "TakePhotos.h"

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
        [self initNormalUIWithSuperView:superView  withTitle:title withDes:des withButtonNames:buttons];

    }
    return self;
}


-(void)initNormalUIWithSuperView:(UIView *)superView withTitle:title withDes:des  withButtonNames:buttonNames
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
    self.backgroundColor = UIColorFromRGB(0xEEEEEE);
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
        
        CGSize size = [self getSizeWithWidth:ScreenWidth-40 content:des font:14];
        UILabel * desLab = [[UILabel alloc] initWithFrame:CGRectMake(20, currentHeight, ScreenWidth-40, size.height)];
        desLab.font = [UIFont systemFontOfSize:14];
        desLab.textColor = UIColorFromRGB(0x888888);
        desLab.text = des;
        desLab.textAlignment = NSTextAlignmentCenter;
        desLab.numberOfLines = 0;
        [titleBtn addSubview:desLab];
        
        currentHeight += size.height + 15;
        
        titleBtn.frame = CGRectMake(0, 0, ScreenWidth, currentHeight);
        [titleBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [titleBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    //按钮


    for (NSString * btnTitle in buttonNames)
    {
        MySheetCustomBtn * btn = [[MySheetCustomBtn alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) withTitle:btnTitle];
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
        
        if (weakSelf.dismissComplete) {
            weakSelf.dismissComplete(finished);
        }
        
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

-(CGSize)getSizeWithWidth:(CGFloat)width content:(NSString *)str font:(int)font
{
    
    if (str.length == 0 || !str) {
        
        return CGSizeZero;
    }
    
    
    NSDictionary * attDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor],[UIFont systemFontOfSize:font], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    
    
    NSAttributedString * attStr = [[NSAttributedString alloc]initWithString:str attributes:attDic];
    NSRange range = NSMakeRange(0, attStr.length);
    NSDictionary * dic = [attStr attributesAtIndex:0 effectiveRange:&range];
    
    
    CGRect  rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:Nil];
    return rect.size;

}

@end
