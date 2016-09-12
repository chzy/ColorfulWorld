//
//  Setting.h
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowViewController.h"

@protocol SettingDelegaet <NSObject>

- (void)openMyStore;
- (void)openMyCache;
- (void)sendYouAdvice;
- (void)sendMyLove;

@end
@interface Setting : UIView
@property (nonatomic,assign)id<SettingDelegaet>Delegate;
@end
