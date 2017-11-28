//
//  TakePhotosCameraCell.m
//  MyCustomTools
//
//  Created by 李彦鹏 on 2017/6/23.
//  Copyright © 2017年 李彦鹏. All rights reserved.
//

#import "TakePhotosCameraCell.h"

@interface TakePhotosCameraCell()

@property (weak, nonatomic) IBOutlet UIImageView *cameraIconImageView;

@end

@implementation TakePhotosCameraCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.cameraIconImageView setImage:[TakePhoto cameraIconImage]];
}

@end
