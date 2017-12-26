//
//  KZPhotoManager.m
//  工具类
//
//  Created by MR.Huang on 16/1/18.
//  Copyright © 2016年 MR.Huang. All rights reserved.
//

#import "KZPhotoManager.h"

@interface KZPhotoManager()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end


@implementation KZPhotoManager

+ (instancetype)sharedPhotoManager {
    static id s;
    if (s == nil) {
        s = [[KZPhotoManager alloc] init];
    }
    return s;
}


- (instancetype)init
{
    if (self = [super init]) {
        pickerController = [[UIImagePickerController alloc] init];
             pickerController.delegate = self;
    }
    return self;
}


+ (void)getImage:(void (^)(UIImage *image,BOOL success))img showIn:(UIViewController *)controller AndActionTitle:(NSString *)title
{
    [[KZPhotoManager sharedPhotoManager] getImage:img showIn:controller AndActionTitle:title];
}

- (void)getImage:(void (^)(UIImage *image,BOOL success))img showIn:(UIViewController *)controller AndActionTitle:(NSString *)title;
{
    saveImageCallBack = [img copy];
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title?title:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // Create the actions.
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    //构建图像选择器
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            pickerController.mediaTypes = [NSArray arrayWithObjects:@"public.image",nil];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //设置为拍照模式
            pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            [controller presentViewController:pickerController animated:YES completion:nil];
        }
    }];
    UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //这里只选择展示图片
        pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [controller presentViewController:pickerController animated:YES completion:nil];
    }];
    
    // Add the actions.
    [alertVc addAction:cancelAction];
    [alertVc addAction:otherAction];
    [alertVc addAction:otherAction1];
    [controller presentViewController:alertVc animated:YES completion:nil];
    
}
/**
 *==========ZL注释start===========
 *1.获取视频和收帧图片
 *
 *2.
 *3.
 *4.
 ===========ZL注释end==========*/
+ (void)getVideo:(void (^)(NSURL *))vURL withData:(void (^)(NSData *))vData withFirstImage:(void (^)(UIImage *))fristImage showIn:(UIViewController *)controller AndActionTitle:(NSString *)title{
    [[KZPhotoManager sharedPhotoManager]getVideo:vURL withData:vData withFirstImage:fristImage showIn:controller AndActionTitle:title];
}

- (void)getVideo:(void (^)(NSURL *))vURL withData:(void (^)(NSData *))vData withFirstImage:(void (^)(UIImage *))fristImage showIn:(UIViewController *)controller AndActionTitle:(NSString *)title{
    
    saveVideoURLCallBack = [vURL copy];
    saveImageCallBack = [vData copy];
    saveVideoFirstImageCallBack = [fristImage copy];
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title?title:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // Create the actions.
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    //构建图像选择器
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            pickerController.allowsEditing = YES;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.videoMaximumDuration = 10.0;//视频最长长度
            
            //相机类型（拍照、录像...）字符串需要做相应的类型转换
            //pickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
            //这里只选择展示视频
            //媒体类型：@"public.movie" 为视频  @"public.image" 为图片
            pickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie",nil];
            //视频上传质量
            //UIImagePickerControllerQualityTypeHigh高清
            //UIImagePickerControllerQualityTypeMedium中等质量
            //UIImagePickerControllerQualityTypeLow低质量
            //UIImagePickerControllerQualityType640x480
            pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量


            //设置为录像模式
            pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            [controller presentViewController:pickerController animated:YES completion:nil];
        }
        
        //        [pickerController.view setTag:actionSheet.tag];
        
        
    }];
    UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //这里只选择展示视频
        pickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie",nil];
        pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.videoMaximumDuration = 10.0;//视频最长长度
        
        //相机类型（拍照、录像...）字符串需要做相应的类型转换
        //pickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
        //这里只选择展示视频
        pickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie",nil];
        [controller presentViewController:pickerController animated:YES completion:nil];
    }];
    
    // Add the actions.
    [alertVc addAction:cancelAction];
    [alertVc addAction:otherAction];
    [alertVc addAction:otherAction1];
    [controller presentViewController:alertVc animated:YES completion:nil];
    
}

#pragma mark 图片选择回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]){
        NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            //如果是视频  从照相机进来

        }
        else{
            //如果是视频  从相册进来
            //保存视频至相册（异步线程）
            NSString *urlStr = [url path];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            });
        }
        //获取视频的thumbnail  首帧图片
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:url] ;
        UIImage  *thumbnail = [player thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        if (saveVideoURLCallBack) {
            saveVideoURLCallBack(url);
        }
        if (saveVideoDataCallBack) {
            saveVideoDataCallBack(videoData);
        }
        if (saveVideoFirstImageCallBack) {
            saveVideoFirstImageCallBack(thumbnail);
        }
        player = nil;
    }
    else{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        //上传图片
        if (saveImageCallBack) {
            saveImageCallBack(image,YES);
        }
    }
    [picker dismissViewControllerAnimated:NO completion:^{
        if (saveImageCallBack) {
            saveImageCallBack(nil,NO);
        }

    }];
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

//获取 本地视频第一帧图片
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

@end
