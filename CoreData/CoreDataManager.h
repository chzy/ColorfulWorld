//
//  CoreDataManager.h
//  EyePetizer
//
//  Created by chzy on 15/11/13.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DailyModel.h"
#import "MyCollection.h"
#import "CacheModel.h"
#import "MyCache.h"
@interface CoreDataManager : NSObject
@property (nonatomic,strong)NSManagedObjectContext  *Mycontext;
@property (nonatomic,strong)NSArray  *datasource;
+ (id)sharedManager;
- (void)createContext;
- (void)saveModel:(DailyModel *)model;
- (void)deleteModel:(DailyModel *)model;
- (BOOL)isCollected:(DailyModel *)model;
- (NSArray *)searchMyStore;

- (void)saveCache:(CacheModel *)model;
- (void)deleCache:(CacheModel *)model;
- (BOOL)isExCache:(NSString *)name;
- (NSArray *)CacheArray;
- (NSString *)byName:(NSString *)name;
@end
