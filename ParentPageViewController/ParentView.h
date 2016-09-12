//
//  ParentViewController.h
//  EyePetizer
//
//  Created by chzy on 15/11/12.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^videoPlayBlock)(NSString *VideoURL);
typedef void (^showMoreViews)();
typedef void (^setViewBlock)();
@interface ParentView : UIView
@property (nonatomic,assign)NSInteger nowID;
@property (nonatomic,strong)NSMutableArray * modelArray;
@property (nonatomic,copy)videoPlayBlock VieoPlayBlock;
@property (nonatomic,copy)showMoreViews myShowMoreView;
@property (nonatomic,copy)setViewBlock mysetBlock;
- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array and:(NSInteger) nowID;
@end
