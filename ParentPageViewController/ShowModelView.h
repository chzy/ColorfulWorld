//
//  ShowModelViewController.h
//  EyePetizer
//
//  Created by chzy on 15/11/12.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyModel.h"
typedef void (^MyPlayBlock)(NSString *videoUrl);

@interface ShowModelView : UIView
@property (nonatomic,strong)DailyModel *Model;
@property (nonatomic,copy)MyPlayBlock videoBlock;

- (instancetype)initWithFrame:(CGRect)frame AndModel:(DailyModel *)model;

@end
