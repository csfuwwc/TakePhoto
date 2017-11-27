//
//  TakePhoto.m
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import "TakePhotos.h"
#import "BoomPresentView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAudioFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation TakePhotos

//跳转到设置界面
-(void)openSettingPagewithMessage:(NSString *)message
{
    //iOS8以上
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"为了更好的体验功能，请到设置页面->隐私->%@，将Dreamore对应开关开启",message] delegate:self cancelButtonTitle:@"下次提醒" otherButtonTitles:@"去设置", nil];
        [alert show];
        
    }
    //iOS8以下
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"为了更好的体验功能，请到设置页面->隐私->%@，将Dreamore对应开关开启",message] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        
        //定位服务   照片  麦克风  相机
        
        
        
    }
    
}
/**
 *  相册访问权限
 *
 *  @return
 */
-(BOOL)detectionPhotoState
{
    BOOL isAvalible = NO;
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    
    if (authStatus == ALAuthorizationStatusAuthorized)
    {
        isAvalible = YES;
    }
    else if (authStatus == ALAuthorizationStatusDenied)
    {
        
        [self openSettingPagewithMessage:@"照片"];
        
    }
    else
    {
        isAvalible = YES;
    }
    return isAvalible;
    
}
/**
 *  相机访问权限
 *
 *  @return
 */
