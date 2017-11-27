//
//  TakePhotosCell.m
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import "TakePhotosCell.h"
#import "TakePhoto.h"

#import <MobileCoreServices/UTCoreTypes.h>

@interface TakePhotosCell ()
//照片
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
//选择按钮
@property (weak, nonatomic) IBOutlet UIImageView *overLayerImageView;

@property (assign, nonatomic)  PHImageRequestID requestID;

@property (copy, nonatomic) NSString * localIdentifier;

@end

@implementation TakePhotosCell


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    //self.photoImageView.isGifStyle = NO;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    __weak typeof(self)weakSelf = self;
    
    if ([TakePhoto maxPhotoCount] == 1)
    {
        //单张不显示勾选标志
        
        self.overLayerImageView.hidden = YES;
        
        //点击图片
        self.photoImageView.clickBlock = ^(UIView * view){
            
            
            if (weakSelf.model.singleSelectedBlock)
            {
                weakSelf.model.singleSelectedBlock(weakSelf.model);
            }
            
        };
    }
    else
    {
        //多张显示勾选标志和index动画效果
        
        self.overLayerImageView.hidden = NO;
        
        //点击图片
        self.photoImageView.clickBlock = ^(UIView * view){
            
            weakSelf.model.selected = !weakSelf.model.selected;
            
            [weakSelf configOverLayerImageView:weakSelf.model.selected animation:YES];
            
            
        };
    }
    
}


-(void)setModel:(TakePhotoModel *)model
{
    
    _model = model;
    
    
    self.localIdentifier = model.asset.localIdentifier;
    
    __weak typeof(self)weakSelf = self;
    //缩略图片请求
    PHImageRequestID  thumbImage_requestID = [TakePhoto requestThumbImageForAsset:model.asset resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info, BOOL isDegraded){
        
        if ([weakSelf.localIdentifier isEqualToString:model.asset.localIdentifier])
        {
            NSLog(@"获取了具体图片---->%@----->是否缩略图-->%@",image,@(isDegraded));
            
            weakSelf.photoImageView.image = image;
        }
        else
        {
            [[PHImageManager defaultManager] cancelImageRequest:weakSelf.requestID];
        }
        
        if (!isDegraded)
        {
            weakSelf.requestID = 0;
        }
        
    }];
    
    if (self.requestID && thumbImage_requestID && self.requestID != thumbImage_requestID)
    {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
    }
    
    self.requestID = thumbImage_requestID;
    
    
    
    [self configOverLayerImageView:self.model.selected animation:NO];
    
}

-(void)configOverLayerImageView:(BOOL)selected  animation:(BOOL)animation
{
    
    
    //如果是单张图片-直接返回
    if ([TakePhoto maxPhotoCount] == 1)
    {
        return;
    }
    //选中
    if (selected)
    {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPhotoSelected) name:@"refreshPhotoSelected" object:nil];
        
        self.overLayerImageView.image =  [self indexStr:[NSString stringWithFormat:@"%ld",(long)self.model.index]];
        
        
        if (animation)
        {
            [self.overLayerImageView showZoomAnimation];
        }
        
    }
    //未选中
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshPhotoSelected" object:nil];
        
        self.overLayerImageView.image = [TakePhoto overLayerUnselectedImage];
    }
}

- (void)refreshPhotoSelected
{
    [self configOverLayerImageView:self.model.selected animation:NO];
}

- (UIImage *)indexStr:(NSString *)string
{
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(24, 24), NO, 0);
    
    //画圆
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor clearColor] setFill];
    
    CGContextFillRect(ctx, CGRectMake(0, 0, 24, 24));
    
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 24, 24));
    
    [[UIColor greenColor] setFill];
    
    CGContextFillPath(ctx);
    
    
    //顺序
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:1]};
    
    CGSize textSize = [string sizeWithAttributes:attribute];
    
    [string drawInRect:CGRectMake((24-textSize.width)/2.0, (24-textSize.height)/2.0, 24, textSize.height) withAttributes:attribute];
    
    
    UIImage * result_Image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return result_Image;
}




@end


