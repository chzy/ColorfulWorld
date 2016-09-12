//
//  Setting.m
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//
#define KCenterWidthL  KSize.width/2
#import "Setting.h"

@interface Setting ()
{
    UIButton *_MyStore;
    UIButton *_MyCache;
    UIButton *_YouAdvice;
    UIButton *_MyLove;
}
@end
@implementation Setting
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self confiUI];
    }
    return self;
}
- (void)confiUI{
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.01;
   // self.frame = CGRectMake(0, 0, KSize.width/4, KSize.height-64.9);
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
   // self.userInteractionEnabled = YES;
    _MyStore = [[UIButton alloc]initWithFrame:CGRectZero];
    _MyStore.frame = CGRectMake(0, 0, KSize.width/4, 23);
    _MyStore.center = CGPointMake(KCenterWidthL, 100);
    _MyStore.backgroundColor = [UIColor clearColor];
    [_MyStore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_MyStore setTitle:@"我的收藏" forState:UIControlStateNormal];
    [_MyStore addTarget:self action:@selector(Mycollection) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_MyStore];
    
    
    
    _MyCache = [[UIButton alloc]initWithFrame:CGRectZero];
    _MyCache.frame = CGRectMake(0, 0, KSize.width/4, 23);
    _MyCache.center = CGPointMake(KCenterWidthL, 160);
    _MyCache.backgroundColor = [UIColor clearColor];
    [_MyCache setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_MyCache setTitle:@"我的缓存" forState:UIControlStateNormal];
    [self addSubview:_MyCache];
    [_MyCache addTarget:self action:@selector(MyCache) forControlEvents:UIControlEventTouchUpInside];
    
    
    _YouAdvice = [[UIButton alloc]initWithFrame:CGRectZero];
    _YouAdvice.frame = CGRectMake(0, 0, KSize.width/4, 23);
    _YouAdvice.center = CGPointMake(KCenterWidthL, 220);
    _YouAdvice.backgroundColor = [UIColor clearColor];
    [_YouAdvice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_YouAdvice setTitle:@"意见反馈" forState:UIControlStateNormal];
    [self addSubview:_YouAdvice];
    [_YouAdvice addTarget:self action:@selector(YouAdvice) forControlEvents:UIControlEventTouchUpInside];
    
    
    _MyLove = [[UIButton alloc]initWithFrame:CGRectZero];
    _MyLove.frame = CGRectMake(0, 0, KSize.width/4, 23);
    _MyLove.center = CGPointMake(KCenterWidthL, 280);
    _MyLove.backgroundColor = [UIColor clearColor];
    [_MyLove setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_MyLove setTitle:@"我要投稿" forState:UIControlStateNormal];
    [self addSubview:_MyLove];
    [_MyLove addTarget:self action:@selector(MyLove) forControlEvents:UIControlEventTouchUpInside];
}
- (void)Mycollection{
    [self.Delegate openMyStore];
}
- (void)MyCache{
    [self.Delegate openMyCache];
}
- (void)YouAdvice{
    [self.Delegate sendYouAdvice];
}
- (void)MyLove{
    [self.Delegate sendMyLove];
}

@end
