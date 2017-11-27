//
//  HMTakePhotoCell.h
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTakePhotoModel.h"


typedef void(^SingelPhotoBlock)(UIImage * image,DetailImageViewModel * model);
@interface HMTakePhotoCell : UITableViewCell

@property(assign,nonatomic)BOOL shouldShowOverView;

/**
 *  选择单张图片block回调
 */
@property(strong,nonatomic)SingelPhotoBlock  singelBlock;

- (void)setAssets:(NSArray *)assets;

@end


//cell上方覆盖选中状态imageview
@interface OverLayerTakePhotoImageView : UIImageView

//是否已被选中
@property(assign,nonatomic)BOOL  selected;

@end