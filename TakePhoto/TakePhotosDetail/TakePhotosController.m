//
//  TakePhotosController.m
//  MyCustomTools
//
//  Created by 李彦鹏 on 16/11/9.
//  Copyright © 2016年 李彦鹏. All rights reserved.
//

#import "TakePhotosController.h"
#import "TakePhotosCell.h"
#import "TakePhotosCameraCell.h"
#import "TakePhoto.h"
#import "TakePhotoTitleView.h"
#import "TakePhotosTableController.h"
#import "UIView+More.h"
#import "SystemManager.h"


@interface TakePhotosController ()

@property (strong, nonatomic) NSMutableArray * photosArray;

@property (strong, nonatomic) NSMutableArray * resultArray;


@property (strong, nonatomic) UIView * backView;

@property (strong, nonatomic) UIView * listView;

@property (strong, nonatomic) TakePhotoTitleView * titleView;

@end

@implementation TakePhotosController

static NSString * const reuseIdentifier = @"TakePhotosCell";
static NSString * const cameraIdentifier = @"TakePhotosCameraCell";

- (instancetype)init
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //item宽高
    layout.itemSize = CGSizeMake(photo_width, photo_width);
    //行间距
    layout.minimumLineSpacing = photo_space;
    //列间距
    layout.minimumInteritemSpacing = photo_space;
    //四周边距
    layout.sectionInset = UIEdgeInsetsMake(photo_space, photo_space, photo_space, photo_space);
    
    
    if (self = [super initWithCollectionViewLayout:layout])
    {
        //展示照片数组
        self.photosArray = [NSMutableArray arrayWithCapacity:0];
        
        //最终选择照片数组
        self.resultArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    //设置滚动条偏移量
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -3);
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //确保collection总可以滑动
     self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:cameraIdentifier bundle:nil] forCellWithReuseIdentifier:cameraIdentifier];
    
    
    [self setNav];
    

}

- (void)setNav
{

    
    //右侧-完成
    UIButton *btn_rihgt = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_rihgt.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn_rihgt.frame = CGRectMake(0, 0, 60, 22);
    btn_rihgt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn_rihgt setTitle:@"完成" forState:UIControlStateNormal];
    [btn_rihgt setTitleColor:MDGlobalGreen forState:UIControlStateNormal];
    [btn_rihgt setTitleColor:MDGlobalGreen forState:UIControlStateDisabled];
    [btn_rihgt addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_rihgt];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    //左侧-取消
    UIButton *btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_left.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn_left.frame = CGRectMake(0, 0, 60, 22);
    btn_left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn_left setTitle:@"取消" forState:UIControlStateNormal];
    [btn_left setTitleColor:MDGlobalGreen forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:btn_left];
    self.navigationItem.hidesBackButton = YES;
    
    
    TakePhotoTitleView * titleView = [[TakePhotoTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 44) title:@"相机胶卷"];
    self.navigationItem.titleView = titleView;
    
    self.titleView = titleView;
    
    __weak typeof(TakePhotoTitleView *)weakTitleView = titleView;
    
    __weak typeof(self)weakSelf = self;
    
    titleView.clickBlock = ^(UIView *view) {
      
        if (!weakTitleView.isShow)
        {
            [weakSelf showPhotoList];
        }
        else
        {
            [weakSelf hidenPhotoList];
        }
        
    };
}

- (void)cancel
{
    if ([TakePhoto sharePhoto].TakePhotoCancelBlock)
    {
        [TakePhoto sharePhoto].TakePhotoCancelBlock();
        
    }
    else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)finish:(id)sender
{
    //存放最终image
   NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    
  //NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:0];
        
    
    [self.resultArray enumerateObjectsUsingBlock:^(TakePhotoModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {

        
        
        @autoreleasepool {
            
            
            [TakePhoto requestDetailImageDataForAsset:model.asset resultHandler:^(NSData * _Nonnull imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                
                [finalArray addObject:[UIImage imageWithData:imageData]];
                
            }];
        }
        
        

        
    }];

    
    
    if ([TakePhoto sharePhoto].resultBlock)
    {

        [TakePhoto sharePhoto].resultBlock(finalArray);
        
        [finalArray removeAllObjects];
        finalArray = nil;
    }
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)setModel:(TakePhotosTableModel *)model
{
    if (_model != model)
    {
        _model = model;
        
        
        [self.resultArray removeAllObjects];
        [self.photosArray removeAllObjects];
        
        [self configTitle];

        
        __weak typeof(self)weakSelf = self;
        
        __block NSMutableArray * assetArray = [NSMutableArray arrayWithCapacity:0];
        
        [model.result enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //转换为model
            [weakSelf configModel:asset];
            
            [assetArray addObject:asset];
            
            
        }];

        [self.collectionView reloadData];

    }
}


