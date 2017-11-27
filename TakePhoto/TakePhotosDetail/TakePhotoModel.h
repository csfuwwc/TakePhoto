//
//  TakePhotoModel.h
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class TakePhotoModel;
//是否能够继续选择照片
typedef BOOL(^TakePhoto_ShouldSelectBlock)();
//选择一张新的照片
typedef void(^TakePhoto_DidSelectedBlock)(TakePhotoModel * model);
//取消选择一张已选照片
typedef void(^TakePhoto_DidDeselectedBlock)(TakePhotoModel * model);

//单张-选择某张照片
typedef void(^TakePhoto_SingleSelectedBlock)(TakePhotoModel * model);


@interface TakePhotoModel : NSObject

@property (strong ,nonatomic) PHAsset * asset;

@property (assign, nonatomic) BOOL selected;


//是否能够继续勾选
@property (copy, nonatomic) TakePhoto_ShouldSelectBlock shouldSelectBlock;
//勾选回调
@property (copy, nonatomic) TakePhoto_DidSelectedBlock  didSelectedBlock;
//取消勾选回调
@property (copy, nonatomic) TakePhoto_DidDeselectedBlock didDeselectedBlock;
//选择单张
@property (copy, nonatomic) TakePhoto_SingleSelectedBlock singleSelectedBlock;



//用于显示的image
@property (strong, nonatomic) UIImage * image;
//用于上传的data
@property (strong, nonatomic) NSData * imageData;
//用于上传的image
@property (strong, nonatomic) UIImage * uploadImage;

//标记是否是GIF格式
@property (assign, nonatomic) BOOL isGif;

//选中顺序
@property (assign, nonatomic) NSInteger index;

@end
