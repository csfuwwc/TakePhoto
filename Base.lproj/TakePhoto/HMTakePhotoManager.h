//
//  HMTakePhotoManager.h
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMTakePhotoManager : NSObject
{
    NSMutableArray * myIndex;
}
+(HMTakePhotoManager *)shareTakePhotoManager;
-(void)addIndex:(NSInteger)index;
-(void)removeIndex:(NSInteger)index;
-(void)removeAllInex;
-(NSInteger)numberOfAllIndex;

@end
