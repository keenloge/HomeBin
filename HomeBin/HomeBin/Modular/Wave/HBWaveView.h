//
//  HBWaveView.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBWaveView : UIView

@property (nonatomic,assign)CGFloat present;
@property (nonatomic,strong)UILabel * presentlabel;
- (instancetype)initWithFrame:(CGRect)frame;

@end
