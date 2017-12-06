//
//  UIImage+More.h
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(More)

- (NSData *)prepareImageDataForUpload;

+ (UIImage *)fixOrientation:(UIImage *)aImage;


@end
