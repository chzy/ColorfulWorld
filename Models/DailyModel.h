//
//  DailyModel.h
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyModel : NSObject
@property (nonatomic,copy)NSString * descriptionx;//描述
@property (nonatomic,copy)NSString * duration; // 视频时间
@property (nonatomic,copy)NSString * title;    //name
@property (nonatomic,copy)NSString * playUrl; //视频网址
@property (nonatomic,copy)NSString * category;//--->category 分类
@property (nonatomic,strong)NSMutableDictionary *cover;/*下面模糊blurred  详细图片detail*/
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,strong)NSMutableDictionary *consumption;/*collectionCount

                                                              playCount
                                                              
*/
@end
