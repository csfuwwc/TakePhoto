//
//  HMTakePhotoTableController.m
//  ELCImagePickerDemo
//
//  Created by 李彦鹏 on 15/6/30.
//  Copyright (c) 2015年 Dreamore Technologies. All rights reserved.
//

#import "HMTakePhotoTableController.h"
#import <QuartzCore/QuartzCore.h>
@interface HMTakePhotoTableController ()
{
    
    NSMutableArray * imagesArray;
    NSArray * rightViewArray;
    UIBarButtonItem * rightBarButtonItem;
}
@property(strong,nonatomic)NSMutableArray * modelsArray;
@property(strong,nonatomic)UIButton * numButton;
@property(assign,nonatomic)int columns;
@end

@implementation HMTakePhotoTableController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark NavUI  Methods

//导航栏UI设置
-(void)customNavSet
{
    
    //self.navigationBar.translucent = NO;//设置去除导航栏上方一层白色蒙板
    
    
    
    UIColor * color = [UIColor colorWithRed:((float)((0xef4949 & 0xFF0000) >> 16))/255.0 green:((float)((0xef4949 & 0xFF00) >> 8))/255.0 blue:((float)(0xef4949 & 0xFF))/255.0 alpha:1.0];
    
    //左侧返回字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    
    //标题设置
    self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjects:
                                             [NSArray arrayWithObjects:[UIColor whiteColor],[UIFont boldSystemFontOfSize:18], nil] forKeys:
                                             [NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    
    
    //导航栏右侧
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    UIBarButtonItem * numberButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self customButtonWithTitle:[NSString stringWithFormat:@"%d",self.didHaveCount]]];
    if (self.didHaveCount<=0)
    {
        rightBarButtonItem.enabled = NO;
    }
    else
    {
        rightBarButtonItem.enabled = YES;
    }
    
    rightViewArray = @[rightBarButtonItem,numberButtonItem];
    [self.navigationItem setRightBarButtonItems:rightViewArray];
    
    
    
    //多张图片上传时候，为发起筹款
    if (self.maxSelectedCount>1)
    {
        [self.navigationItem setTitle:NSLocalizedString(@"选择照片", nil)];
    }
    else
    {
        [self.navigationItem setTitle:NSLocalizedString(@"相机胶卷", nil)];

    }
    
    
    
    
    
    UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem];
    
    
    
}
//设置导航栏右侧已选择张数UI
-(void)setPhotoNum:(NSInteger)number
{

    [self customButtonWithTitle:[NSString stringWithFormat:@"%ld",number]];
    
    if (number<=0)
    {
        rightBarButtonItem.enabled = NO;
    }
    else
    {
        rightBarButtonItem.enabled = YES;
    }
    /*
    rightViewArray = nil;
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    UIBarButtonItem * numberButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self customButtonWithTitle:[NSString stringWithFormat:@"%ld",number]]];
    
    if (number<=0)
    {
        doneButtonItem.enabled = NO;
    }
    else
    {
        doneButtonItem.enabled = YES;
    }
    rightViewArray = @[doneButtonItem,numberButtonItem];
    [self.navigationItem setRightBarButtonItems:rightViewArray];
     */
    

}

//右侧已选择张数视图初始化
-(UIButton *)customButtonWithTitle:(NSString *)title
{
    if (!self.numButton)
    {
        self.numButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.numButton.titleLabel.textColor = [UIColor redColor];
        self.numButton.tintColor = [UIColor redColor];
        [self.numButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.numButton.titleLabel setFont:[UIFont systemFontOfSize:14]];

    }
    if (self.maxSelectedCount<=1)
    {
        self.numButton.frame = CGRectZero;
        return self.numButton;
    }
    
    if (!title||[title isEqualToString:@""]||[title isEqualToString:@"0"])
    {
        self.numButton.frame = CGRectZero;
        return self.numButton;
    }
    


    self.numButton.bounds = CGRectMake(0, 0, 18, 18);


    [self.numButton setBackgroundImage:[UIImage imageNamed:@"photo_numIcon"] forState:UIControlStateNormal];
    [self.numButton setTitle:title forState:UIControlStateNormal];
    [self.numButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];

    [self.numButton.layer addAnimation:[self opacityTimes_Animation:1 durTimes:.2] forKey:@"num"];


    return self.numButton;
}

//layer动画
-(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time; //有闪烁次数的动画

{
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = time; // 动画持续时间
    animation.repeatCount = repeatTimes; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0.2]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.2]; // 结束时的倍率
    
    return animation;

    
}

#pragma mark EndSelectedPhotos
//取消
-(void)cancel:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//完成
- (void)doneAction:(id)sender
{
    if (self.finishPhotoBlock)
    {
        self.finishPhotoBlock(nil,self.modelsArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark System Methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.columns = self.view.bounds.size.width / 80;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];

    
    self.modelsArray = [NSMutableArray arrayWithCapacity:0];
    imagesArray = [NSMutableArray arrayWithCapacity:0];
    self.elcAssets = [NSMutableArray arrayWithCapacity:0];

    
    [self.modelsArray addObjectsFromArray:self.DidHavePhotos];
    
    NSLog(@"已有照片模型－－－%@",self.modelsArray);

    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableFooterView = [self customViewWithHeight:4];
    [self.tableView setAllowsSelection:NO];
    
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preparePhotos) name:ALAssetsLibraryChangedNotification  object:nil];
    

    [self customNavSet];
}

