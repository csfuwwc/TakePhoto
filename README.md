# TakePhoto
拍照+选取照片工具


# 预览


选取单张图片-如更换头像/上传证件照等场景，支持编辑

![image](https://github.com/csfuwwc/TakePhoto/blob/master/TakePhotoDemo/IMG_1829.PNG)


选取多张图片-入发布朋友圈等场景(也可支持最大张数为1)-不支持编辑

![image](https://github.com/csfuwwc/TakePhoto/blob/master/TakePhotoDemo/IMG_1832.PNG)


# 使用

1、直接将TakePhoto文件夹拖入工程

2、在需要调用相机/相册功能的类/工程pch文件导入 'TakePhoto.h'

    [TakePhoto showCustomPhotosWithController:self maxCount:5 resultBlock:^(NSArray *images, NSArray *dataArray) {
        
        
    }];
    
# 优势

丝滑柔顺，超你所想～

功能：系统相册、调用相机、自定义相册、保存图片 等图片相关操作。

使用：一句代码，获取所需图片，权限检测/卡顿统统再见

发展：后续会逐步加上'图片编辑''图片预览'等功能

# 后话

有问题直接提issue或发送邮件csfuwwc@126.com
