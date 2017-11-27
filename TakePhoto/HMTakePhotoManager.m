//
//  HMTakePhotoManager.m
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import "HMTakePhotoManager.h"

static HMTakePhotoManager * takePhotoManager;

@implementation HMTakePhotoManager
+(HMTakePhotoManager *)shareTakePhotoManager
{
    @synchronized(self)
    {
        if (!takePhotoManager)
        {
            takePhotoManager = [[HMTakePhotoManager alloc] init];
        }
        return takePhotoManager;
    }
}
+(id)alloc
{
    @synchronized(self)
    {
        if (!takePhotoManager)
        {
            takePhotoManager = [super alloc];
        }
        return takePhotoManager;
    }
}
-(id)init
{
    if (self = [super init])
    {
        myIndex = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
-(void)dealloc
{
    myIndex = nil;
    takePhotoManager = nil;
}
-(void)addIndex:(NSInteger)index
{
    if (![myIndex containsObject:@(index)])
    {
        [myIndex addObject:@(index)];
    }
}
-(void)removeIndex:(NSInteger)index
{
    if ([myIndex containsObject:@(index)])
    {
        [myIndex removeObject:@(index)];
    }
}
-(void)removeAllInex
{
    [myIndex removeAllObjects];
}
-(NSInteger)numberOfAllIndex
{
    return [myIndex count];
}
@end
