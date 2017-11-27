//
//  TakePhotosTableCell.m
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import "TakePhotosTableCell.h"
#import "TakePhoto.h"

@interface TakePhotosTableCell ()
//封面图
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//相册名字
@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;
//相册张数
@property (weak, nonatomic) IBOutlet UILabel *headCountLabel;
//箭头图片
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
//底层view
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation TakePhotosTableCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.rightImageView.image = [TakePhoto rightArrowImage];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TakePhotosTableModel *)model
{
    if (_model != model)
    {
        _model = model;
        
        
        //相册首页图
        if (_model.image)
        {
            self.headImageView.image = model.image;
        }
        else
        {
            
            PHAsset * tmpAsset=[model.result objectAtIndex:model.result.count-1];
            
            [TakePhoto  requestThumbImageForAsset:tmpAsset resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info, BOOL isDegraded){
                
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                
                //设置BOOL判断，确定返回高清照片
                if (downloadFinined)
                {
                    float scale = result.size.height / 70;
                    
                    self.headImageView.image =[UIImage imageWithCGImage:result.CGImage scale:scale orientation:UIImageOrientationUp];
                }
                
            }];
        }

        //相册名字
        self.headNameLabel.text = model.title;
        
        //相片数量
        self.headCountLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[model.result count]];
    }
}


@end
