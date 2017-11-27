//
//  TakePhotoModel.m
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import "TakePhotoModel.h"
#import "TakePhoto.h"

@implementation TakePhotoModel

-(id)init
{
    if (self = [super init])
    {
        _selected = NO;
        _index = 0;
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    if (_selected != selected)
    {
        if (selected)
        {
            if (!self.shouldSelectBlock())
            {
                return;
            }
        }
        
        _selected = selected;
        
        //被选中
        if (_selected)
        {
            if (self.didSelectedBlock)
            {
                self.didSelectedBlock(self);
            }
        }
        //取消选中
        else
        {
            if (self.didDeselectedBlock)
            {
                self.didDeselectedBlock(self);
            }
        }
    }
}



@end
