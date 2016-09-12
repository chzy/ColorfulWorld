//
//  DownLoadManager.h
//  EyePetizer
//
//  Created by chzy on 15/11/16.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadManager : NSObject
+ (id)sharedManager;
- (void)DownloadVideoFrom:(NSString *)downloadUrl;
@end
