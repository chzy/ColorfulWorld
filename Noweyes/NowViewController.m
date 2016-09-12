//
//  NowViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "NowViewController.h"
#import "Setting.h"
#import "AFNetworking.h"
#define MAIN_URL @"http://baobab.wandoujia.com/api/v2/feed"
#import "UIImageView+WebCache.h"
#import "DailyModel.h"
#import "ParentView.h"//
#import "WebVideoViewController.h"
#import "MJRefresh.h"
#import "MyStoreViewController.h"
#import "MyCacheViewController.h"
#import "UMSocial.h"
#import "RespondViewController.h"
#import "Reachability.h"
@interface NowViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SettingDelegaet>
{

    ParentView *_parenVc;
    UILabel *_naviLeftLb;//navigationbar左边显示当前时间的label
    UIBarButtonItem *_leftItemLb;
    UIBarButtonItem *_leftItem;
    NSMutableArray *_leftItemArray;
    BOOL _IsRefresh;
    UIBarButtonItem *_rightItme;
    UIButton *_rightBtn;
    Setting *_setView;
    BOOL _IsShow;//是否是setting状态
    BOOL _IsOpen;
    UITableView *_tabView;
    NSMutableArray *_dataSource;
    NSMutableArray *_netArray;
    NSString *_nextURL;
    UIView *_sectionHeaderView;
    UILabel *_secionLb;
    NSMutableArray *_sectiontitleArray;
    BOOL _isDetail;//is detail page
    BOOL _LoadXMOre;
   
}
@property (nonatomic,strong)Reachability *reach;
@end

@implementation NowViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ShareFavorit" object:nil];
}
//将要出现的时候
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isDetail = YES;
}
//将要消失的时候
- (void)viewWillDisappear:(BOOL)animated{
    _isDetail = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharedFavorite:) name:@"ShareFavorit" object:nil];
    _IsShow = NO;
    _IsOpen = NO;
    _IsRefresh = YES;
    [self configNaBar];
    _netArray = [[NSMutableArray alloc]initWithObjects:MAIN_URL, nil];
    _dataSource = [[NSMutableArray alloc]init];
    _sectiontitleArray = [[NSMutableArray alloc]initWithObjects:@"Today", nil];
    [self createDataSource];
}
 #pragma clang diagnostic push
- (void)sharedFavorite:(NSNotification*)no{
    
    DailyModel *model = [no.userInfo objectForKey:@"model"];
    UIImage *im = [no.userInfo objectForKey:@"image"];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5647149ce0f55ac973002cdb" shareText:[NSString stringWithFormat:@"%@",model.descriptionx] shareImage:im shareToSnsNames:@[UMShareToSina,UMShareToSms] delegate:self];
    NSLog(@"分享");

    
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    
}
- (void)configNaBar{
    _naviLeftLb = [[UILabel alloc]initWithFrame:CGRectMake(26,0, 40,30)];
    _naviLeftLb.text = @"Today";
    _naviLeftLb.font = [UIFont fontWithName:@"Zapfino" size:8];
    _naviLeftLb.backgroundColor = [UIColor clearColor];
    _naviLeftLb.textColor = [UIColor blackColor];
    _naviLeftLb.textAlignment = NSTextAlignmentCenter;
    _leftItemLb = [[UIBarButtonItem alloc]initWithCustomView:_naviLeftLb];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(26, 0, 30, 30)];
 
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    UIImage *im = [[UIImage imageNamed:@"setting1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBtn setBackgroundImage:im forState:UIControlStateNormal];
    _leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    _leftItemArray =[ @[_leftItem]mutableCopy];
    self.navigationItem.leftBarButtonItems =_leftItemArray;
    leftBtn.transform = CGAffineTransformMakeRotation(M_PI*2);
    [leftBtn addTarget:self action:@selector(showOrHideSetView:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    if (_IsShow) {
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    }else{
        if(_IsOpen){
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"fork"] forState:UIControlStateNormal];
        }
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
    }
    [_rightBtn addTarget:self action:@selector(setMenuOrOpenView) forControlEvents:UIControlEventTouchUpInside];
    _rightItme = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem =_rightItme;
    
    _setView = [[Setting alloc]initWithFrame:CGRectMake(0, -KSize.height-64.9, KSize.width, KSize.height-64.9)];
    _setView.userInteractionEnabled = YES;
#pragma mark set的代理
    _setView.Delegate = self;
  //在setview之前加入tableview
    _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.height-40)style:UITableViewStylePlain];
