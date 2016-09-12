//
//  PassEyeTableController.m
//  EyePetizer
//
//  Created by chzy on 15/11/13.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "PassEyeTableController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "DailyModel.h"
#import "MJRefresh.h"
#import "ParentView.h"
#import "WebVideoViewController.h"
@interface PassEyeTableController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    NSString *_nextUrl;
    BOOL _isRefresh;
    BOOL _IsOpen;
    ParentView *_parenVc;
    BOOL _LoadXMOre;
}
@end

@implementation PassEyeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc]init];
    _isRefresh = YES;
    _IsOpen = NO;
    [self createTableView];
    [self createDataSource];
    UIImage *im = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:im forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back{
    if(_IsOpen){
        _IsOpen = NO;
        [_parenVc removeFromSuperview];
        _MyShowOrHidenSetViewBlock(_IsOpen); 
    }else{
        [self.navigationController popViewControllerAnimated:NO];
   

    }
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.height-40)style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellide"];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isRefresh = YES;
        [self createDataSource];
    }];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isRefresh  = NO;
        [self createDataSource];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellide" forIndexPath:indexPath];
    DailyModel *model = _dataSource[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.width/2)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[model.cover objectForKey:@"detail"]]];
    UIView *coverView = [[UIView alloc]initWithFrame:imageView.frame];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.4;
    [imageView addSubview:coverView];
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
    titleLb.center = imageView.center;
    titleLb.text = model.title;
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    [imageView addSubview:titleLb];
    
    UILabel *detailLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 10)];
    detailLb.center = CGPointMake(imageView.center.x, imageView.center.y+30);
    detailLb.textAlignment = NSTextAlignmentCenter;
    NSString *Category = model.category;
    NSString *times = model.duration;
    
    titleLb.textColor = [UIColor whiteColor];
    detailLb.text = [NSString stringWithFormat:@"#%@ / %@",Category,[self changeTimeTo:times]];
    detailLb.textColor = [UIColor whiteColor];
    detailLb.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    [imageView addSubview:detailLb];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:imageView];
    return cell;

    
    
}
- (void)createDataSource{
    if (_isRefresh) {
        [_dataSource removeAllObjects];
        AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:_VideoURl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *perArray = [[NSMutableArray alloc]init];
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            _nextUrl = [dic1 objectForKey:@"nextPageUrl"];
            NSArray *array1 = [dic1 objectForKey:@"videoList"];
            for (NSDictionary *dic2 in array1) {
                DailyModel *model = [[DailyModel alloc]init];
                [model setValuesForKeysWithDictionary:dic2];
                [perArray addObject:model];
                [_dataSource addObject:model];
            }
            // [_dataSource addObject:perArray];
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }else{
        AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:_nextUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *perArray = [[NSMutableArray alloc]init];
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            _nextUrl = [dic1 objectForKey:@"nextPageUrl"];
            NSArray *array1 = [dic1 objectForKey:@"videoList"];
            for (NSDictionary *dic2 in array1) {
                DailyModel *model = [[DailyModel alloc]init];
                [model setValuesForKeysWithDictionary:dic2];
                [perArray addObject:model];
                [_dataSource addObject:model];
            }if (_LoadXMOre) {
                _parenVc.myShowMoreView = ^(){
                    _isRefresh= NO;
                    _LoadXMOre = YES;
                    
                    if (_parenVc != nil) {
                        [_parenVc removeFromSuperview];
                    }
               
                    
                };
            
                
                _LoadXMOre = NO;
            }
           // [_dataSource addObject:perArray];
            [_tableView reloadData];
            [_tableView.footer endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_parenVc != nil) {
        [_parenVc removeFromSuperview];
    }
    _parenVc = [[ParentView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.height) andArray:_dataSource and:indexPath.row];
    
    __weak PassEyeTableController *weakNowVC = self;
    _parenVc.VieoPlayBlock = ^(NSString *videoUrl){
        WebVideoViewController *webVc = [[WebVideoViewController alloc]init];
        webVc.videoUrl =videoUrl;
        [weakNowVC.navigationController pushViewController:webVc animated:NO];
    };
    _parenVc.myShowMoreView = ^(){
        _LoadXMOre = YES;
        _isRefresh = NO;
        [weakNowVC createDataSource];
        if (_parenVc != nil) {
            _parenVc = nil;
        }
     
        
    };

    [self.view addSubview:_parenVc];
    
   
    _IsOpen = YES;
    _MyShowOrHidenSetViewBlock(_IsOpen);
    _parenVc.mysetBlock = ^(){
        _IsOpen = YES;
        [self back];
    };
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return KSize.width/2;
}
- (NSString *)changeTimeTo:(NSString *)str{
    int m = [str intValue];
    int minutes = m/60;
    int seconds = m-minutes*60;
    return [NSString stringWithFormat:@"%d\' %d\"",minutes,seconds];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
