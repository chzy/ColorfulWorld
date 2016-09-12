//
//  PlayerViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/17.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "PlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlayerViewController ()
{
    MPMoviePlayerViewController *_mp;
}
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSURL *url = [NSURL fileURLWithPath:_videoUrl];
    
      _mp = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    _mp.view.frame = self.view.frame;
    NSLog(@"%@",_videoUrl);
    [self.view addSubview:_mp.view];
    UIImage *im = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:im forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
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
