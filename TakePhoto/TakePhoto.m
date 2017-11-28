//
//  TakePhoto.m
//  MyCustomTools
//  https://objccn.io/issue-21-4/
//  Created by 李彦鹏 on 16/1/9.
//  Copyright (c) 2016年 李彦鹏. All rights reserved.
//

#import "TakePhoto.h"
#import "BoomPresentView.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface TakePhoto ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIImagePickerController * picker;



@property (copy, nonatomic) void(^SaveImageToPhotoBlock)(BOOL sucess);

@end


@implementation TakePhoto

+(TakePhoto *)sharePhoto
{
    static TakePhoto * photo = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        photo = [[TakePhoto alloc] init];
        
        photo.groups = [NSMutableArray arrayWithCapacity:0];
        
        photo.picker = [[UIImagePickerController alloc]init];
        photo.picker.delegate = photo;
        
        [SystemManager customUIImagePickerNavBar:photo.picker.navigationBar];

        
    });
    
    return photo;
}


#pragma mark  ------选择照片入口------

//自定义选取照片入口－支持选择多张
+ (void)showCustomPhotosWithController:(UIViewController *)controller maxCount:(NSInteger)count resultBlock:(void (^)(NSArray *, NSArray *))resultBlock
{
    
    __weak typeof(self)weakSelf = self;
    
    
    //如果无相册访问权限
    [SystemManager detectionPhotoState:^{
        
        //自定义相册
        [weakSelf takePhotoFromCustomLibraryWithController:controller maxCount:count resultBlock:resultBlock];
        
    }];
    
}

//系统选择照片入口－选择一张
+ (void)showSystemPhotosWithController:(UIViewController *)controller editEnable:(BOOL)allowEdit resultBlock:(void (^)(NSArray *, NSArray *))resultBlock
{
    
    BoomPresentView * sheet = [[BoomPresentView alloc] initWithSuperView:controller.view withTitle:@"" withDes:@"" withButtonNames:@[@"拍照",@"从手机相册选择"]];
    [sheet show];
    
    sheet.buttonBlock = ^(NSInteger index) {
        
        switch (index)
        {
            case 0:
            {
                //拍照
                
                [TakePhoto showCameraWithController:controller editEnable:allowEdit animationTransition:YES];
            }
                break;
            case 1:
            {
                //照片
                
                [TakePhoto takePhotoFromSystemCameraWithController:controller sourceType:UIImagePickerControllerSourceTypePhotoLibrary editEnable:allowEdit animationTransition:YES];
                
            }
                break;
            default:
                break;
        }
        
        
    };
    
}


+ (void)showCameraWithController:(UIViewController *)controller
                      editEnable:(BOOL)allowEdit
             animationTransition:(BOOL)animation
{
    [TakePhoto takePhotoFromSystemCameraWithController:controller sourceType:UIImagePickerControllerSourceTypeCamera editEnable:allowEdit animationTransition:YES];
}

#pragma mark <调用自定义相册-实现>

//调用自定义相册
+ (void)takePhotoFromCustomLibraryWithController:(UIViewController *)controller maxCount:(NSInteger)count resultBlock:(void (^)(NSArray *, NSArray *))resultBlock
{
 
    //选择照片结果回调
    [TakePhoto sharePhoto].resultBlock = resultBlock;
    
    //最大允许选择张数
    [TakePhoto sharePhoto].maxCount = count>0?count:MAXFLOAT;

    
    //清空相册数组
    [[TakePhoto sharePhoto].groups removeAllObjects];
    
    
    PHFetchOptions * option = [[PHFetchOptions alloc] init];
    
    //只显示图片
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
    
    //按照创建日期倒序排序
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];

    //系统相册－相机胶卷
    PHFetchResult * systemAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];

    [systemAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PHFetchResult * result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        if (result.count > 0)
        {
            TakePhotosTableModel * model = [[TakePhotosTableModel alloc] init];
            model.collection = collection;
            model.result = result;
            
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary)
            {
                //如果是相机胶卷，放在首位
                [[TakePhoto sharePhoto].groups insertObject:model atIndex:0];;
            }
            else
            {
                [[TakePhoto sharePhoto].groups addObject:model];
            }
        }
        
    }];
    
    
    
    //用户自建相册
    PHFetchResult * userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
       
        
        PHFetchResult * result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        if (result.count > 0)
        {
            TakePhotosTableModel * model = [[TakePhotosTableModel alloc] init];
            model.collection = collection;
            model.result = result;
            [[TakePhoto sharePhoto].groups addObject:model];
        }
    }];



    //相册内照片页面
    TakePhotosController * detailVC = [[TakePhotosController alloc] init];
    detailVC.model = [[TakePhoto sharePhoto].groups objectAtIndex:0];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    [SystemManager customUIImagePickerNavBar:nav.navigationBar];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:nav animated:YES completion:nil];
    });
    


}