-(BOOL)detectionCameraState
{
    BOOL isAvalible = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized)
    {
        isAvalible = YES;
    }
    else if (authStatus == AVAuthorizationStatusDenied)
    {
        [self openSettingPagewithMessage:@"相机"];
        
    }
    else
    {
        isAvalible = YES;
    }
    return isAvalible;
    
}
-(void)showSheetWithController:(UIViewController *)controller selectCount:(int)count didHavePhotos:(NSArray *)array
{
    
    self.presentController = controller;
    
    BoomPresentView * sheet = [[BoomPresentView alloc] initWithSuperView:controller.view withTitle:@"" withDes:@"" withButtonNames:@[@"拍照",@"从手机相册选择"]];
    [sheet show];
    
    
    __weak TakePhotos * weakSelf = self;
    __weak BoomPresentView * weakSheet = sheet;
    sheet.buttonBlock = ^(NSInteger index){
        
        if (index==0)
        {
            NSLog(@"相机");
            [weakSelf  takePhotoFromCameraWithController:weakSelf.presentController sourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if (index==1)
        {
            NSLog(@"相册");
            
            [weakSelf takePhotosFromLibraryWithViewController:weakSelf.presentController withCount:count didHavePhotos:array];
            
        }
        
        [weakSheet dismiss];
    };
}


/**
 *  弹出选择图片来源系统视图
 *
 *  @param controller 承载弹出系统视图对象
 *  @param count      选择总张数
 *  @param array      已选择图片数字<DetailImageViewModel类型>
 */
-(void)showSystemSheetWithController:(UIViewController *)controller selectCount:(int)count didHavePhotos:(NSArray *)array
{
    self.presentController = controller;
    
    BoomPresentView * sheet = [[BoomPresentView alloc] initWithSuperView:controller.view withTitle:@"" withDes:@"" withButtonNames:@[@"拍照",@"从手机相册选择"]];
    [sheet show];
    
    
    __weak TakePhotos * weakSelf = self;
    __weak BoomPresentView * weakSheet = sheet;
    sheet.buttonBlock = ^(NSInteger index){
        
        if (index==0)
        {
            NSLog(@"相机");
            [weakSelf  takePhotoFromCameraWithController:weakSelf.presentController sourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if (index==1)
        {
            NSLog(@"相册");
            
            [weakSelf takePhotoFromCameraWithController:controller sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
        }
        
        [weakSheet dismiss];
    };
}

- (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

/*从相机中查找照片*/
-(void)takePhotoFromCameraWithController:(UIViewController *)controller sourceType:(UIImagePickerControllerSourceType)sourceType
{
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![self detectionCameraState])
    {
        return;
    }
    if (![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate =self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjects:
                                               [NSArray arrayWithObjects:[UIColor whiteColor],[UIFont boldSystemFontOfSize:18], nil] forKeys:
                                               [NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    picker.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"返回icon"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    picker.navigationBar.backIndicatorImage = image;
    picker.navigationBar.backIndicatorTransitionMaskImage = image;
    
//    picker.navigationBar.shadowImage = [self imageWithColor:[ZBTheme navColor]];
    [picker.navigationBar setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forBarMetrics:UIBarMetricsDefault];
    [controller presentViewController:picker animated:YES completion:^{
    }];
}

//根据颜色创建图片
-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak TakePhotos * weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!image)
        {
            image = [info objectForKeyedSubscript:UIImagePickerControllerOriginalImage];
            
            image = [weakSelf squareImageFromImage:image scaledToSize:400];
        }
        
        if (weakSelf.resultBlock) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            weakSelf.resultBlock(@[image],@[]);
        }
    }];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  剪切图片为正方形
 *
 *  @param image   原始图片比如size大小为(400x200)pixels
 *  @param newSize 正方形的size比如400pixels
 *
 *  @return 返回正方形图片(400x400)pixels
 */
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height)
    {
        //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    }
    else
    {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    //创建画板为(400x400)pixels
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//保原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


/*从相册选择图片*/
-(void)takePhotosFromLibraryWithViewController:(UIViewController *)controller withCount:(int)count didHavePhotos:(NSArray *)array
{
    if (![self detectionPhotoState])
    {
        return;
    }
    
    self.presentController = controller;

    
    /*
     1.ALAssetsGroup：指代一个相册。
     
     2.ALAsset：每一个ALAsset代表一个单一资源文件（也就是一张图片，或者一个视频文件）
     
     3.ALAssetRepresentation：ALAssetRepresentation封装了ALAsset，包含了一个资源文件中的很多属性。（可以说是ALAsset的不同的表示方式，本质上都表示同一个资源文件）
     */
    
    self.assetsLibrary = [self defaultAssetsLibrary];
    NSMutableArray *groups = [NSMutableArray arrayWithCapacity:0];

    
    __weak TakePhotos * weakSelf = self;
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            [weakSelf displayPickerForGroup:[groups objectAtIndex:0] withCount:(int)count didHavePhotos:(NSArray *)array];
        }
    } failureBlock:^(NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"A problem occured %@", [error description]);
        // an error here means that the asset groups were inaccessable.
        // Maybe the user or system preferences refused access.
    }];
}
- (void)displayPickerForGroup:(ALAssetsGroup *)group withCount:(int)count  didHavePhotos:(NSArray *)array
{
    HMTakePhotoTableController *tablePicker = [[HMTakePhotoTableController alloc] initWithStyle:UITableViewStylePlain];
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];

    tablePicker.maxSelectedCount = count;
    tablePicker.didHaveCount = (int)[array count];
    tablePicker.DidHavePhotos = array;
    
    __weak TakePhotos * weakSelf = self;
    tablePicker.finishPhotoBlock = ^(NSArray * imagesArray,NSArray * modelsArray)
    {
        if (weakSelf.resultBlock)
        {
            weakSelf.resultBlock(imagesArray,modelsArray);
        }
    };
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:tablePicker];
    
    //HMTakePhotoNavController *elcPicker = [[HMTakePhotoNavController alloc] initWithRootViewController:tablePicker];


    

    
    [self.presentController presentViewController:nav animated:YES completion:nil];
}

@end


@implementation MySheetCustomBtn
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color  withFont:(UIFont*)font
{
    if (self = [self init])
    {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        lab.textColor =  color;
        lab.text = title;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = font;
        lab.userInteractionEnabled = NO;
        [self addSubview:lab];
        
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title   withColor:(UIColor *)color
{
    if (self = [self init])
    {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        lab.textColor =  color;
        lab.text = title;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16];
        lab.userInteractionEnabled = NO;
        [self addSubview:lab];
        
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame  withTitle:(NSString *)title
{
    if (self = [self init])
    {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        lab.textColor =  [UIColor blackColor];
        lab.text = title;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16];
        lab.userInteractionEnabled = NO;
        [self addSubview:lab];
        
    }
    return self;
}
-(id)init
{
    if (self=[super init])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[self imageWithColor:backgroundColor] forState:state];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end