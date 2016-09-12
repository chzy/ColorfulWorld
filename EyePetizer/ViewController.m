//
//  ViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/11.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "ViewController.h"
#import "NowViewController.h"
#import "PassViewController.h"
#import "CoreDataManager.h"

@interface ViewController ()
{
    NSArray *_controllersArray;
    BOOL _isNowEyes;
    UIView *_chooseView;
    UIButton *_nowBtn;
    UIButton *_passBtn;
    UINavigationController *_naVc1;
    UINavigationController *_naVc2;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CoreDataManager *manager = [CoreDataManager sharedManager];

    [manager createContext];
  
    _isNowEyes = 1;
    self.view.backgroundColor = [UIColor blackColor];
    NowViewController *nowVc = [[NowViewController alloc]init];
    nowVc.MyShowOrHidenSetViewBlock = ^(BOOL n){
        if (n) {
            [UIView animateWithDuration:0.2 animations:^{
                _chooseView.frame = CGRectMake(0, KSize.height, KSize.width, 40);               //[Vi.view insertSubview:_chooseView belowSubview:_naVc1.view];
            }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                _chooseView.frame = CGRectMake(0, KSize.height-40, KSize.width, 40);
               //[Vi.view insertSubview:_naVc1.view belowSubview:_chooseView];
            }];
            
    }
    };
    
    _naVc1 =[[UINavigationController alloc]initWithRootViewController:nowVc];
    _naVc1.navigationBar.barTintColor = [UIColor whiteColor];
    
    PassViewController *passVc = [[PassViewController alloc]init];
    _naVc2 = [[UINavigationController alloc]initWithRootViewController:passVc];
    
    passVc.MyShowOrHidenSetViewBlock = ^(BOOL n){
        if (n) {
            [UIView animateWithDuration:0.2 animations:^{
                _chooseView.frame = CGRectMake(0, KSize.height, KSize.width, 40);               //[Vi.view insertSubview:_chooseView belowSubview:_naVc1.view];
            }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                _chooseView.frame = CGRectMake(0, KSize.height-40, KSize.width, 40);
                //[Vi.view insertSubview:_naVc1.view belowSubview:_chooseView];
            }];
            
        }
        
    };
    
    
    _naVc2.navigationBar.barTintColor = [UIColor whiteColor];
    _controllersArray = @[_naVc1,_naVc2];
    
    //
    _chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, KSize.height-40, KSize.width, 40)];
    _chooseView.backgroundColor = kUIColorFromRGB(0xDCDCDC);
    [self.view addSubview:_chooseView];
    //左边按键
    _nowBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [_nowBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_nowBtn setTitle:@"每日精选" forState:UIControlStateNormal];
    _nowBtn.frame = CGRectMake(0, 0, KSize.width/4, 20);
    _nowBtn.center = CGPointMake(KSize.width/4, 20);
    [_chooseView addSubview:_nowBtn];
    
    //右边按键
    
    _passBtn =  [[UIButton alloc]initWithFrame:CGRectZero];
    [_passBtn setTitle:@"往期分类" forState:UIControlStateNormal];
    [_passBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _passBtn.frame = CGRectMake(0, 0, KSize.width/4, 20);
    _passBtn.center = CGPointMake(KSize.width/4*3, 20);
    [_chooseView addSubview:_passBtn];
    
    UILabel *middleLb = [[UILabel alloc]initWithFrame:CGRectZero];
    middleLb.textColor = [UIColor grayColor];
    middleLb.text = @"|";
    middleLb.font = [UIFont systemFontOfSize:20];
    middleLb.backgroundColor = [UIColor clearColor];
    middleLb.frame =CGRectMake(0, 0, 28, 30);
    middleLb.center = CGPointMake(KSize.width/2, 20);
    [_chooseView addSubview:middleLb];
    
    
    [_nowBtn addTarget:self action:@selector(nowEyes) forControlEvents:UIControlEventTouchUpInside];
    [_passBtn addTarget:self action:@selector(passEyes) forControlEvents:UIControlEventTouchUpInside];
 
    [_nowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [_passBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [self chooseBtnColor];
    [self.view addSubview: _naVc1.view];
    [self.view insertSubview:_naVc1.view belowSubview:_chooseView];
}
- (void)nowEyes{
    _isNowEyes = 1;
    [_naVc2.view removeFromSuperview];
    [self.view addSubview: _naVc1.view];
    [self.view insertSubview:_naVc1.view belowSubview:_chooseView];
    [self chooseBtnColor];
    
}
- (void)passEyes{
    _isNowEyes = 0;
    [_naVc1.view removeFromSuperview];
    [self.view addSubview: _naVc2.view];
    [self.view insertSubview:_naVc2.view belowSubview:_chooseView];
    [self chooseBtnColor];
}
- (void)chooseBtnColor{
    if (_isNowEyes) {
        _nowBtn.enabled = NO;
        _passBtn.enabled =YES;
    }else{
        _nowBtn.enabled = YES;
        _passBtn.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
