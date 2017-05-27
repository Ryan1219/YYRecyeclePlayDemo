//
//  YYRecycleView.h
//  YYRecycleSliderDemo
//
//  Created by Ryan on 2017/5/27.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,YYRecyclePageControlPosition){
    YYRecyclelPageControlPositionCenter = 0,//默认居中
    YYRecyclelPageControlPositionLeft,
    YYRecyclelPageControlPositionRight
};


@class YYRecycleView;

@protocol YYRecycleViewDelegate <NSObject>
- (void)clickPageAction:(NSInteger)index;

@end

@interface YYRecycleView : UIView

@property(nonatomic,weak) id<YYRecycleViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withRecyclePageControlPositon:(YYRecyclePageControlPosition)recyclePageControlPositon withImages:(NSArray *)images withTitles:(NSArray *)titles withPageChangeTime:(NSTimeInterval)pageChangeTime;

@end


































