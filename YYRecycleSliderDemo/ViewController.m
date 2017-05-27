//
//  ViewController.m
//  YYRecycleSliderDemo
//
//  Created by Ryan on 2017/5/27.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import "ViewController.h"
#import "YYRecycleView.h"
#import "YYTestViewController.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <YYRecycleViewDelegate>

/* <#description#> */
@property (nonatomic,strong) YYRecycleView *recycleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGRect aRect = CGRectMake(0, ScreenHeight/2-100, ScreenWidth, 200);
//    NSArray *imageArray = [NSArray arrayWithObjects:@"img_00",@"img_01",@"img_02",@"img_03",@"img_04", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"cycle_image1",@"cycle_image2",@"cycle_image3",@"cycle_image4",@"cycle_image5",@"cycle_image6", nil];
//    NSArray *titleArray = [NSArray arrayWithObjects:@"阳光下的身影",@"泡沫之夏",@"冲出天际",@"花前月下",@"你好，你的名字", nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"大海",@"花",@"长灯",@"阳光下的身影",@"秋树",@"摩天轮", nil];
    self.recycleView = [[YYRecycleView alloc] initWithFrame:aRect withRecyclePageControlPositon:YYRecyclelPageControlPositionCenter withImages:imageArray withTitles:titleArray withPageChangeTime:2.0];
    self.recycleView.delegate = self;
    
    [self.view addSubview:self.recycleView];                 
    
    
}

- (void)clickPageAction:(NSInteger)index {
    
    NSLog(@"-----%ld",index);
    YYTestViewController *control = [[YYTestViewController alloc] init];
    [self presentViewController:control animated:true completion:nil];
}


@end

















































