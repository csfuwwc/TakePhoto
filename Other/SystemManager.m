//
//  SystemManager.m
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import "SystemManager.h"
#import <objc/runtime.h>

/**********系统权限************/
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#ifdef  NSFoundationVersionNumber_iOS_8_x_Max
#import <CoreTelephony/CTCellularData.h>
#endif

#import <UIKit/UIKit.h>



@implementation SystemManager

#pragma mark ------初始化------

+ (SystemManager *)shareManager
{
    static SystemManager * manager = nil;
    static dispatch_once_t  onecToken;
    
    dispatch_once(&onecToken, ^{
        
        manager = [[SystemManager alloc] init];
        
    });
    
    return manager;
}


#pragma mark ------系统权限------



//相册访问权限<支持7.0+>
+(BOOL)detectionPhotoState:(void(^)(void))authorizedBlock
{
    BOOL isAvalible = NO;
    
    if (iOS8OrLater)
    {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        
        //未进行授权选择
        if (authStatus == PHAuthorizationStatusNotDetermined)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized)
                {
                    if (authorizedBlock)
                    {
                        authorizedBlock();
                    }
                }
            }];
        }
        //授权允许
        else if (authStatus == PHAuthorizationStatusAuthorized)
        {
            isAvalible = YES;
            
            if (authorizedBlock)
            {
                authorizedBlock();
            }
        }
        else
        {
            [SystemManager openSettingPagewithMessage:@"照片"];
        }
    }
    else
    {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        
        //授权允许
        if (authStatus == ALAuthorizationStatusAuthorized)
        {
            isAvalible = YES;
            
            if (authorizedBlock)
            {
                authorizedBlock();
            }
        }
        else
        {
            [SystemManager openSettingPagewithMessage:@"照片"];
        }
    }
    
    
    
    
    
    return isAvalible;
    
}
//相机访问权限<支持7.0+>
+(BOOL)detectionCameraState:(void(^)(void))authorizedBlock
{
    BOOL isAvalible = NO;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //未进行授权选择
    if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted)
            {
                if (authorizedBlock)
                {
                    authorizedBlock();
                }
            }
        }];
    }
    //授权允许
    else if (authStatus == AVAuthorizationStatusAuthorized)
    {
        isAvalible = YES;
        
        if (authorizedBlock)
        {
            authorizedBlock();
        }
    }
    else
    {
        [SystemManager openSettingPagewithMessage:@"相机"];
        
    }
    
    return isAvalible;
    
}


//跳转到设置界面
+(void)openSettingPagewithMessage:(NSString *)message
{
    
    //定位服务
    
    if (iOS8OrLater)
    {
        [[SystemManager shareManager] showSystemAlertwithTitle:@"提示" message:[NSString stringWithFormat:@"为了更好的体验功能，请到设置页面->隐私->%@，将摩点对应开关开启",message] cancelButtonTitle:@"下次提醒" otherButtonTitles:@"去设置" baseController:nil resultBlock:^(NSInteger index) {
            
            if (index == 1)
            {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            
        }];
        
    }
    //iOS8以下
    else
    {
        [[SystemManager shareManager] showSystemAlertwithTitle:@"提示" message:[NSString stringWithFormat:@"为了更好的体验功能，请到设置页面->隐私->%@，将对应开关开启",message] cancelButtonTitle:@"我知道了" otherButtonTitles:nil baseController:nil resultBlock:nil];
    }
    
}


#pragma mark  ------ShowAlertView------

//默认左侧取消/删除，右侧确定样式
static char * AlertBlockKey = "AlertBlockKey";

-(void)showSystemAlertwithTitle:(NSString *)title message:(NSString *)message  cancelButtonTitle:(NSString *)cancelBtnTitle otherButtonTitles:(NSString *)otherTitle baseController:(UIViewController *)controller  resultBlock:(AlertBlock)block
{
    
    //如果为低版本或者没有依赖controller
    if (UnderiOS9)
    {
        objc_setAssociatedObject(self, AlertBlockKey,block , OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitles:otherTitle, nil];
        [alert show];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        if (cancelBtnTitle)
        {
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                block([alert.actions indexOfObject:action]);
                
            }];
            [alert addAction:cancelAction];
            
        }
        
        if (otherTitle)
        {
            UIAlertAction * makeAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                block([alert.actions indexOfObject:action]);
                
            }];
            
            [alert addAction:makeAction];
        }
        
        [controller presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AlertBlock block = objc_getAssociatedObject(self, AlertBlockKey);
    if (block)
    {
        block(buttonIndex);
    }
}


#pragma mark ******计算label大小******

+(CGSize)getSizeWithWidth:(CGFloat)width content:(NSString *)str font:(int)font lineSpace:(CGFloat)space
{
    
    if (str.length == 0 || !str) {
        
        return CGSizeZero;
    }
    
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = space;
    
    
    NSDictionary * attDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor],[UIFont systemFontOfSize:font],style, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName,NSParagraphStyleAttributeName, nil]];
    
    
    
    
    
    
    NSAttributedString * attStr = [[NSAttributedString alloc]initWithString:str attributes:attDic];
    
    NSRange range = NSMakeRange(0, attStr.length);
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[attStr attributesAtIndex:0 effectiveRange:&range]];
    
    
    CGRect  rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:Nil];
    
    
    
    return rect.size;
    
}


@end
