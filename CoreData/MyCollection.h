//
//  MyCollection.h
//  EyePetizer
//
//  Created by chzy on 15/11/13.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyCollection : NSManagedObject

@property (nonatomic, retain) NSString * descriptionx;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * playUrl;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) id cover;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) id consumption;

@end
