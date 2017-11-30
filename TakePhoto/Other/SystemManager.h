//
//  SystemManager.h
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Masonry.h"
#import "UIView+More.h"
#import "UIImage+More.h"
#import "MDPresentTransition.h"

#define iOS8OrLater [UIDevice currentDevice].systemVersion.floatValue >= 8.0
#define iOS9OrLater [UIDevice currentDevice].systemVersion.floatValue >= 9.0
#define iOS11OrLater @available(iOS 11.0, *)
#define UnderiOS8   [UIDevice currentDevice].systemVersion.floatValue < 8.0
#define UnderiOS9   [UIDevice currentDevice].systemVersion.floatValue < 9.0


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MDRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MDGlobalButtonUseless   UIColorFromRGB(0x7A8087)  //按钮不可用颜色
#define MDGlobalBlack           MDRGBColor(34, 44, 55)          //#222c37
#define MDGlobalGray            MDRGBColor(122, 128, 135)       //#7a8087
#define MDGlobalLightWhite      MDRGBColor(188, 191, 195)       //#bcbfc3
#define MDGlobalSeparateColor   MDRGBColor(222, 224, 225)       //#dee0e1
#define MDGlobalWhite           MDRGBColor(242, 243, 243)
#define MDGlobalPlaceholder     MDRGBColor(167, 173, 163)
#define MDGlobalSeparateColorC  MDRGBColor(228, 229, 226)
#define MDGlobalHomeBgColor     MDRGBColor(248, 248, 249)       //首页卡片内部颜色
#define MDGlobalLink            MDRGBColor(87, 107, 149)        //#576b95
#define MDGlobalBlue            MDRGBColor(33, 182, 199)        //#21b6c7
#define MDGlobalGreen           MDRGBColor(0, 214, 166)         //#00d6a6

//Objec_key，宏定义中一个#标示把参数转换为字符串，<单独一个#，则表示对这个变量替换后，再加双引号引起来>
#define  ObjcKey(key)  static const char * key = #key;



#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_WIDTH == 375.0f && SCREEN_HEIGHT == 812.0f)

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
