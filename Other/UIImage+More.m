//
//  UIImage+More.m
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import "UIImage+More.h"

@implementation UIImage(More)

- (NSData *)prepareImageDataForUpload
{
    NSData * originData = UIImageJPEGRepresentation([UIImage fixOrientation:self], 1.0);
    
    //如果大于3M-已测试，3M以上压缩精度损失微小
    if ([originData length]>3000000)
    {
        originData = nil;
        
        return UIImageJPEGRepresentation(self, 0.3);
        
    }
    else
    {
        
        return originData;
    }
    
}



+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
    {
        return aImage;
    }
    
    //resize
    CGFloat imageWidth = aImage.size.width;
    CGFloat imageHeight = aImage.size.height;

    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, imageHeight);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imageHeight);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageWidth, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imageHeight, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, imageWidth, imageHeight,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imageHeight,imageWidth), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imageWidth,imageHeight), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//根据设定最大宽高规则压缩尺寸

+ (UIImage *)compressImageByMainScreen:(UIImage*)aImage
{
    
    float orgi_width = aImage.size.width;
    float orgi_height = aImage.size.height;
    
    
    //设置 最大尺寸1000*1000
    if (MAX(orgi_width, orgi_height)>10000)
    {
        if (orgi_width >= orgi_height)
        {
            //宽大于高－按照宽缩放比例压缩
            orgi_height = orgi_height * 10000.0/orgi_width;
            orgi_width = 10000.0;
        }
        else
        {
            //高大于宽－按照高缩放比例压缩
            
            orgi_width = orgi_width * 10000.0/orgi_height;
            orgi_height = 10000.0;
        }
        
        
        CGRect rect = CGRectMake(0.0, 0.0, orgi_width, orgi_height);
        
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
        [aImage drawInRect:rect];
        UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        aImage = nil;
        
        return thumbnail;
    }
    else
    {
        
        return aImage;
    }
    
}

@end