-(void)configModel:(PHAsset *)asset
{
    
    TakePhotoModel * model = [[TakePhotoModel alloc] init];
    model.asset = asset;
    [self.photosArray addObject:model];
    
    
    
    
    __weak typeof(self)weakSelf = self;
    
    
    //是否允许继续添加
    model.shouldSelectBlock = ^(){
        
        if ([weakSelf.resultArray count] >= [TakePhoto maxPhotoCount])
        {
            
            //如果是多选且超过最大张数限制才弹框
            if ([TakePhoto maxPhotoCount] != 1)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多只能添加%ld张图片",(long)[TakePhoto maxPhotoCount]] message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
            }
            

            
            return NO;
        }
        
        return YES;

    };
    
    //添加一张新照片
    model.didSelectedBlock = ^(TakePhotoModel * model){
        
        NSLog(@"新增--->%@",model);
        
        [weakSelf.resultArray addObject:model];
        
        //获取model对应的index
        model.index = [weakSelf.resultArray indexOfObject:model]+1;
        
        [weakSelf configTitle];
        
    };
    
    
    model.didDeselectedBlock = ^(TakePhotoModel * model){
        
        NSLog(@"减少--->%@",model);
        
        [weakSelf.resultArray removeObject:model];
        
        //将对应
        model.index = 0;
        
        [weakSelf configTitle];
        
        [weakSelf configModelIndex];
        
        
    };
    
    
    //选择单张图片
    model.singleSelectedBlock = ^(TakePhotoModel *model) {
      
        //[weakSelf showClipBaseModel:model];
        
    };
}

- (void)configModelIndex
{
    __weak typeof(self)weakSelf = self;
    
    [self.resultArray enumerateObjectsUsingBlock:^(TakePhotoModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        model.index = idx + 1;
        
        if ([weakSelf.resultArray lastObject] == model)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPhotoSelected" object:nil];
        }
        
    }];
}


-(void)configTitle
{
    self.titleView.titleLab.text = self.model.title;

    
    //未选择照片时候  不允许点击 完成 按钮防止外部未对空数组做容错处理
    if ([self.resultArray count]==0)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;

    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //相册图片+相机入口
    return [self.photosArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //相机入口
    if (indexPath.item == 0)
    {
        TakePhotosCameraCell * cameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:cameraIdentifier forIndexPath:indexPath];
        return cameraCell;
        
    }
    
    TakePhotosCell  *cell = (TakePhotosCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    TakePhotoModel * model = self.photosArray[indexPath.row - 1];
    
    cell.model = model;

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [TakePhoto showCameraWithController:self editEnable:NO animationTransition:YES];
        });
    }

}





#pragma mark Nav

- (void)showPhotoList
{
    self.titleView.isShow = YES;

    
    //背景蒙层
    self.backView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.view addSubview:self.backView];
    
    TakePhotosTableController * listVC = [[TakePhotosTableController alloc] init];
    listVC.groups = [TakePhoto sharePhoto].groups;
    [self.view addSubview:listVC.tableView];
    [self addChildViewController:listVC];
    
    __weak typeof(self)weakSelf = self;
    
    listVC.selectPhotoListBlock = ^(TakePhotosTableModel *model) {
      
        weakSelf.model = model;
        
        [weakSelf hidenPhotoList];
        
    };
    
    listVC.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
    
    self.listView = listVC.tableView;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        listVC.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        
    }];

}

- (void)hidenPhotoList
{
    
    self.titleView.isShow = NO;

    
    if (self.listView.superview)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.listView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
            
        } completion:^(BOOL finished) {
            
            [self.listView removeFromSuperview];
            
            for (UIViewController * vc in self.childViewControllers)
            {
                [vc removeFromParentViewController];
            }
            
            
        }];
    }
    
    if (self.backView.superview)
    {
        [self.backView removeFromSuperview];
    }
    
    
    
}

- (UIView *)backView
{
    UIView * backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];

    return backGroundView;
}



@end
