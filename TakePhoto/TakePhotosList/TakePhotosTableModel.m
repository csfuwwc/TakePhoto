//
//  TakePhotosTableModel.m
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import "TakePhotosTableModel.h"

@implementation TakePhotosTableModel


-(NSString *)title
{
    NSString * title = nil;
    
    if (self.collection)
    {
        title = [self.collection localizedTitle];
    }
    else
    {
        title = @"相机胶卷";
    }
    
    return title ;
}

@end
