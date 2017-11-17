//
//  HBScaleView.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBScaleView.h"
#import "HBWaveView.h"

@interface HBScaleView ()

@property (nonatomic, assign) CGRect scaleRect;
@property (nonatomic, strong) HBWaveView *waveView;

@end

@implementation HBScaleView

- (instancetype)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.backgroundColor = [UIColor whiteColor];
    
    self.scaleCount = 100;
    self.scaleWidth = 2.0;
    self.scaleLength = 10.0;
    self.scaleMargin = 0.0;
    self.normalColor = [UIColor grayColor];
    self.lightColor = [UIColor redColor];
    
    self.cycleWidth = 1.0;
    self.cycleColor = [UIColor greenColor];
    self.cycleMargin = 10.0;
    
    self.waveMargin = 10.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.waveView.layer.cornerRadius = CGRectGetMidX(self.waveView.bounds);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画底部参考刻度
    [self drawScale:context];
    
    // 画当前高亮刻度
    [self drawProcessScale:context];
    
    [super drawRect:rect];
}

- (void)drawScale:(CGContextRef)context {
    // 顺时针画默认的刻度
    [self drawScale:context count:self.scaleCount color:self.normalColor clockwise:YES];
    
    // 移动画布参考点到中心位置, 后续坐标将以中心点为(0,0)计算
    CGContextTranslateCTM(context, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 设置内圈 宽度与颜色
    CGContextSetLineWidth(context, self.cycleWidth);
    CGContextSetStrokeColorWithColor(context, self.cycleColor.CGColor);
    
    // 以(0,0)为中心, 半径为radius, 顺时针添加圆弧(弧度0到2PI)
    CGFloat radius = self.scaleRect.size.width / 2 - self.scaleLength - self.cycleMargin;
    CGContextAddArc(context, 0, 0, radius, 0, M_PI * 2, 0);
    
    // 画线
    CGContextStrokePath(context);
    
    // 复原参考点到左上角
    CGContextTranslateCTM(context, -CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds));
}

- (void)drawProcessScale:(CGContextRef)context {
    int count = (self.scaleCount / 2 + 1) * self.present + 1;
    // 顺时针画左侧高亮刻度
    [self drawScale:context count:count color:self.lightColor clockwise:YES];
    // 逆时针画右侧高亮刻度
    [self drawScale:context count:count color:self.lightColor clockwise:NO];
}

- (void)drawScale:(CGContextRef)context
            count:(NSInteger)count
            color:(UIColor *)color
        clockwise:(BOOL)clockwise {
    // 移动画布参考点到中心位置, 后续坐标将以中心点为(0,0)计算
    CGContextTranslateCTM(context, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 设置线条 宽度与颜色
    CGContextSetLineWidth(context, self.scaleWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    int clockwiseInt = clockwise ? 1 : -1;
    CGFloat scaleAngle = 2 * M_PI / self.scaleCount;
    
    for (int i = 0; i < count; i++) {
        // 将画笔移动到最下方
        CGContextMoveToPoint(context, 0, self.scaleRect.size.width / 2.0);
        // 向上添加一条短直线
        CGContextAddLineToPoint(context, 0, self.scaleRect.size.width / 2.0 - self.scaleLength);
        // 旋转, 后续坐标也将以旋转后的参考系计算
        CGContextRotateCTM(context, 2 * M_PI / self.scaleCount * clockwiseInt);
    }
    // 画线
    CGContextStrokePath(context);
    // 恢复旋转之前的状态
    CGContextRotateCTM(context, count * scaleAngle * (-clockwiseInt));
    
    // 复原参考点到左上角
    CGContextTranslateCTM(context, -CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds));
}

- (void)setPresent:(CGFloat)present{
    _present = present;
    [self setNeedsDisplay];
    self.waveView.present = present;
}

- (CGRect)scaleRect {
    if (CGRectIsEmpty(_scaleRect)) {
        CGFloat side = MIN(self.bounds.size.width, self.bounds.size.height);
        side -= self.scaleMargin;
        side = floor(side);
        CGFloat pointX = (self.bounds.size.width - side) / 2.0;
        CGFloat pointY = (self.bounds.size.height - side) / 2.0;
        _scaleRect = CGRectMake(pointX, pointY, side, side);
    }
    return _scaleRect;
}

- (HBWaveView *)waveView {
    if (!_waveView) {
        _waveView = [HBWaveView new];
        [self addSubview:_waveView];
        
        _waveView.clipsToBounds = YES;
        
        [_waveView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat offset = self.scaleLength + self.cycleMargin + self.cycleWidth + self.waveMargin;
            make.edges.mas_equalTo(UIEdgeInsetsMake(offset, offset, offset, offset));
        }];
    }
    return _waveView;
}

@end
