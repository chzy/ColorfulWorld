
//
//  PassViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//
#define  PASS_URL @"http://baobab.wandoujia.com/api/v2/categories"
#import "PassViewController.h"
#import "Setting.h"
#import "AFNetworking.h"
#import "PassWallModel.h"
#import "UIImageView+WebCache.h"
#import "PassEyeTableController.h"
#import "MyStoreViewController.h"
#import "UMSocial.h"
#import "DailyModel.h"
#import "MyCacheViewController.h"
#import "RespondViewController.h"
#import "Reachability.h"
@interface PassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SettingDelegaet>
{
  
    UIBarButtonItem *_leftItem;
    NSMutableArray *_leftItemArray;
    
    UIBarButtonItem *_rightItme;
    UIButton *_rightBtn;
    Setting *_setView;
    BOOL _IsShow;//是否是setting状态
    UICollectionView *_myCollectionView;
    NSMutableArray *_dataSource;
    NSMutableArray *_netDataSources;
}
@property (nonatomic,strong)Reachability *reach;
@end

@implementation PassViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   _MyShowOrHidenSetViewBlock(_IsShow);
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ShareFavorit" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharedFavorite:) name:@"ShareFavorit" object:nil];
     _IsShow = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _netDataSources = [[NSMutableArray alloc]initWithObjects:@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E5%88%9B%E6%84%8F",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E8%BF%90%E5%8A%A8",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E6%97%85%E8%A1%8C",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E5%89%A7%E6%83%85",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E5%8A%A8%E7%94%BB",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E5%B9%BF%E5%91%8A",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E9%9F%B3%E4%B9%90",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E5%BC%80%E8%83%83",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E9%A2%84%E5%91%8A",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E7%BB%BC%E5%90%88",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E8%AE%B0%E5%BD%95&udid=fb2d1c2da4ff4070bdf077938ad6e916e8f3bd46",@"http://baobab.wandoujia.com/api/v2/videos?categoryName=%E6%97%B6%E5%B0%9A",nil];
    [self configNaBAr];
    [self downLoadData];
    [self createCollectionView];
}
- (void)configNaBAr{
   
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(26, 0, 30, 30)];
    
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    UIImage *im = [[UIImage imageNamed:@"setting1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBtn setBackgroundImage:im forState:UIControlStateNormal];
    _leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    _leftItemArray =[ @[_leftItem]mutableCopy];
    self.navigationItem.leftBarButtonItems =_leftItemArray;
    leftBtn.transform = CGAffineTransformMakeRotation(M_PI*2);
    [leftBtn addTarget:self action:@selector(showOrHideSetView:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];

        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    
    [_rightBtn addTarget:self action:@selector(setMenu) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.hidden = YES;
    _rightItme = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem =_rightItme;
    
    _setView = [[Setting alloc]initWithFrame:CGRectMake(0, -KSize.height-64.9, KSize.width, KSize.height-64.9)];
    _setView.Delegate = self;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 24)];
    titleLabel.text = @"Colorful World";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"Zapfino" size:12];
    self.navigationItem.titleView = titleLabel;
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
       // _rightBtn.backgroundColor = [UIColor blackColor];
        _rightBtn.hidden = NO;
    }else{
        _rightBtn.hidden = YES;
        //_rightBtn.backgroundColor = [UIColor yellowColor];
    }
    _MyShowOrHidenSetViewBlock(_IsShow);
}
- (void)setMenu{
    NSLog(@"hahah");
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 4;

    layout.itemSize = CGSizeMake(KSize.width/2-4, KSize.width/2-4);
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KSize.width, KSize.height-41) collectionViewLayout:layout];
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.bounces = NO;
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    [self.view addSubview:_myCollectionView];
     [self.view addSubview:_setView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PassWallModel *model = _dataSource[indexPath.row];
    UIImageView *imView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSize.width/2-2, KSize.width/2-2)];
    [imView sd_setImageWithURL:[NSURL URLWithString:model.bgPicture]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
    label.text =[NSString stringWithFormat:@"~#%@",model.name];
    label.center = imView.center;
    label.textColor = [UIColor whiteColor];
    label.userInteractionEnabled = NO;
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    [imView addSubview:label];
    [cell.contentView addSubview:imView];
    return cell;
}
- (void)downLoadData{
    if (self.reach.currentReachabilityStatus == NotReachable) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"糟糕网断了" message:@"请确认网络连接" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [al show];
    }

    _dataSource = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:PASS_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic  in array) {
            PassWallModel *model = [[PassWallModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataSource addObject:model];
        }
        [_myCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PassEyeTableController *passTVc = [[PassEyeTableController alloc]init];
    passTVc.VideoURl = _netDataSources[indexPath.row];
    PassWallModel *model = _dataSource [indexPath.row];
    passTVc.title = model.name;
    passTVc.MyShowOrHidenSetViewBlock = ^(BOOL n){
       _MyShowOrHidenSetViewBlock(n);
    };
    [self.navigationController pushViewController:passTVc animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)openMyStore{
    MyStoreViewController *myStoreVC = [[MyStoreViewController alloc]init];
    [self.navigationController pushViewController:myStoreVC animated:NO];
}
- (void)sharedFavorite:(NSNotification*)no{
    
    DailyModel *model = [no.userInfo objectForKey:@"model"];
    UIImage *im = [no.userInfo objectForKey:@"image"];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5647149ce0f55ac973002cdb" shareText:[NSString stringWithFormat:@"%@",model.descriptionx] shareImage:im shareToSnsNames:@[UMShareToSina,UMShareToSms] delegate:self];
   // NSLog(@"分享");
    
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

- (void)openMyCache{
    MyCacheViewController *myCache = [[MyCacheViewController alloc]init];
    [self.navigationController pushViewController:myCache animated:NO];
}
- (void)sendMyLove{
    RespondViewController *re = [[RespondViewController alloc]init];
    [self.navigationController pushViewController:re animated:NO];
}
- (void)sendYouAdvice{
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
