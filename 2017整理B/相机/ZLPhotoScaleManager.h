//
//  ZLPhotoScaleManager.h
//  BookingCar
//
//  Created by apple on 2017/11/7.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ZLBackImagePickerFinishAction)(UIImage * image);

@interface ZLPhotoScaleManager : NSObject
/**
 *  修改相册空间顶部背景图的类方法
 *
 *  @param viewController for present UIImagePickerController 对象
 *  @param allowsEditing  是否允许编辑头像
 *  @param finishAction   结束回调
 */
+ (void)showHeadImagePickerFromViewController:(UIViewController * )viewController
                                allowsEditing:(BOOL)allowsEditing
                                 finishAction:(ZLBackImagePickerFinishAction)finishAction;
@end
