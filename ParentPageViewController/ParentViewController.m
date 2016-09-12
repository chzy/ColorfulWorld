//
//  ParentViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/12.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "ParentView.h"
#import "ShowModelView.h"
@interface ParentView ()
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)NSMutableArray *ViewArray;
@end

@implementation ParentView

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    _ViewArray = [[NSMutableArray alloc]init];
//    [self createScrollView];
//}
- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array and:(NSInteger) nowID
{
    self = [super initWithFrame:frame];
    if (self) {
        _nowID = nowID;
        _modelArray = [array mutableCopy];
        _ViewArray = [[NSMutableArray alloc]init];
        [self createScrollView];

    }
    return self;
}
- (void)createScrollView{
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.height)];

    _myScrollView.backgroundColor = [UIColor whiteColor];
    _myScrollView.contentSize = CGSizeMake(KSize.width*_modelArray.count, KSize.height-64);
    _myScrollView.contentOffset = CGPointMake(KSize.width*_nowID, 0);
    _myScrollView.pagingEnabled = YES;
    int n = 0;
    for (DailyModel *model in _modelArray) {
        ShowModelView  *showModelVC = [[ShowModelView alloc]initWithFrame:self.frame AndModel:model];
       // showModelVC.Model =model;
        [_ViewArray addObject:showModelVC];
        showModelVC.videoBlock = ^(NSString *videoUrl){
            _VieoPlayBlock(videoUrl);
        };
        showModelVC.frame = CGRectMake(n*KSize.width, 0, KSize.width, KSize.height);
        n++;
    
        [_myScrollView addSubview:showModelVC];
    
    }
    [self addSubview:_myScrollView];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
