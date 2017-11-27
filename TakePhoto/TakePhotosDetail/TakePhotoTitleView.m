//
//  TakePhotoTitleView.m
//  MoDianZhongChou
//
//  Created by 李彦鹏 on 2017/6/23.
//  Copyright © 2017年 Modian. All rights reserved.
//

#import "TakePhotoTitleView.h"

@implementation TakePhotoTitleView

-(id)initWithFrame:(CGRect)rect title:(NSString *)title
{
    if (self = [super init])
    {
        self.frame = rect;
        self.backgroundColor = [UIColor clearColor];
        
        //标题
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLab.text = title;
        [self.titleLab setTextColor:[UIColor blackColor]];
        self.titleLab.font = [UIFont boldSystemFontOfSize:15];
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.mas_centerX).offset(-8.5);
            make.centerY.mas_equalTo(0);
            
        }];
        
        //右侧箭头
        self.rightArrow = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.rightArrow setImage:[UIImage imageNamed:@"project-all-arrow-down"]];
        [self addSubview:self.rightArrow];
        
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.titleLab.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(12, 10));
        }];
        
    }
    return self;
}
- (void)setIsShow:(BOOL)isShow
{
    if (_isShow != isShow)
    {
        _isShow = isShow;
        
        if (_isShow)
        {
            [self.rightArrow setTransform:CGAffineTransformMakeRotation(M_PI) ];
        }
        else
        {
            [self.rightArrow setTransform:CGAffineTransformMakeRotation(0)];
        }
    }
}
@end
