//
//  YYRecycleView.m
//  YYRecycleSliderDemo
//
//  Created by Ryan on 2017/5/27.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import "YYRecycleView.h"

#define Calculte_Index(x,y) (x+y)%y //计算循环索引

@interface YYRecycleView () <UIScrollViewDelegate>

/* <#description#> */
@property (nonatomic,strong) UIScrollView *scrollView;
/* <#description#> */
@property (nonatomic,strong) UIPageControl *pageControl;
/* <#description#> */
@property (nonatomic,strong) NSTimer *timer;
/* <#description#> */
@property (nonatomic,strong) UIImageView *leftImageView;
/* <#description#> */
@property (nonatomic,strong) UIImageView *centerImageView;
/* <#description#> */
@property (nonatomic,strong) UIImageView *rightImageView;
/* <#description#> */
@property (nonatomic,assign) NSUInteger currentIndex;
/* <#description#> */
@property (nonatomic,strong) NSArray *images;
/* <#description#> */
@property (nonatomic,strong) NSArray *titles;
/* <#description#> */
@property (nonatomic,assign) YYRecyclePageControlPosition recyclePageControlPositon;
/* <#description#> */
@property (nonatomic,assign) NSTimeInterval pageChangeTime;
/* <#description#> */
@property (nonatomic,strong) UILabel *desLabel;

@end

@implementation YYRecycleView

//MARK:-懒加载
- (NSArray *)images {
    if (_images == nil) {
        _images = [[NSArray alloc] init];
    }
    return _images;
}

- (NSArray *)titles {
    if (_titles == nil) {
        _titles = [[NSArray alloc] init];
    }
    return _titles;
}
//MARK:- 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame withRecyclePageControlPositon:(YYRecyclePageControlPosition)recyclePageControlPositon withImages:(NSArray *)images withTitles:(NSArray *)titles withPageChangeTime:(NSTimeInterval)pageChangeTime {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.images = images;
        self.titles = titles;
        self.pageChangeTime = pageChangeTime;
        self.currentIndex = 0;
        
        [self configRecycleLayout:frame recyclePageControlPositon:recyclePageControlPositon];
        
        //给滑动View添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRecycleView:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

//MARK:- 界面控件创建
- (void)configRecycleLayout:(CGRect)frame recyclePageControlPositon:(YYRecyclePageControlPosition)recyclePageControlPositon{
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    //UIScrollView
    CGRect aRect = CGRectMake(0, 0, width, height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:aRect];
    self.scrollView.contentSize = CGSizeMake(3 * width, height);
    self.scrollView.contentOffset = CGPointMake(width, self.scrollView.frame.origin.y); //显示第一张图片
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    self.scrollView.bounces = false;
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = true;
    [self addSubview:self.scrollView];
    
    //3个UIImageView
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*width, 0, width, height)];
    //添加图片控件到UIScrollView上
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    //UILable
    self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,height-40, width, 40)];
    self.desLabel.backgroundColor = [UIColor clearColor];
    self.desLabel.textColor = [UIColor redColor];
    self.desLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.desLabel];
    
    //UIPageControl
    self.pageControl = [[UIPageControl alloc] init];
    switch (recyclePageControlPositon) {
        case YYRecyclelPageControlPositionLeft:
            self.pageControl.frame = CGRectMake(30, height - 30, 100, 30);
            self.desLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case YYRecyclelPageControlPositionCenter:
            self.pageControl.frame = CGRectMake(width/2 - 50, height - 30, 100, 30);
            self.desLabel.textAlignment = NSTextAlignmentRight;
            break;
        case YYRecyclelPageControlPositionRight:
            self.pageControl.frame = CGRectMake(width - 30 - 100, height - 30, 100, 30);
            self.desLabel.textAlignment = NSTextAlignmentLeft;
            break;
        default:
            break;
    }
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.images.count;
    [self addSubview:self.pageControl];

    // 初始化赋值
    [self configImageViewWithImages:self.images];
}

//MARK:- 创建定时器
- (void)configTimer {
    
    self.timer = [NSTimer timerWithTimeInterval:self.pageChangeTime target:self selector:@selector(timeChanged) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//MARK:-给图片控件设置初始化图片
- (void)configImageViewWithImages:(NSArray *)images {
    
    if (images.count == 0) {
        NSLog(@"-- images is empty !");
        return;
    }
    
    self.leftImageView.image = [UIImage imageNamed:images[Calculte_Index(self.currentIndex - 1,images.count)]];
    self.centerImageView.image = [UIImage imageNamed:images[Calculte_Index(self.currentIndex,images.count)]];
    self.rightImageView.image = [UIImage imageNamed:images[Calculte_Index(self.currentIndex + 1,images.count)]];

    self.desLabel.text = self.titles[self.currentIndex];
    
    [self configTimer];
}

//MARK:-手动滑动或者定时器改变的时候改变图片和图片标题
- (void)changeImageAndTitleViewWith:(NSInteger)index {
    //改变图片
    self.leftImageView.image = [UIImage imageNamed:self.images[Calculte_Index(self.currentIndex - 1,self.images.count)]];
    self.centerImageView.image = [UIImage imageNamed:self.images[Calculte_Index(self.currentIndex,self.images.count)]];
    self.rightImageView.image = [UIImage imageNamed:self.images[Calculte_Index(self.currentIndex + 1,self.images.count)]];
    
    //改变标题
    self.desLabel.text = self.titles[index];
}


//MARK:-NSTimer Action
- (void)timeChanged {
    
    if (self.images == 0) {
        return;
    }
    self.currentIndex = Calculte_Index(self.currentIndex+1,self.images.count);
    self.pageControl.currentPage = self.currentIndex;
    [self changeImageAndTitleViewWith:self.currentIndex];
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, self.scrollView.frame.origin.y);
//    [UIView animateWithDuration:1 animations:^{
//        self.scrollView.contentOffset = CGPointMake(self.frame.size.width, self.scrollView.frame.origin.y);
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

//MARK:-UITapGestureRecognizer
- (void)clickRecycleView:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(clickPageAction:)]) {
        [self.delegate clickPageAction:self.currentIndex];
    }
}

//MARK:-定时器改变时改变当前currentIndex的UIScrollView的偏移量
//- (void)currentIndexChangeAnimation:(NSInteger)currentIndex {
//    CGFloat width = self.frame.size.width;
//    if (currentIndex == 0) {
//        return;
//    } else if (currentIndex == 1) {
//        [self.scrollView setContentOffset:CGPointMake(2 * width, 0) animated:true];
//    } else if (currentIndex == 2) {
//        self.scrollView.contentOffset = CGPointMake(2 * width, 0);
//    }
//}

//MARK:-UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self configTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat width = self.frame.size.width;
    if (offset.x == 2 * width) {
        self.currentIndex = Calculte_Index(self.currentIndex + 1,self.images.count);
    } else if (offset.x == 0) {
        self.currentIndex = Calculte_Index(self.currentIndex - 1,self.images.count);
    } else {
        return;
    }
    
    self.pageControl.currentPage = self.currentIndex;
    [self changeImageAndTitleViewWith:self.currentIndex];
    self.scrollView.contentOffset = CGPointMake(width, self.scrollView.frame.origin.y);
    
}

@end























































