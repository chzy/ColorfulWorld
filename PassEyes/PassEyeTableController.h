//
//  PassEyeTableController.h
//  EyePetizer
//
//  Created by chzy on 15/11/13.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^showOrHidenSetView)(BOOL n);

@interface PassEyeTableController : UIViewController
@property (nonatomic,copy)NSString *VideoURl;
@property (nonatomic,copy)NSString *titleName;
@property (nonatomic,copy)showOrHidenSetView MyShowOrHidenSetViewBlock;
@end
