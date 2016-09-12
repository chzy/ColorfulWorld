//
//  CoreDataManager.m
//  EyePetizer
//
//  Created by chzy on 15/11/13.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()
@property (nonatomic,strong)CoreDataManager *coreDataManager;
@property (nonatomic,assign)  BOOL IsExist ;
@end

@implementation CoreDataManager
+(id)sharedManager{
 static   CoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CoreDataManager alloc]init];

    });
    return manager;
}
- (void)createContext{
   
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Collection" ofType:@"momd"];
    NSURL *fileUrl = [NSURL URLWithString:path];
    NSManagedObjectModel *model  = [[NSManagedObjectModel alloc]initWithContentsOfURL:fileUrl];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/Colletion.sqlite3"];
    NSLog(@"%@",dbPath);
    NSURL *dbUrl = [NSURL fileURLWithPath:dbPath];
    NSError *error;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbUrl options:nil error:&error];
    if (!store) {
        NSLog(@"%@",error.localizedDescription);
    }
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
    _Mycontext = context;
    context.persistentStoreCoordinator = psc;
}
//收藏或者删除


- (void)saveModel:(DailyModel *)model{
   
    MyCollection *collection = [NSEntityDescription insertNewObjectForEntityForName:@"MyCollection" inManagedObjectContext:_Mycontext];
    collection.descriptionx = model.descriptionx;
  
    collection.title = model.title;
    collection.playUrl = model.playUrl;
    collection.category = model.category;
    collection.cover = model.cover;
    NSString *temp = [NSString stringWithFormat:@"%@",model.duration];
      collection.duration = temp;
    collection.text = model.text;
    collection.consumption = model.consumption;
    NSError *error;
    if (collection.text != nil) {
        if ([_Mycontext save:&error]) {
            NSLog(@"收藏成功");
        }
    }
}
- (void)saveCache:(CacheModel *)model{
    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCache"];
    _datasource = [_Mycontext executeFetchRequest:request error:nil];
    BOOL isExist = NO;
    for (MyCache *cache in _datasource) {
        NSString *n1 = [NSString stringWithFormat:@"%@",model.name];
        NSString *n2 = [NSString stringWithFormat:@"%@",cache.name];
        
        if ([n1 isEqualToString:n2]) {
            cache.progress = model.progress;
            cache.name = model.name;
            cache.path = model.path;
            isExist = YES;
            NSError *error;
            if (model.name != nil) {
                if ([_Mycontext save:&error]) {
                    NSLog(@"当前不存在存储变更成功");
                }
            }
        }
    }
    if (!isExist) {
        MyCache *cache = [NSEntityDescription insertNewObjectForEntityForName:@"MyCache" inManagedObjectContext:_Mycontext];
        cache.progress = model.progress;
        cache.name = model.name;
        cache.path = model.path;
        cache.cover = model.cover;
        NSError *error;
        if (model.name != nil) {
            if ([_Mycontext save:&error]) {
                NSLog(@"当前存在存储变更成功");
            }
        }
    }
 
}
- (void)deleteModel:(DailyModel *)model{
    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCollection"];
    _datasource = [_Mycontext executeFetchRequest:request error:nil];

    for (MyCollection *colletion in _datasource) {
    
        NSString *str1 = [NSString stringWithFormat:@"%@",colletion.title];
        NSString *str2 = [NSString stringWithFormat:@"%@",model.title];
        if ([str1 isEqualToString:str2]) {
            _IsExist = YES;
            if(_IsExist){
                [_Mycontext deleteObject:colletion];
                [_Mycontext save:nil];}
        }
    
    }
}
- (void)deleCache:(CacheModel *)model{
    NSFileManager *fileManager =[NSFileManager defaultManager];

    //MyCache
    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCache"];
    _datasource = [_Mycontext executeFetchRequest:request error:nil];
    
    for (MyCache *cache in _datasource) {
        
        NSString *str1 = [NSString stringWithFormat:@"%@",cache.name];
        NSString *str2 = [NSString stringWithFormat:@"%@",model.name];
        if ([str1 isEqualToString:str2]) {
            _IsExist = YES;
            if(_IsExist){
                [_Mycontext deleteObject:cache];
                [_Mycontext save:nil];
           NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/Chzyvideo/%@.mp4",NSHomeDirectory(),str1];
                [fileManager removeItemAtPath:path error:nil];
            }
        }
 
    }
}
- (BOOL)isExCache:(NSString *)name{
    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCache"];
    _datasource = [_Mycontext executeFetchRequest:request error:nil];
    
    for (MyCache *cache in _datasource) {
        
        NSString *str1 = [NSString stringWithFormat:@"%@",cache.name];
     
        if ([str1 isEqualToString:name]) {
            NSLog(@"%@~~~~~%@",str1,name);
            return YES;
        }
    }

    return NO;
}
- (NSString *)byName:(NSString *)name{
    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCache"];
    _datasource = [_Mycontext executeFetchRequest:request error:nil];
    
    for (MyCache *cache in _datasource) {
        
        NSString *str1 = [NSString stringWithFormat:@"%@",cache.name];
        
        if ([str1 isEqualToString:name]) {
            NSLog(@"%@~~~~~%@",str1,name);
            return cache.progress;
        }
    }
    
  return @"已缓存";
}
- (BOOL)isCollected:(DailyModel *)model{
    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCollection"];
    _datasource = [_Mycontext executeFetchRequest:request error:nil];
    
    for (MyCollection *colletion in _datasource) {
       
        NSString *str1 = [NSString stringWithFormat:@"%@",colletion.title];
        NSString *str2 = [NSString stringWithFormat:@"%@",model.title];
        if ([str1 isEqualToString:str2]) {
            NSLog(@"%@~~~~~%@",str1,str2);
            return YES;
        }
    }
    return NO;
}
- (NSArray *)searchMyStore{
    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCollection"];
    _datasource = [_Mycontext executeFetchRequest:request error:nil];
    
    return _datasource;
}
- (NSArray *)CacheArray{
    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCache"];
    _datasource = [_Mycontext executeFetchRequest:request error:nil];
    
    return _datasource;
}
- (CoreDataManager*)coreDataManager{
    if (_coreDataManager == nil) {
        _coreDataManager = [[CoreDataManager alloc]init];
    }
    return _coreDataManager;
}
//- (NSMutableArray*)datasource{
//    NSFetchRequest *request  = [[NSFetchRequest alloc]initWithEntityName:@"MyCollection"];
//    _datasource = [[self.Mycontext executeFetchRequest:request error:nil] mutableCopy];
//    DailyModel *modle = _datasource[0];
//    NSLog(@"%@",modle.title);
//    return  _datasource;
//}
@end
