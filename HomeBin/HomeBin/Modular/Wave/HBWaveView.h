//
//  HBWaveView.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBWaveView : UIView

@property (nonatomic, assign) CGFloat present;      // 当前比例(0.0 到 1.0)
@property (nonatomic, strong) UIColor *frontColor;  // 前波浪颜色
@property (nonatomic, strong) UIColor *behindColor; // 后波浪颜色

@end
