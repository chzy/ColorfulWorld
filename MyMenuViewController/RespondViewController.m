//
//  RespondViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/18.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "RespondViewController.h"

@interface RespondViewController ()

@end

@implementation RespondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
- (void)configUI{
    
    
    
    UIImage *im = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:im forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    UILabel *centerLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KSize.width, 50)];
    centerLb.backgroundColor = [UIColor whiteColor];
    centerLb.center = self.view.center;
    [self.view addSubview:centerLb];
    centerLb.textColor = [UIColor blackColor];
    centerLb.text = @"    您有任何好的意见请联系yang.chunzhi@hotmail.com";
    centerLb.numberOfLines = 0 ;
    centerLb.font = [UIFont systemFontOfSize:12];
    
}
- (void)back{
    
   [self.navigationController popViewControllerAnimated:NO];
    
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
