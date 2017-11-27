//
//  ViewController.m
//  TakePhotoDemo
//
//  Created by 李彦鹏 on 2017/11/27.
//  Copyright © 2017年 csfuwwc. All rights reserved.
//

#import "ViewController.h"
#import "TakePhotos.h"

@interface ViewController ()

@property (strong, nonatomic) TakePhotos * takePhoto;

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
    
    self.takePhoto = [[TakePhotos alloc] init];
    [self.takePhoto showSheetWithController:self selectCount:5 didHavePhotos:nil];
    self.takePhoto.resultBlock = ^(NSArray * photosArray,NSArray * modelsArray){
        
    };
}

@end
