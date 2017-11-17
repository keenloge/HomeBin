//
//  HBWaveView.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBWaveView.h"
#import "NSTimer+Block.h"

@interface HBWaveView ()

@property (nonatomic, strong) NSTimer *timer;       // 定时移动
@property (nonatomic, assign) CGFloat amplitude;    // 振幅
@property (nonatomic, assign) CGFloat cycle;        // 周期
@property (nonatomic, assign) CGFloat offset;       // 偏移

@end

@implementation HBWaveView

- (void)dealloc {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
}

- (void)drawRect:(CGRect)rect {
    // 由于屏幕坐标y自上而下, 因此要得到正弦波形需要取反
    CGFloat A = -self.amplitude;
    CGFloat a = 2 * M_PI / self.cycle;
    CGFloat b = self.offset;
    CGFloat c = CGRectGetHeight(self.bounds) * (1 - self.present);
    
    // 画第一条线
    UIColor *color1 = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.3];
    [self drawWaveRect:rect color:color1 A:A a:a b:b c:c];
    
    A *= 0.8;
    b += self.cycle / 1.3;
    a *= 0.6;
    // 画第二条线
    UIColor *color2 = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.5];
    [self drawWaveRect:rect color:color2 A:A a:a b:b c:c];
}

// y = A * sin(ax + b) + c
- (void)drawWaveRect:(CGRect)rect
               color:(UIColor *)color
                   A:(CGFloat)A
                   a:(CGFloat)a
                   b:(CGFloat)b
                   c:(CGFloat)c {
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置线宽与填充颜色
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, color.CGColor);

    // 新建一条路劲
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat x = 0;
    CGFloat y = A * sin(a * x + b) + c;
    CGPathMoveToPoint(path, nil, x, y);

    for (x++; x < rect.size.width; x++) {
        y = A * sin(a * x + b) + c;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    // 封口
    CGPathAddLineToPoint(path, nil, rect.size.width , rect.size.height );
    CGPathAddLineToPoint(path, nil, 0, rect.size.height );
    CGPathCloseSubpath(path);
    
    // 添加路劲
    CGContextAddPath(context, path);
    
    // 填充路劲
    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(path);
}

- (void)createTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    
    WeakObj(self);
    self.timer = [NSTimer hb_scheduledTimerWithTimeInterval:0.03 repeats:YES block:^(NSTimer *timer) {
        selfWeak.offset += 0.08;
        if (selfWeak.offset >= CGRectGetWidth(selfWeak.bounds) * 2) {
            selfWeak.offset = 0.0;
        }
        [selfWeak setNeedsDisplay];
    }];
    [self.timer fire];
}

- (void)setPresent:(CGFloat)present{
    if (present < 0.0) {
        present = 0.0;
    } else if (present > 1.0) {
        present = 1.0;
    }
    
    _present = present;
    
    //启动定时器
    [self createTimer];
}

// 振幅, 越靠近上下两边, 振幅越小
- (CGFloat)amplitude {
    CGFloat offsetPer = 0.0;
    if (self.present < 0.5) {
        offsetPer = self.present;
    } else {
        offsetPer = 1 - self.present;
    }
    _amplitude = CGRectGetHeight(self.frame) * offsetPer * 0.3;

    return _amplitude;
}

// 周期距离, 即一个周期的正弦波长度
- (CGFloat)cycle {
    return CGRectGetWidth(self.bounds) * 1.5;
}

@end
