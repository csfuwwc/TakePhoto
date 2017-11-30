//
//  ViewController.m
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import "ViewController.h"
#import "TakePhoto.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhotoBtnClick:(id)sender
{
    
    [TakePhoto showSystemPhotosWithController:self editEnable:YES resultBlock:^(NSArray *images, NSArray *dataArray) {
        
    }];
    
}
- (IBAction)customPhoto:(id)sender
{
    [TakePhoto showCustomPhotosWithController:self maxCount:5 resultBlock:^(NSArray *images, NSArray *dataArray) {
        
    }];
    
}

@end
