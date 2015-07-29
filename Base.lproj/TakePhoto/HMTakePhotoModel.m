//
//  HMTakePhotoModel.m
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import "HMTakePhotoModel.h"

@implementation HMTakePhotoModel
- (id)initWithAsset:(ALAsset*)asset
{
    self = [super init];
    if (self)
    {
        self.asset = asset;
        _selected = NO;
    }
    return self;
}
-(void)setSelected:(BOOL)selected
{
    if (selected)
    {
        if (!self.shouldSelectedBlock())
        {
            
            return;
        }
    }

    _selected = selected;
    
    
    //被选中
    if (_selected)
    {
        if (self.didSelectedBlock)
        {
            self.didSelectedBlock(self);
        }
    }
    //被取消选中
    else
    {
        if (self.didDeSelectedBlock)
        {
            self.didDeSelectedBlock(self);
        }
          
    }
    
}

//对应image对象
- (UIImage *)selectedAssetImage
{
    
    ALAsset *asset = self.asset;
    id obj = [asset valueForProperty:ALAssetPropertyType];
    if (!obj)
    {
        //continue;
    }
    NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
    
    
    [workingDictionary setObject:obj forKey:UIImagePickerControllerMediaType];
    
    //This method returns nil for assets from a shared photo stream that are not yet available locally. If the asset becomes available in the future, an ALAssetsLibraryChangedNotification notification is posted.
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    
    
    UIImage * img;
    
    if(assetRep != nil)
    {
        
        CGImageRef imgRef = nil;
        //defaultRepresentation returns image as it appears in photo picker, rotated and sized,
        //so use UIImageOrientationUp when creating our image below.
        UIImageOrientation orientation = UIImageOrientationUp;
        
        imgRef = [assetRep fullScreenImage];
        
        img = [UIImage imageWithCGImage:imgRef
                                  scale:1.0f
                            orientation:orientation];
        
        
    }
    
    
    return img;
}

-(BOOL)isTheSamePhotoWithModelArray:(NSArray *)models
{
    //防止models为nil闪退
    if (!models)
    {
        models = @[];
    }
    for (DetailImageViewModel * model in models)
    {
        //如果是来自相册选择图片
        if (model.imageType==0)
        {
          NSString * nsALAssetPropertyAssetURL = [self.asset valueForProperty:ALAssetPropertyAssetURL ] ;
            if ([nsALAssetPropertyAssetURL isEqual:model.URl])
            {
                return YES;
            }
        }
    }

    return NO;
}

@end


@implementation DetailImageViewModel

-(id)initWithType:(ImageSource_Type)type Url:(NSString *)url
{
    if (self = [super init])
    {
        self.imageType = type;
        self.URl = url;
    }
    return self;
}
-(NSString *)description
{
    NSString * str = [NSString stringWithFormat:@"type-->%ld--url-->%@--image-->%@",self.imageType,self.URl,self.image];
    return str;
}

@end