//
//  DownLoadManager.m
//  EyePetizer
//
//  Created by chzy on 15/11/16.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "DownLoadManager.h"
#import "AFNetworking.h"
@implementation DownLoadManager
+ (id)sharedManager{
    static  DownLoadManager *manager =nil;
    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[DownLoadManager alloc]init];
        });
    }
    return manager;
}
- (void)DownloadVideoFrom:(NSString *)downloadUrl{
  
    
    
}
@end
