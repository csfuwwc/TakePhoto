//
//  TakePhoto.h
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMTakePhotoTableController.h"
#import "HMTakePhotoNavController.h"

typedef void(^SelectPhotosBlock)(NSArray * photosArray,NSArray * modelsArray);

@interface TakePhotos : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) UIViewController * presentController;
@property (nonatomic,strong)ALAssetsLibrary * assetsLibrary;
/**
 *  照相返回数据在第一个数组中，相册返回数据在第二个数组中
 */
@property (nonatomic, copy) SelectPhotosBlock resultBlock;


/**
 *  弹出选择图片来源自定义视图
 *
 *  @param controller 承载弹出视图对象
 *  @param count      选择总张数
 *  @param array      已选择图片数字<DetailImageViewModel类型>
 */
-(void)showSheetWithController:(UIViewController *)controller selectCount:(int)count didHavePhotos:(NSArray *)array;
/**
 *  弹出选择图片来源系统视图
 *
 *  @param controller 承载弹出系统视图对象
 *  @param count      选择总张数
 *  @param array      已选择图片数字<DetailImageViewModel类型>
 */
-(void)showSystemSheetWithController:(UIViewController *)controller selectCount:(int)count didHavePhotos:(NSArray *)array;

/*从照片库中查找照片**/
-(void)takePhotosFromLibraryWithViewController:(UIViewController *)controller withCount:(int)count didHavePhotos:(NSArray *)array;
/*从相机中查找照片*/
-(void)takePhotoFromCameraWithController:(UIViewController *)controller sourceType:(UIImagePickerControllerSourceType)sourceType;

@end


@interface MySheetCustomBtn : UIButton
-(id)initWithFrame:(CGRect)frame    withTitle:(NSString *)title;
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color;
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color  withFont:(UIFont*)font;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end