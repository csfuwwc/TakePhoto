//
//  HMTakePhotoCell.m
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import "HMTakePhotoCell.h"


@interface HMTakePhotoCell()
@property (nonatomic, assign) BOOL  alignmentLeft;
@property (nonatomic, strong) NSArray *rowAssets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *overlayViewArray;
@end
@implementation HMTakePhotoCell

- (void)awakeFromNib
{
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        
        //相片承载数组
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        
        //选中状态相片承载数组
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;
        
        self.alignmentLeft = YES;
        
        self.shouldShowOverView = YES;
        
    }
    return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
    
    for (UIImageView *view in _imageViewArray)
    {
        [view removeFromSuperview];
    }
    for (OverLayerTakePhotoImageView *view in _overlayViewArray)
    {
        [view removeFromSuperview];
    }

    UIImage * overlayImage = nil;
    UIImage * overlayUnselectedImage = nil;
    for (int i = 0; i < [_rowAssets count]; ++i)
    {
        
        HMTakePhotoModel * asset = [_rowAssets objectAtIndex:i];
        
        if (i < [_imageViewArray count])
        {
            UIImageView *imageView = [_imageViewArray objectAtIndex:i];
            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
        }
        else
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
            [_imageViewArray addObject:imageView];
        }
        
        
        //如果是单张，不添加上方模版
        if (self.shouldShowOverView)
        {
            if (i < [_overlayViewArray count])
            {
                OverLayerTakePhotoImageView *overlayView = [_overlayViewArray objectAtIndex:i];
                overlayView.selected = asset.selected ? YES : NO;
                
                //overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
            }
            else
            {
                //选中状态图片
                if (overlayImage == nil)
                {
                    overlayImage = [UIImage imageNamed:@"icon_choose_selected"];
                }
                //非选中状态图片
                if (!overlayUnselectedImage)
                {
                    overlayUnselectedImage = [UIImage imageNamed:@"icon_choose"];
                }
                
                OverLayerTakePhotoImageView *overlayView = [[OverLayerTakePhotoImageView alloc] initWithImage:overlayUnselectedImage];
                [_overlayViewArray addObject:overlayView];
                overlayView.selected = asset.selected ? YES : NO;
                
                //overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
            }
        }
        
        

    }
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint point = [tapRecognizer locationInView:self];
    int c = (int32_t)self.rowAssets.count;
    CGFloat width = (ScreenWidth - 20)/4.0;
    CGFloat totalWidth = c * width + (c + 1) * 4;
    CGFloat startX;
    
    if (self.alignmentLeft)
    {
        startX = 4;
    }
    else
    {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
    CGRect frame = CGRectMake(startX, 4, width, width);
    for (int i = 0; i < [_rowAssets count]; ++i)
    {
        if (CGRectContainsPoint(frame, point))
        {

            HMTakePhotoModel *asset = [_rowAssets objectAtIndex:i];
            asset.selected = !asset.selected;
            
            if (self.shouldShowOverView)
            {
                OverLayerTakePhotoImageView *overlayView = [_overlayViewArray objectAtIndex:i];
                overlayView.selected = asset.selected;
            }
            else
            {
                DetailImageViewModel * model = [[DetailImageViewModel alloc] initWithType:ImageType_PhotoLibrary Url:[asset.asset valueForProperty:ALAssetPropertyAssetURL]];
                model.image = [asset selectedAssetImage];
                
                
                //如果是只选择一张的话，选择后立即返回
                if (self.singelBlock)
                {
                    self.singelBlock(model.image,model);

                }
            }
          
            if (asset.selected)
            {
                asset.index = [[HMTakePhotoManager  shareTakePhotoManager] numberOfAllIndex];
                [[HMTakePhotoManager shareTakePhotoManager] addIndex:asset.index];
            }
            else
            {
                NSInteger lastElement = [[HMTakePhotoManager shareTakePhotoManager] numberOfAllIndex] - 1;
                [[HMTakePhotoManager shareTakePhotoManager] removeIndex:lastElement];
            }
            
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}

- (void)layoutSubviews
{
    int c = (int32_t)self.rowAssets.count;
    CGFloat width = (ScreenWidth - 20)/4.0;
    CGFloat totalWidth = c * width + (c + 1) * 4;
    CGFloat startX;
    
    if (self.alignmentLeft)
    {
        startX = 4;
    }
    else
    {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
    CGRect frame = CGRectMake(startX, 4, width, width);
    CGRect overFrame = CGRectMake(width-27, 3, 24, 24);
    
    for (int i = 0; i < [_rowAssets count]; ++i)
    {
        UIImageView *imageView = [_imageViewArray objectAtIndex:i];
        [imageView setFrame:frame];
        [self addSubview:imageView];
        
        frame.origin.x = frame.origin.x + frame.size.width + 4;

        
        if (self.shouldShowOverView)
        {
            OverLayerTakePhotoImageView * overlayView = [_overlayViewArray objectAtIndex:i];
            [overlayView setFrame:overFrame];
            [imageView addSubview:overlayView];
        }
      
    }
}


@end

@implementation OverLayerTakePhotoImageView

-(void)setSelected:(BOOL)selected
{
    _selected = selected;

    
    //选中
    if (selected)
    {
        self.image = [UIImage imageNamed:@"photo_selected"];
    }
    //未选中
    else
    {
        self.image = [UIImage imageNamed:@"photo_unselected"];
    }
}

@end
