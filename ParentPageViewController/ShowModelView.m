//
//  ShowModelViewController.m
//  EyePetizer
//
//  Created by chzy on 15/11/12.
//  Copyright (c) 2015年 chzy. All rights reserved.
//

#import "ShowModelView.h"
#import "UIImageView+WebCache.h"
#import "PlayerView.h"
#import "CoreDataManager.h"
#import "WHC_DownloadFileCenter.h"
#import "CacheModel.h"

@interface ShowModelView ()<WHCDownloadDelegate>
{
    NSString *_words;
    UIImageView *_infoImView;
    UIImageView *_pictureImView;
 
    BOOL _isCollected;
    CoreDataManager *_coreDataManager;
    BOOL _isDownload;
  
    WHC_DownloadFileCenter *downManager;
    CacheModel *_cacheModel;
    UILabel *_downloadLb;
    UILabel *_collectedLb;
    UILabel *_sharedLb;
}
@end

@implementation ShowModelView


- (instancetype)initWithFrame:(CGRect)frame AndModel:(DailyModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
         _Model = model;
        [self configUI];
       
    }
    return self;
}

- (void)configUI{

    _coreDataManager = [CoreDataManager sharedManager];
    _cacheModel = [[CacheModel alloc]init];
     NSDictionary *cover = _Model.cover;
    _infoImView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _infoImView.backgroundColor = [UIColor whiteColor];
    _infoImView.frame = CGRectMake(0, 0, KSize.width, 240);
    _infoImView.center = CGPointMake(KSize.width/2, KSize.height-110);
    [_infoImView sd_setImageWithURL:[NSURL URLWithString:[cover objectForKey:@"blurred"]]];
   
  

    _pictureImView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, KSize.width, KSize.height-280)];
    //[_pictureImView sd_setImageWithURL:[NSURL URLWithString:cover[@"detail"]]];
    [_pictureImView sd_setImageWithURL:[NSURL URLWithString:[cover objectForKey:@"detail"]] placeholderImage:nil options:SDWebImageRefreshCached];
    _pictureImView.contentMode = UIViewContentModeScaleAspectFill;
    _pictureImView.clipsToBounds = YES;
  
        
  
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, KSize.width, 21)];
    title.text =[NSString stringWithFormat:@"     %@", _Model.title];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    title.textAlignment = NSTextAlignmentLeft;
    [_infoImView addSubview:title];
    CGFloat f = title.text.length*10;
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(24, 58, f, 1)];
    labelLine.backgroundColor = [UIColor whiteColor];
    [_infoImView addSubview:labelLine];
   
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 68, f, 10)];
    NSString *Category = _Model.category;
    NSString *times = _Model.duration;
    detailLabel.text = [NSString stringWithFormat:@"#%@    /   %@",Category,[self changeTimeTo:times]];
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];

    [_infoImView addSubview:detailLabel];
        [self addSubview:_infoImView];
    UILabel *desciptionLb = [[UILabel alloc]initWithFrame:CGRectMake(16, 78, KSize.width-32, 80)];
    


    desciptionLb.numberOfLines = 0;
    desciptionLb.tag = 100;
    desciptionLb.text = _Model.descriptionx;
    desciptionLb.lineBreakMode = NSLineBreakByClipping;
    desciptionLb.backgroundColor = [UIColor clearColor];
    desciptionLb.textColor = [UIColor whiteColor];
    desciptionLb.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    [_infoImView addSubview:desciptionLb];
    
    PlayerView *playerView = [[PlayerView alloc]initWithFrame:CGRectMake(0, 0, 190, 190)];
    playerView.backgroundColor = [UIColor clearColor];
    playerView.center = CGPointMake(_pictureImView.center.x, _pictureImView.center.y-55);
    [_pictureImView addSubview:playerView];
    //  收藏按钮
    UIButton *collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(24, 170, 35, 35)];
  
  
    _isCollected = [_coreDataManager isCollected:_Model];
    

    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [collectionBtn addTarget:self action:@selector(collectionOrUndo:) forControlEvents:UIControlEventTouchUpInside];
    _collectedLb = [[UILabel alloc]initWithFrame:CGRectMake(68, 171, 50, 30)];
    _collectedLb.backgroundColor = [UIColor clearColor];
    _collectedLb.textColor = [UIColor whiteColor];
    _collectedLb.font = [UIFont systemFontOfSize:18];
    NSDictionary *dicconsumption = _Model.consumption;
    _collectedLb.text = [NSString stringWithFormat:@"%@",[dicconsumption objectForKey:@"collectionCount"]];
    if (_isCollected) {
        [collectionBtn setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        _collectedLb.text = [NSString stringWithFormat:@"%ld",[_collectedLb.text integerValue]+1];
    }else{
     
    }
    [_infoImView addSubview:collectionBtn];
    [_infoImView addSubview:_collectedLb];
 
    _infoImView.userInteractionEnabled = YES;
    
    //  分享按钮
    UIButton *sharedBtn = [[UIButton alloc]initWithFrame:CGRectMake(134, 173, 28, 28)];
    [sharedBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [sharedBtn addTarget:self action:@selector(shareTheVideo) forControlEvents:UIControlEventTouchUpInside];
    _sharedLb = [[UILabel alloc]initWithFrame:CGRectMake(181, 171, 50, 30)];
    _sharedLb.backgroundColor = [UIColor clearColor];
    _sharedLb.textColor = [UIColor whiteColor];
    _sharedLb.font = [UIFont systemFontOfSize:18];
    _sharedLb.text = [NSString stringWithFormat:@"%@",[_Model.consumption objectForKey:@"shareCount"]];
    [_infoImView addSubview:_sharedLb];
    [_infoImView addSubview:sharedBtn];
    
    
    _isDownload = [_coreDataManager isExCache:_Model.title];
    
  
  
    downManager = [WHC_DownloadFileCenter sharedWHCDownloadFileCenter];
    
    UIButton *downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(247, 171, 30, 30)];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadVideo) forControlEvents:UIControlEventTouchUpInside];
    [_infoImView addSubview:downloadBtn];
    _downloadLb = [[UILabel alloc]initWithFrame:CGRectMake(294, 171, 40, 24)];
    _downloadLb.backgroundColor = [UIColor clearColor];
    _downloadLb.textColor = [UIColor whiteColor];
    _downloadLb.font = [UIFont systemFontOfSize:18];
    _downloadLb.adjustsFontSizeToFitWidth = YES;
    //  下载按钮
    if (_isDownload) {
        
        _downloadLb.text = [_coreDataManager byName:_Model.title];
        if ([_downloadLb.text isEqualToString:@"已缓存"]) {
            _downloadLb.textColor = [UIColor grayColor];
            downloadBtn.enabled = NO;
            downloadBtn.alpha = 0.7;
        }
    }else{
    
    }
   
    [_infoImView addSubview:_downloadLb];
    [self addSubview:_pictureImView];
    [self addTapGesture:_pictureImView];
    _pictureImView.userInteractionEnabled = YES;
    _coreDataManager = [CoreDataManager sharedManager];
    
}
- (void)collectionOrUndo:(UIButton *)Btn{
    if (!_isCollected) {
        [Btn setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
         _isCollected = YES;
        [_coreDataManager saveModel:_Model];
         _collectedLb.text = [NSString stringWithFormat:@"%ld",[_collectedLb.text integerValue]+1];
    }else{
         _isCollected = NO;
        [_coreDataManager deleteModel:_Model];
         [Btn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
       _collectedLb.text = [NSString stringWithFormat:@"%ld",[_collectedLb.text integerValue]-1];
        
    }
}
- (void)shareTheVideo{
    NSDictionary *dict = @{@"model":_Model,@"image":_pictureImView.image};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShareFavorit" object:nil userInfo:dict];
    NSInteger n = [_sharedLb.text integerValue];
    _sharedLb.text = [NSString stringWithFormat:@"%ld",n+1];
}
- (void)downloadVideo{
    [downManager startDownloadWithURL:[NSURL URLWithString:_Model.playUrl] savePath:[NSString stringWithFormat:@"%@/Library/Caches/Chzyvideo/",NSHomeDirectory()] savefileName:_Model.title delegate:self];
    
    _cacheModel.name = _Model.title;
    _cacheModel.path = [NSString stringWithFormat:@"%@/Library/Caches/Chzyvideo/%@.mp4",NSHomeDirectory(),_Model.title];
    NSLog(@"%@",_cacheModel.path);
}
- (void)WHCDownload:(WHC_Download *)download didReceivedLen:(uint64_t)receivedLen totalLen:(uint64_t)totalLen networkSpeed:(NSString *)networkSpeed{
    NSLog(@"%@",networkSpeed);
    NSLog(@"%lld",receivedLen);

    if (receivedLen!=totalLen) {
          _downloadLb.text = [NSString stringWithFormat:@"%llu%% %@",receivedLen*100/totalLen,networkSpeed];
       
        _downloadLb.adjustsFontSizeToFitWidth = YES;
    }else{
        _downloadLb.text = @"已缓存";
    
    }
    _cacheModel.cover = _Model.cover;
    _cacheModel.progress = _downloadLb.text;
    [_coreDataManager saveCache:_cacheModel];
}

- (void)addTapGesture:(UIView *)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startMyVideo)];
    [view addGestureRecognizer:tap];
}
- (void)startMyVideo{
 
    _videoBlock (_Model.playUrl);
 
}
- (NSString *)changeTimeTo:(NSString *)str{
    int m = [str intValue];
    int minutes = m/60;
    int seconds = m-minutes*60;
    return [NSString stringWithFormat:@"%d\' %d\"",minutes,seconds];
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
