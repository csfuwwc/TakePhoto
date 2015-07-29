//
//  HMTakePhotoTableController.h
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HMTakePhotoCell.h"



typedef void(^FinishPhotoSelectBlock)(NSMutableArray * imagesArray,NSMutableArray * modelsArray);
@interface HMTakePhotoTableController : UITableViewController
/**
 *  最大允许选择图片张数
 */
@property(assign,nonatomic)int maxSelectedCount;

/**
 *  已经选择图片张数
 */
@property(assign,nonatomic)int didHaveCount;

/**
 *  已选图片数组
 */
@property(strong,nonatomic)NSArray * DidHavePhotos;

@property(strong,nonatomic)ALAssetsGroup * assetGroup;
@property(strong,nonatomic)NSMutableArray * elcAssets;

/**
 *  完成相片选择block回调
 */
@property(strong,nonatomic)FinishPhotoSelectBlock finishPhotoBlock;
@end


