//
//  TakePhotosTableModel.h
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface TakePhotosTableModel : NSObject

@property (strong, nonatomic) PHAssetCollection * collection;

@property (copy, nonatomic) PHFetchResult * result;


@property (copy, nonatomic) NSString * title;

@property (strong, nonatomic) UIImage * image;

@end
