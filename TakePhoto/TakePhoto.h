//
//  TakePhoto.h
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright (c) 2016年 李彦鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakePhotosTableController.h"


//照片间距
#define photo_space  4
//每行照片数量
#define photo_perNum  4
//照片尺寸-缩略图
#define photo_width (([UIScreen mainScreen].bounds.size.width-(4 * (4 + 1)))/4)
//请求图片尺寸
#define image_width (([UIScreen mainScreen].bounds.size.width-(4 * (4 + 1)))/4)*2.0


typedef void(^ResultBlock)(NSArray * images, NSArray * dataArray);

@interface TakePhoto : NSObject

@property (strong, nonatomic) NSMutableArray * groups;


//选择完回调block
@property (copy, nonatomic) ResultBlock resultBlock;

//取消选择图片回调block
@property (copy, nonatomic) void (^ TakePhotoCancelBlock)(void);

//最大允许选择张数
@property (assign, nonatomic) NSInteger maxCount;

//单例初始化
+(TakePhoto *)sharePhoto;



#pragma  mark  ------照片选择入口------


/**
   多张图片
 
   弹出自定义照片选择界面<拍照入口/相册：多张，如多张图片上传>
   样式为：相册  相册-调起自定义相册

 @param controller 承载弹出界面视图对象
 @param count 最大可选张数,如果设为0则代表不限制张数
 @param resultBlock  结果回调   目前不抛出data
 */
+ (void)showCustomPhotosWithController:(UIViewController *)controller
                              maxCount:(NSInteger)count
                           resultBlock:(void(^)(NSArray * images, NSArray * dataArray))resultBlock;


/**
 
   单张图片-内部使用showClipCustomPhotosWithController封装
 
   弹出系统相册选择界面<拍照/相册：单张，如修改头像场景>
 
   样式为：拍照+相册  拍照-调起系统拍照；相册-调起系统相册

 @param controller 承载弹出界面视图对象
 @param allowEdit 是否允许编辑
 @param resultBlock  结果回调    目前不抛出data
 */
+ (void)showSystemPhotosWithController:(UIViewController *)controller
                            editEnable:(BOOL)allowEdit
                           resultBlock:(void(^)(NSArray * images, NSArray * dataArray))resultBlock;



#pragma  mark  ------Public-Methods------


/**
   调起拍照页面

 @param controller 依赖controller
 @param allowEdit 是否允许编辑
 @param animation 是否自定义转场动画
 */
+ (void)showCameraWithController:(UIViewController *)controller
                      editEnable:(BOOL)allowEdit
             animationTransition:(BOOL)animation;


/**
   保存图片

 @param image 保存的图片
 @param resultBlock 保存结果
 */
+ (void)saveImage:(UIImage *)image resultBlock:(void(^)(BOOL sucess))resultBlock;


#pragma  mark  ------Private-Methods内部使用------

//获取箭头图片
+(UIImage *)rightArrowImage;

+ (UIImage *)topArrowImage;

+ (UIImage *)cameraIconImage;

//获取已选择对应image
+(UIImage *)overLayerSelectedImage;

//获取未选择对应image
+(UIImage *)overLayerUnselectedImage;

//最大允许选择张数
+(NSInteger)maxPhotoCount;


//缩略图片参数配置
+(PHImageRequestOptions *)thumbImageOptions;


//完整图片参数配置
+(PHImageRequestOptions *)detailImageOptions;


//请求缩略图片
+ (PHImageRequestID)requestThumbImageForAsset:(PHAsset *)asset  resultHandler:(void (^)(UIImage * result, NSDictionary * info, BOOL isDegraded))resultHandler;

//请求完整图片
+ (PHImageRequestID)requestDetailImageForAsset:(PHAsset *)asset  resultHandler:(void (^)(UIImage *  result, NSDictionary *  info, BOOL isDegraded))resultHandler;



//获取缩略图数据
+ (PHImageRequestID)requestThumbImageDataForAsset:(PHAsset *)asset resultHandler:(void(^)(NSData *  imageData, NSString *  dataUTI, UIImageOrientation orientation, NSDictionary *  info))resultHandler;


//获取完整图片数据
+ (PHImageRequestID)requestDetailImageDataForAsset:(PHAsset *)asset resultHandler:(void(^)(NSData *  imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary * info))resultHandler;



@end
