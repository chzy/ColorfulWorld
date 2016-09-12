//
//  DailyModel.m
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "DailyModel.h"

@implementation DailyModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString: @"description"]) {
        [self setValue:value forKey:@"descriptionx"];

    }
   }
@end
