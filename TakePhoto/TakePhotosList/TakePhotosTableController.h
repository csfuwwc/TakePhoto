//
//  TakePhotosTableController.h
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import "TakePhotosController.h"

@interface TakePhotosTableController : UITableViewController

@property (strong, nonatomic) NSArray * groups;


@property (copy, nonatomic) void (^ selectPhotoListBlock)(TakePhotosTableModel * model);

@end