#pragma mark <调用系统相册/拍照-实现>

//调用系统相册/系统摄像头
+ (void)takePhotoFromSystemCameraWithController:(UIViewController *)controller sourceType:(UIImagePickerControllerSourceType)sourceType editEnable:(BOOL)allowEdit animationTransition:(BOOL)animation
{
    
    //如果设备不支持拍照，则从照片库选择图片
    if (![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //相机访问权限
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [SystemManager detectionCameraState:^{
            
            [self showImagePicker:allowEdit sourceType:sourceType baseController:controller animationTransition:animation];
            
        }];
    }
    //相册访问权限
    else if (sourceType==UIImagePickerControllerSourceTypePhotoLibrary)
    {
        //如果无相册访问权限
        [SystemManager detectionPhotoState:^{
            
            [self showImagePicker:allowEdit sourceType:sourceType baseController:controller animationTransition:animation];
            
        }];
    }
    
    
}

+ (void)showImagePicker:(BOOL)allowEdit sourceType:(UIImagePickerControllerSourceType)
type baseController:(UIViewController *)controller animationTransition:(BOOL)animation
{
    [TakePhoto sharePhoto].picker.allowsEditing = allowEdit;
    
    [TakePhoto sharePhoto].picker.sourceType = type;
    
    
    
    //如果页面弹起键盘时，不在主线程调用，会直接crash
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [controller.view endEditing:YES];
        
        
        if (!animation)
        {
            //如果是默认弹起
            
            [TakePhoto sharePhoto].picker.transitioningDelegate = nil;
            [TakePhoto sharePhoto].picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [controller presentViewController:[TakePhoto sharePhoto].picker animated:YES completion:nil];
        }
        else
        {
            //如果是自定义相册-自定义转场动画
            
            [TakePhoto sharePhoto].picker.transitioningDelegate = [TakePhoto sharePhoto];
            [TakePhoto sharePhoto].picker.modalPresentationStyle = UIModalPresentationCustom;
            [controller presentViewController:[TakePhoto sharePhoto].picker animated:YES completion:nil];
        }
        
    });
    
}


#pragma mark  ------保存图片入口------

+ (void)saveImage:(UIImage *)image resultBlock:(void (^)(BOOL))resultBlock
{
    [self saveImage:image showMessage:YES resultBlock:resultBlock];
}

+ (void)saveImage:(UIImage *)image  showMessage:(BOOL)show resultBlock:(void (^)(BOOL))resultBlock
{
    [SystemManager detectionPhotoState:^{
        
        [TakePhoto sharePhoto].SaveImageToPhotoBlock = resultBlock;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            UIImageWriteToSavedPhotosAlbum(image, [TakePhoto sharePhoto], show?@selector(image:didFinishSavingWithError:contextInfo:):nil, nil);

            /*
            if ([image isKindOfClass:[YYImage class]])
            {
                YYImage * img = (YYImage *)image;
                
                if (img.animatedImageType == YYImageTypeGIF)
                {
                    [self saveGifImageData:img.animatedImageData];
                }
                else
                {
                    UIImageWriteToSavedPhotosAlbum(image, [TakePhoto sharePhoto], show?@selector(image:didFinishSavingWithError:contextInfo:):nil, nil);
                }
                
            }
            else
            {
                 UIImageWriteToSavedPhotosAlbum(image, [TakePhoto sharePhoto], show?@selector(image:didFinishSavingWithError:contextInfo:):nil, nil);
            }
             */
  
        });
    }];
}

+ (void)saveGifImageData:(NSData *)imageData
{
    if (iOS9OrLater)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetResourceCreationOptions * options = [[PHAssetResourceCreationOptions alloc] init];
            options.shouldMoveFile = YES;
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:imageData options:options];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
           
            dispatch_sync(dispatch_get_main_queue(), ^{
               
                [[TakePhoto sharePhoto] image:nil didFinishSavingWithError:error contextInfo:nil];
                
            });
            
        }];
    }
    else
    {
        
        ALAssetsLibrary  * library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [[TakePhoto sharePhoto] image:nil didFinishSavingWithError:error contextInfo:nil];
                
            });
        }];
    }
}

//保存图片到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        NSLog(@"保存失败");
    }
    else
    {
        NSLog(@"已保存至相册");
    }
    
    if ([TakePhoto sharePhoto].SaveImageToPhotoBlock)
    {
        [TakePhoto sharePhoto].SaveImageToPhotoBlock(error?NO:YES);
    }
}




