//
//  HMTakePhotoModel.h
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HMTakePhotoManager.h"
@class HMTakePhotoModel;
@class DetailImageViewModel;

/**
 图片来源 PhotoLibrary_Type 相册 Internet_Type 网络请求  UnKnown_Type 未知
 */
typedef enum : NSUInteger {
    ImageType_PhotoLibrary,//相册
    ImageType_Net,//网络请求
    ImageType_UnKnown,//未知
} ImageSource_Type;

//是否能够继续选择照片
typedef BOOL(^ShouldSelectedBlock)();

//选择一张新的照片
typedef void(^DidSelectedBlock)(HMTakePhotoModel * model);

//取消选择一张已选照片
typedef void(^DidDeSelectedBlock)(HMTakePhotoModel * model);


@interface HMTakePhotoModel : NSObject
@property(strong,nonatomic)ALAsset * asset;
@property(assign,nonatomic)BOOL selected;
@property(assign,nonatomic)NSInteger index;



@property(strong,nonatomic)ShouldSelectedBlock shouldSelectedBlock;
@property(strong,nonatomic)DidDeSelectedBlock didSelectedBlock;
@property(strong,nonatomic)DidDeSelectedBlock didDeSelectedBlock;
- (id)initWithAsset:(ALAsset *)asset;
- (UIImage *)selectedAssetImage;
-(BOOL)isTheSamePhotoWithModelArray:(NSArray *)models;
@end


//用于标记图片来自于相册或者网络模型类
@interface DetailImageViewModel : NSObject

/**
 *  图片来源
 */
@property(assign,nonatomic)ImageSource_Type imageType;

/**
 *  图片地址：如果是网络请求－则为图片网络地址；如果是相册图片－则为图片内存地址
 */
@property(strong,nonatomic)NSString * URl;

/**
 *  对应图片Image
 */
@property(strong,nonatomic)UIImage * image;

-(id)initWithType:(ImageSource_Type)type Url:(NSString *)url;
@end