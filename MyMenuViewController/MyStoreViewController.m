
//
//  MyStoreViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/14.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "MyStoreViewController.h"
#import "CoreDataManager.h"
#import "MyCollection.h"
#import "UIImageView+WebCache.h"
#import "ParentView.h"
#import "WebVideoViewController.h"
@interface MyStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    CoreDataManager *_manager;
    ParentView *_parentView;
    BOOL _isOpen;
}
@end

@implementation MyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收藏";
    [self initializeManager];
    [self createDataSource];
    [self configUI];
}
- (void)initializeManager{
    _manager = [CoreDataManager sharedManager];
}
- (void)createDataSource{
    _dataSource = [[_manager searchMyStore] mutableCopy];
 
}
- (void)configUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    UIImage *im = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:im forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back{
    if (_isOpen) {
        _isOpen = NO;
        [_parentView removeFromSuperview];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
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
    MyCollection *model = _dataSource[indexPath.row];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KSize.width/2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_parentView != nil) {
        [_parentView removeFromSuperview];
    }
    _isOpen = YES;
    __weak MyStoreViewController *weakNowVC = self;
    _parentView = [[ParentView alloc]initWithFrame:self.view.frame andArray:_dataSource and:indexPath.row];
    [self.view addSubview:_parentView];
    _parentView.VieoPlayBlock = ^(NSString *videoUrl){
        WebVideoViewController *webVc = [[WebVideoViewController alloc]init];
        webVc.videoUrl =videoUrl;
        [weakNowVC.navigationController pushViewController:webVc animated:NO];
    };
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