#pragma mark ------UIImagePickerControllerDelegate------
//选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image)
    {
        //取图
        image = [info objectForKeyedSubscript:UIImagePickerControllerOriginalImage];
    }

 
    if ([TakePhoto sharePhoto].resultBlock)
    {
        [TakePhoto sharePhoto].resultBlock(@[image],nil);
    }
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (picker.presentingViewController)
        {
            [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            //如果是相机
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
            {
                
                
                if (picker.presentingViewController.presentingViewController)
                {
                    [picker.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
                else if (picker.presentingViewController)
                {
                    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    [picker dismissViewControllerAnimated:YES completion:nil];
                }
            }
            else
            {
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    });


}


#pragma  mark  ------Public-Methods------


//获取箭头图片
+ (UIImage *)rightArrowImage
{
    return [TakePhoto bundleImageNamed:@"right_arrow@3x"];
}

+ (UIImage *)topArrowImage
{
    return [TakePhoto bundleImageNamed:@"top_arrow@3x"];
}

//获取已选择对应image
+ (UIImage *)overLayerSelectedImage
{
    return [TakePhoto bundleImageNamed:@"photo_selected@3x"];
}

//获取未选择对应image
+ (UIImage *)overLayerUnselectedImage
{
    return  [TakePhoto bundleImageNamed:@"photo_unselected@3x"];
}


+ (UIImage *)bundleImageNamed:(NSString *)imageName
{
    NSBundle *bundle = [NSBundle bundleForClass:[TakePhoto class]];
    NSURL *url = [bundle URLForResource:@"TakePhoto" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    UIImage* infoImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:imageName ofType:@"png"]];
    
    return infoImage;
}




//返回最大允许选择张数
+ (NSInteger)maxPhotoCount
{
    return [TakePhoto sharePhoto].maxCount;
}


//缩略图片参数配置
+ (PHImageRequestOptions *)thumbImageOptions
{
    /*
    http://blog.csdn.net/jader_y/article/details/50382132
    PHImageRequestOptions有以下几个重要的属性:
    synchronous：指定请求是否同步执行。
    resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
    deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
    normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。
    */
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];

    //图片缩放策略
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    
    return requestOptions;
}

//完整图片参数配置
+(PHImageRequestOptions *)detailImageOptions
{
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
        
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    return options;
}





//获取缩略图片
+ (PHImageRequestID)requestThumbImageForAsset:(PHAsset *)asset  resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info, BOOL isDegraded))resultHandler
{
    return [self requestPhotoImageForAsset:asset targetSize:CGSizeMake(image_width, image_width) contentMode:PHImageContentModeAspectFill options:[TakePhoto thumbImageOptions] resultHandler:resultHandler];
}


//获取完整图片
+ (PHImageRequestID)requestDetailImageForAsset:(PHAsset *_Nullable)asset  resultHandler:(void (^_Nullable)(UIImage * _Nonnull result, NSDictionary * _Nullable info, BOOL isDegraded))resultHandler;
{
    //CGSizeMake(ScreenWidth * 2, ScreenWidth * asset.pixelHeight/asset.pixelWidth * 2)
    
    return [self requestPhotoImageForAsset:asset targetSize:CGSizeMake(10000, 10000) contentMode:PHImageContentModeAspectFit options:[TakePhoto detailImageOptions] resultHandler:resultHandler];
}

//获取图片
+(PHImageRequestID)requestPhotoImageForAsset:(PHAsset *)asset targetSize:(CGSize)size contentMode:(PHImageContentMode)mode options:(PHImageRequestOptions *)options resultHandler:(void (^) (UIImage * result, NSDictionary * info, BOOL isDegraded))resultHandler
{
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:mode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        
        if (downloadFinined && result)
        {
            result = [UIImage fixOrientation:result];
            
            if (resultHandler)
            {
                resultHandler(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            
            result = nil;
        }
    }];
    
    return requestID;
}


//获取缩略图数据
+ (PHImageRequestID)requestThumbImageDataForAsset:(PHAsset *)asset resultHandler:(void(^)(NSData *__nullable imageData, NSString *__nullable dataUTI, UIImageOrientation orientation, NSDictionary *__nullable info))resultHandler
{
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:[TakePhoto thumbImageOptions] resultHandler:resultHandler];
}


//获取完整图片数据
+ (PHImageRequestID)requestDetailImageDataForAsset:(PHAsset *)asset resultHandler:(void(^)(NSData *__nullable imageData, NSString *__nullable dataUTI, UIImageOrientation orientation, NSDictionary *__nullable info))resultHandler
{
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:[TakePhoto detailImageOptions] resultHandler:resultHandler];
}





- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return [MDPresentTransition transitonType:Transiton_Camera_Present];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [MDPresentTransition transitonType:Transiton_Camera_Dissmiss];
}





@end
