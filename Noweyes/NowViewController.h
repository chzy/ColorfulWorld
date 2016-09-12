//
//  NowViewController.h
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
typedef void(^showOrHidenSetView)(BOOL n);

@interface NowViewController : UIViewController

@property (nonatomic,copy)showOrHidenSetView MyShowOrHidenSetViewBlock;

@end
