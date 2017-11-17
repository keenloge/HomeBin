//
//  HBScaleView.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBScaleView : UIView

@property (nonatomic, assign) CGFloat present;      // 当前刻度高亮比例(0.0 到 1.0)

@property (nonatomic, assign) CGFloat scaleWidth;   // 刻度宽度, 默认2
@property (nonatomic, assign) CGFloat scaleLength;  // 刻度长度, 默认10
@property (nonatomic, assign) NSInteger scaleCount; // 刻度数(一圈), 默认100
@property (nonatomic, strong) UIColor *normalColor; // 普通颜色, 默认灰
@property (nonatomic, strong) UIColor *lightColor;  // 高亮颜色, 默认红
@property (nonatomic, assign) CGFloat scaleMargin;  // 刻度偏移, 相对self.bounds, 为正,向内偏移 反之,向外偏移, 默认为0

@property (nonatomic, assign) CGFloat cycleWidth;   // 内圈宽度, 默认1
@property (nonatomic, strong) UIColor *cycleColor;  // 内圈颜色, 默认绿
@property (nonatomic, assign) CGFloat cycleMargin;  // 内圈偏移, 相对刻度内测, 为正,向内偏移 反之,向外偏移, 默认为10

@end
