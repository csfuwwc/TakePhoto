//
//  SystemManager.h
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^AlertBlock)(NSInteger index);



@interface SystemManager : NSObject

#pragma mark ------初始化-------


+ (SystemManager *)shareManager;


#pragma mark ------系统权限------


/**
 检测相册权限
 
 @param authorizedBlock 授权成功回调
 
 @return 是否授权
 */
+(BOOL)detectionPhotoState:(void(^)(void))authorizedBlock;


/**
 检测相机权限
 
 @param authorizedBlock 授权成功回调
 
 @return 是否授权
 */
+(BOOL)detectionCameraState:(void(^)(void))authorizedBlock;



/**
 *  计算label大小
 *
 *  @param width 宽度
 *  @param str   内容
 *  @param font  字体
 *  @param space 行间距
 *
 *  @return 尺寸
 */
+(CGSize)getSizeWithWidth:(CGFloat)width content:(NSString *)str font:(int)font lineSpace:(CGFloat)space;


+(void)customUIImagePickerNavBar:(UINavigationBar *)pickerNavBar;




@end
