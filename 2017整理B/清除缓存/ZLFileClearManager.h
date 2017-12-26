//
//  ZLFileClearManager.h
//  BookingCar
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDImageCache.h>
/** 快速实现单例*/
//#import "MHSingleton.h"

@interface ZLFileClearManager : NSObject

/**
 *==========ZL注释start===========
 *1.清理SDWebImage的缓存
 *
 *2.返回Block  缓存的大小
 ===========ZL注释end==========*/
+ (void)clearSDWebImageCacheResault:(void (^)(BOOL success,float fileSize))block;

/**
 *==========ZL注释start===========
 *1.清除所有文件缓存
 *
 ===========ZL注释end==========*/
+ (void)clearALLFileCacheResault:(void (^)(BOOL success,float fileSize))block;

/**
 *==========ZL注释start===========
 *1.获取缓存文件夹和文件大小
 *
 ===========ZL注释end==========*/
+ (float)folderSizeAtPath:(NSString *)path;
+ (float)fileSizeAtPath:(NSString *)path;

/**
 *==========ZL注释start===========
 *1.获取document目录
 *
 *2.注释描述
 *3.注释描述
 *4.注释描述
 ===========ZL注释end==========*/
+ (NSString *)getDocumentPath;


@end
