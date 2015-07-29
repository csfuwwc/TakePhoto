//
//  ViewController.m
//  TakePhoto
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 李彦鹏. All rights reserved.
//

#import "ViewController.h"
#import "TakePhotos.h"
@interface ViewController ()
{
    TakePhotos * takePhoto;
}
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

- (IBAction)show:(id)sender {
    
    takePhoto = [[TakePhotos alloc] init];
    [takePhoto showSheetWithController:self selectCount:5 didHavePhotos:nil];
    takePhoto.resultBlock = ^(NSArray * photosArray,NSArray * modelsArray){
        
    };

    
}
@end
