//
//  MyCache.h
//  EyePetizer
//
//  Created by chzy on 15/11/17.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyCache : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * progress;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) id cover;
@end
