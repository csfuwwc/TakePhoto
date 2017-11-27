//
//  TakePhotosTableController.m
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import "TakePhotosTableController.h"

@interface TakePhotosTableController ()

@end

@implementation TakePhotosTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相薄";

    
    
    self.tableView.tableFooterView = [UIView new];
    
    //分割线颜色
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TakePhotosTableCell" bundle:nil] forCellReuseIdentifier:@"TakePhotosTableCell"];

    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(dismiss:)];
}


- (void)dismiss:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TakePhotosTableCell  *cell = (TakePhotosTableCell *)[tableView dequeueReusableCellWithIdentifier:@"TakePhotosTableCell" forIndexPath:indexPath];
    TakePhotosTableModel * model = self.groups[indexPath.row];

    cell.model = model;
    
    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TakePhotosTableModel * model = self.groups[indexPath.row];

    if (self.selectPhotoListBlock)
    {
        self.selectPhotoListBlock(model);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

@end