//    [_tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellide"];
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tabView];
    [self.view addSubview:_setView];
    _tabView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _IsRefresh = YES;
        [self createDataSource];
    }];
    
    _tabView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _IsRefresh  = NO;
        [self createDataSource];
    }];

    
  
  //title
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 24)];
    titleLabel.text = @"Colorful World";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"Zapfino" size:12];
    self.navigationItem.titleView = titleLabel;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource.count == 0) {
        return 0;
    }else
    return ((NSArray *)(_dataSource[section])).count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLIDE = @"celll";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDE];
    }
    DailyModel *model = _dataSource[indexPath.section][indexPath.row];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_parenVc != nil) {
        [_parenVc removeFromSuperview];
    }
    _parenVc = [[ParentView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.height) andArray:_dataSource[indexPath.section] and:indexPath.row];
    _isDetail = YES;
    __weak NowViewController *weakNowVC = self;
    _parenVc.VieoPlayBlock = ^(NSString *videoUrl){
        WebVideoViewController *webVc = [[WebVideoViewController alloc]init];
        webVc.videoUrl =videoUrl;
        [weakNowVC.navigationController pushViewController:webVc animated:NO];
    };
   
    _parenVc.myShowMoreView = ^(){
        _IsRefresh = NO;
        _LoadXMOre = YES;
        [weakNowVC createDataSource];
        if (_parenVc != nil) {
            _parenVc = nil;
        }
        _isDetail = YES;
        _IsRefresh = NO;

    };
        [self.view addSubview:_parenVc];
    
     [self.view insertSubview:_setView aboveSubview:_parenVc];
    _IsOpen = YES;
    _rightBtn.hidden = NO;
      [_rightBtn setBackgroundImage:[UIImage imageNamed:@"fork"] forState:UIControlStateNormal];
    _MyShowOrHidenSetViewBlock(_IsOpen);
    _parenVc.mysetBlock = ^(){
        _IsOpen = YES;
        [self setMenuOrOpenView];
    };
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
#pragma mark SectionHeadView ----
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    if (_sectiontitleArray.count == 0) {
        return nil;
    }else{
    _sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, 35)];
    _sectionHeaderView.backgroundColor = [UIColor whiteColor];
    _secionLb = [[UILabel alloc]initWithFrame:CGRectZero];
    _secionLb.frame = CGRectMake(0, 0, KSize.width, 22);
    _secionLb.center = CGPointMake(_sectionHeaderView.center.x, _sectionHeaderView.center.y+5);
    [_sectionHeaderView addSubview:_secionLb];
    _secionLb.backgroundColor = [UIColor clearColor];
    _secionLb.textColor = [UIColor blackColor];
    _secionLb.textAlignment = NSTextAlignmentCenter;
    _secionLb.font = [UIFont fontWithName:@"Zapfino" size:12];
        NSLog(@"%ld",section);
        NSLog(@"%@",_sectiontitleArray[section]);
   NSString   *str = _sectiontitleArray.lastObject;
        if (str.length >15) {
            UIImageView *vi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 28)];
            vi.center = _sectionHeaderView.center;
            [vi sd_setImageWithURL:[NSURL URLWithString:str]];
            [_sectionHeaderView addSubview:vi];
        }else{
            _secionLb.text = str;
        }
        return _sectionHeaderView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0001;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return  0.001;
    }
    return 0.01;
}
- (NSString *)changeTimeTo:(NSString *)str{
    int m = [str intValue];
    int minutes = m/60;
    int seconds = m-minutes*60;
    return [NSString stringWithFormat:@"%d\' %d\"",minutes,seconds];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KSize.width/2;
}
- (void)showOrHideSetView:(UIButton *)btn{
    if (!_IsShow) {
        //降下来 0
        [UIView animateWithDuration:0.2 animations:^{
            _setView.frame = CGRectMake(0,65,KSize.width, KSize.height);
            _IsShow = YES;
            btn.transform = CGAffineTransformMakeRotation(M_PI/2);
        }];
    }else{
        //升上去 1
        [UIView animateWithDuration:0.2 animations:^{
            _setView.frame = CGRectMake(0, -KSize.height-64.9, KSize.width, KSize.height-64.9);
            _IsShow = NO;
           btn.transform = CGAffineTransformMakeRotation(M_PI*2);
        }];
        
    }
    if (_IsShow) {
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    }else{
        if(_IsOpen){
            _rightBtn.hidden = NO;
            [_rightBtn setBackgroundImage:[UIImage imageNamed:@"fork"] forState:UIControlStateNormal];
        }else
        _rightBtn.hidden = YES;
    }

   if (_IsOpen) {
        NSLog(@"~~~~~~");
   }
   else{
            _MyShowOrHidenSetViewBlock(_IsShow);
    }
}
- (void)setMenuOrOpenView{
    if (_IsShow) {
        NSLog(@"set");
        
        
    }else{
       
        if (_IsOpen) {
            NSLog(@"");
            _IsOpen = NO;
            _MyShowOrHidenSetViewBlock(_IsOpen);
           [_parenVc removeFromSuperview];
      
            [self.view bringSubviewToFront:_tabView];
            [self.view bringSubviewToFront:_setView];
           _rightBtn.hidden = YES;
            NSLog(@"exist");
        }else{
             _rightBtn.hidden = NO;
            NSLog(@"open");
        }
    }
    
}
#pragma mark createDataSource
- (void)createDataSource{
    if (self.reach.currentReachabilityStatus == NotReachable) {
        [_tabView.header endRefreshing];
        [_tabView.footer endRefreshing];
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"糟糕" message:@"断网了" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles: nil];
        [al show];
    }
 
        if (_IsRefresh) {
            if (_dataSource.count!=0) {
                 [_dataSource removeAllObjects];
            }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.securityPolicy  setAllowInvalidCertificates:YES];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:MAIN_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *perArray = [[NSMutableArray alloc]init];
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
            NSArray *arr1 =[dic1 objectForKey:@"issueList"];
            NSDictionary *dic2 = arr1.lastObject;
            NSArray *arr2 = [dic2 objectForKey:@"itemList"];
            for (NSDictionary *dic3 in arr2) {
                NSDictionary *dic4 = [dic3 objectForKey:@"data"];
                DailyModel *model = [[DailyModel alloc]init];
                [model setValuesForKeysWithDictionary:dic4];
                if (model.title != nil) {
                    [perArray addObject:model];
                }
                
            }
            [_dataSource addObject:perArray];
            [_tabView.header endRefreshing];
            _nextURL  = [dic1 objectForKey:@"nextPageUrl"];
       
            [_tabView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
    else{
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
          [manager.securityPolicy  setAllowInvalidCertificates:YES];
            [manager GET:_nextURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSLog(@"%@",_nextURL);
                NSMutableArray *perArray = [[NSMutableArray alloc]init];
                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

                NSArray *arr1 =[dic1 objectForKey:@"issueList"];
                NSDictionary *dic2 = arr1.lastObject;
                NSArray *arr2 = [dic2 objectForKey:@"itemList"];
                for (NSDictionary *dic3 in arr2) {
                    NSDictionary *dic4 = [dic3 objectForKey:@"data"];
                    DailyModel *model = [[DailyModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic4];
                    //NSLog(@"%@",model.title);
              
                    if (model.descriptionx != nil) {
                        [perArray addObject:model];
                      //  NSLog(@"%ld",_dataSource.count);
                    }
                  else{
                      if (model.text != nil) {
                     [_sectiontitleArray addObject:[dic4 objectForKey:@"text"]];
                      }
                      else if(model.image != nil){
                          [_sectiontitleArray addObject:[dic4 objectForKey:@"image"]];
                      }
                    }
               }
                
                   [_dataSource addObject:perArray];
                 _nextURL  = [dic1 objectForKey:@"nextPageUrl"];
                
                 [_tabView.footer endRefreshing];
                 [_tabView reloadData];
                if(_LoadXMOre){
                       _parenVc = [[ParentView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.height) andArray:_dataSource.lastObject and:0];
                    [self.view addSubview:_parenVc];
                    _LoadXMOre = NO;
                    _parenVc.myShowMoreView = ^(){
                        _IsRefresh = NO;
                        _LoadXMOre = YES;
                 
                        if (_parenVc != nil) {
                            [_parenVc removeFromSuperview];
                        }
                        _isDetail = YES;
         
                    };
                    [self.view insertSubview:_setView aboveSubview:_parenVc];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
 
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (void)openMyStore{
    MyStoreViewController *myStoreVC = [[MyStoreViewController alloc]init];
    [self.navigationController pushViewController:myStoreVC animated:NO];
}

- (void)openMyCache{
    MyCacheViewController *myCache = [[MyCacheViewController alloc]init];
    [self.navigationController pushViewController:myCache animated:NO];
}

- (void)sendYouAdvice{
    RespondViewController *re = [[RespondViewController alloc]init];
    [self.navigationController pushViewController:re animated:NO];
}
- (void)sendMyLove{
    RespondViewController *re = [[RespondViewController alloc]init];
    [self.navigationController pushViewController:re animated:NO];
}
- (Reachability *)reach{
    if (_reach==nil) {
        _reach = [Reachability reachabilityForInternetConnection];
    
    }
    return  _reach;
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
