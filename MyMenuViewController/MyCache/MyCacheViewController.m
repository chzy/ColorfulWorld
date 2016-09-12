//
//  MyCacheViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/16.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "MyCacheViewController.h"
#import "CoreDataManager.h"
#import "MyCollection.h"
#import "UIImageView+WebCache.h"
#import "ParentView.h"
#import "WebVideoViewController.h"
#import "PlayerViewController.h"

@interface MyCacheViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    CoreDataManager *_manager;
    ParentView *_parentView;
    UIButton *_rightbtn;
    BOOL isEdit;
}
@end
@implementation MyCacheViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的缓存";
    isEdit = NO;
    [self initializeManager];
    [self createDataSource];
    [self configUI];
}
- (void)initializeManager{
    _manager = [CoreDataManager sharedManager];
}
- (void)createDataSource{
    _dataSource = [[_manager CacheArray] mutableCopy];
    
}
- (void)configUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    _rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightbtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightbtn.backgroundColor = [UIColor clearColor];
    [_rightbtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemr = [[UIBarButtonItem alloc]initWithCustomView:_rightbtn];
    self.navigationItem.rightBarButtonItem = itemr;
    UIImage *im = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    [btn setBackgroundImage:im forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)edit:(UIButton *)item{
    if (!isEdit) {
        [item setTitle:@"保存" forState:UIControlStateNormal];
        [_tableView setEditing: YES];
        isEdit = YES;
    }
    else{
        [item setTitle:@"编辑" forState:UIControlStateNormal];
        [_tableView setEditing: NO];
        
        isEdit = NO;
    }

}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"       删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CacheModel *model = _dataSource[indexPath.row];
    [_manager deleCache:model];
    
    [_dataSource removeObject:_dataSource[indexPath.row]];
    [_tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLIDE = @"cells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDE];
    }
    MyCache *model = _dataSource[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.width/2)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[model.cover objectForKey:@"detail"]]];
    UIView *coverView = [[UIView alloc]initWithFrame:imageView.frame];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.4;
    [imageView addSubview:coverView];
   
    
    UILabel *detailLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 10)];
    detailLb.center = CGPointMake(imageView.center.x, imageView.center.y+30);
    detailLb.textAlignment = NSTextAlignmentCenter;
 
 
    detailLb.textColor = [UIColor whiteColor];
    detailLb.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    [imageView addSubview:detailLb];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:imageView];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KSize.width/2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CacheModel *model = _dataSource[indexPath.row];
   PlayerViewController *player = [[PlayerViewController alloc]init];
    player.videoUrl = [NSString stringWithFormat:@"%@/Library/Caches/Chzyvideo/%@.mp4",NSHomeDirectory(),model.name];

    [self.navigationController pushViewController:player animated:NO];
    //[NSString stringWithFormat:@"%@/Library/Caches/Chzyvideo/%@",NSHomeDirectory(),@"model.name"]
   
}
- (NSString *)changeTimeTo:(NSString *)str{
    int m = [str intValue];
    int minutes = m/60;
    int seconds = m-minutes*60;
    return [NSString stringWithFormat:@"%d\' %d\"",minutes,seconds];
}


@end
