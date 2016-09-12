//
//  PassViewController.h
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^showOrHidenSetView)(BOOL n);

@interface PassViewController : UIViewController

@property (nonatomic,copy)showOrHidenSetView MyShowOrHidenSetViewBlock;

@end