- (void)preparePhotos
{
    @autoreleasepool {
        
        [self.elcAssets removeAllObjects];
        
        
        __weak HMTakePhotoTableController * weakSelf = self;
        //遍历所有照片
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil)
            {
                return;
            }
            
             HMTakePhotoModel *elcAsset = [[HMTakePhotoModel alloc] initWithAsset:result];
            
  
            //判断是否能够继续选择
            elcAsset.shouldSelectedBlock = ^(){


                if ([weakSelf getNumberOfDidSelectedPhotos]>=weakSelf.maxSelectedCount-weakSelf.didHaveCount)
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"你最多只能选择%d张图片",weakSelf.maxSelectedCount] message:@"" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [alert show];
                    
                    return NO;
                }
                return YES;
            };
            
            //添加了一张新图片
            elcAsset.didSelectedBlock = ^(HMTakePhotoModel * model){
                
                [weakSelf getNumberOfDidSelectedPhotos];

                //增加这个array原因是for model in modelsarray 时候可能crach
                NSArray * array = [NSArray arrayWithArray:weakSelf.modelsArray];
                
                if (![model isTheSamePhotoWithModelArray:array])
                {
                    NSString * url = [model.asset valueForProperty:ALAssetPropertyAssetURL];
                    DetailImageViewModel * ImageModel = [[DetailImageViewModel alloc] initWithType:ImageType_PhotoLibrary Url:url];
                    ImageModel.image = [model selectedAssetImage];
                    [weakSelf.modelsArray addObject:ImageModel];

                }
                

                
                
                /*
                if ([model isTheSamePhotoWithModelArray:weakSelf.DidHavePhotos])
                {
                    //zb --- 避免已选中的图片，先取消后选中消失
                    NSString * url = [model.asset valueForProperty:ALAssetPropertyAssetURL];
                    BOOL isHave = NO;
                    
                    for (DetailImageViewModel * model in weakSelf.modelsArray)
                    {
                        if ([model.URl isEqual:url])
                        {
                            isHave = YES;
                            break;
                        }
                    }
                    
                    if (!isHave) {
                        DetailImageViewModel * ImageModel = [[DetailImageViewModel alloc] initWithType:ImageType_PhotoLibrary Url:url];
                        ImageModel.image = [model selectedAssetImage];
                        [weakSelf.modelsArray addObject:ImageModel];
                    }

                }
                else
                {
                    NSString * url = [model.asset valueForProperty:ALAssetPropertyAssetURL];
                    DetailImageViewModel * ImageModel = [[DetailImageViewModel alloc] initWithType:ImageType_PhotoLibrary Url:url];
                    ImageModel.image = [model selectedAssetImage];
                    [weakSelf.modelsArray addObject:ImageModel];
                }
                */
            };
            
            //取消了一张图片
            elcAsset.didDeSelectedBlock = ^(HMTakePhotoModel * model){
                
                
                //增加这个array原因是for model in modelsarray 时候可能crach
                NSArray * array = [NSArray arrayWithArray:weakSelf.modelsArray];
                
                for (DetailImageViewModel * imageModel in array)
                {
                    if ([[model.asset valueForProperty:ALAssetPropertyAssetURL] isEqual:imageModel.URl])
                    {
                        [weakSelf.modelsArray removeObject:imageModel];
                    }
                }
                
                [weakSelf getNumberOfDidSelectedPhotos];

            };
            
            

            BOOL isAssetFiltered = NO;
            
            //筛选掉视频
            NSURL * url = [result valueForProperty:ALAssetPropertyType];
            
            if ([url isEqual:ALAssetTypeVideo])
            {
                isAssetFiltered = YES;
            }
            
            
            if (!isAssetFiltered)
            {
                [weakSelf.elcAssets addObject:elcAsset];
                
                if ([weakSelf.DidHavePhotos count]>0)
                {
                    //如果照片已经选择
                    if ([elcAsset isTheSamePhotoWithModelArray:weakSelf.DidHavePhotos])
                    {
                        elcAsset.selected = YES;
                    }
                }
            }
            
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            // scroll to bottom
            long section = [weakSelf numberOfSectionsInTableView:weakSelf.tableView] - 1;
            long row = [weakSelf tableView:weakSelf.tableView numberOfRowsInSection:section] - 1;
            if (section >= 0 && row >= 0) {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                                     inSection:section];
                [weakSelf.tableView scrollToRowAtIndexPath:ip
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:NO];
            }
            
        });
    }
}

//获取已经选择图片张数
-(NSInteger)getNumberOfDidSelectedPhotos
{
    NSUInteger selectionCount = 0;
    
    for (HMTakePhotoModel * model in self.elcAssets)
    {
        if (model.selected)
        {
            
            if ([model isTheSamePhotoWithModelArray:self.DidHavePhotos])
            {
                
            }
            else
            {
                selectionCount++;

            }
        }
        else
        {
            if ([model isTheSamePhotoWithModelArray:self.DidHavePhotos])
            {
                selectionCount--;
            }
            
        }
    }
    
    [self setPhotoNum:selectionCount+self.didHaveCount];
    return selectionCount;
}
- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.elcAssets count] - index);
    return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark UITableViewDataSourceAndDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.columns <= 0)
    {
        self.columns = 4;
    }
    NSInteger numRows = ceil([self.elcAssets count] / (float)self.columns);
    return numRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    
    HMTakePhotoCell *cell = (HMTakePhotoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HMTakePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.shouldShowOverView = self.maxSelectedCount>1?YES:NO;
    }
    
    [cell setAssets:[self assetsForIndexPath:indexPath]];
    
    
    __weak HMTakePhotoTableController * weakSelf = self;
    
    //选择单张图片回调
    cell.singelBlock = ^(UIImage * image,DetailImageViewModel * model){
      
        if (weakSelf.finishPhotoBlock)
        {
            weakSelf.finishPhotoBlock(@[image],@[model]);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];

    };


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = (ScreenWidth - 25)/4.0;
    return height + 5;
}
-(UIView *)customViewWithHeight:(CGFloat)height
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


@end

