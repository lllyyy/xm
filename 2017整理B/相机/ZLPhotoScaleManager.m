//
//  ZLPhotoScaleManager.m
//  BookingCar
//
//  Created by apple on 2017/11/7.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import "ZLPhotoScaleManager.h"

static ZLPhotoScaleManager * CCHeadImagePickerInstance = nil;

@interface ZLPhotoScaleManager ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString * _string1;
    NSString * _string2;
    
}
@property (nonatomic,weak)UIViewController * viewController;
@property (nonatomic,copy)ZLBackImagePickerFinishAction finishAction;
@property (nonatomic,assign)BOOL allowsEditing;
@property (nonatomic,copy)NSString * string1;
@property (nonatomic,copy)NSString * string2;

@end
@implementation ZLPhotoScaleManager
+ (void)showHeadImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(ZLBackImagePickerFinishAction)finishAction {
    if (CCHeadImagePickerInstance == nil ) {
        CCHeadImagePickerInstance = [[ZLPhotoScaleManager alloc] init];
    }
    [CCHeadImagePickerInstance showImagePickerFromViewController:viewController allowsEditing:allowsEditing finishAction:finishAction];
}

#pragma mark - privote methods
- (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditiong finishAction:(ZLBackImagePickerFinishAction)finishAction {
    _viewController = viewController;
    _finishAction = finishAction;
    _allowsEditing = allowsEditiong;
    
    self.string1 = @"拍照";
    self.string2 = @"从相册中选择";
    
    UIActionSheet * sheet = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.string1,self.string2, nil];
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.string2, nil];
    }
    UIView * window = [UIApplication sharedApplication].keyWindow;
    [sheet showInView:window];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:self.string1]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = _allowsEditing;
        /** 添加相机蒙版 */
            UIImageView *overLayImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60)];
            overLayImg.image = [UIImage imageNamed:@"layout"];
        
            //picker.cameraOverlayView = overLayImg;//3.0以后可以直接设置cameraOverlayView为overlay
            //picker.wantsFullScreenLayout = YES;
        
        [_viewController presentViewController:picker animated:YES completion:nil];
    }else if ([title isEqualToString:self.string2]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        [_viewController presentViewController:picker animated:YES completion:nil];
    }else {
        CCHeadImagePickerInstance = nil;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    if (_finishAction) {
        _finishAction(image);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        //  还可以带上其他操作
    }];
    CCHeadImagePickerInstance = nil;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_finishAction) {
        _finishAction(nil);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        //
    }];
    CCHeadImagePickerInstance = nil;
}
@end
