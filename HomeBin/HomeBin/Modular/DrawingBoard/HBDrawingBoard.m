//
//  HBDrawingBoard.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBDrawingBoard.h"

@interface HBDrawingBoard ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIImage *snapImage;

@end

@implementation HBDrawingBoard

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_snapImage) {
        [_snapImage drawAtPoint:CGPointZero];
    }
    
    [self.paintColor setStroke];
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    [self.path stroke];
    
    [super drawRect:rect];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self touchPoint:touches];
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addLineWithTouches:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addLineWithTouches:touches];
    self.snapImage = [self currentSnapShot];
    self.path = nil;
}

- (void)addLineWithTouches:(NSSet<UITouch *> *)touches {
    CGPoint lastPoint = self.path.currentPoint;
    CGPoint currentPoint = [self touchPoint:touches];
    CGPoint prePoint = [self touchPrePoint:touches];
    CGPoint midPoint = [self midPoint1:currentPoint p2:prePoint];
    
//    NSLog(@"**********************");
//    NSLog(@"lastPoint : %@", NSStringFromCGPoint(lastPoint));
//    NSLog(@"currentPoint : %@", NSStringFromCGPoint(currentPoint));
//    NSLog(@"prePoint : %@", NSStringFromCGPoint(prePoint));
//    NSLog(@"midPoint : %@", NSStringFromCGPoint(midPoint));
    
    [self.path addQuadCurveToPoint:midPoint controlPoint:prePoint];
    
    CGRect rect = [self drawRectWithPoint1:lastPoint p2:currentPoint p3:prePoint];
    [self setNeedsDisplayInRect:rect];
}

- (CGPoint)touchPoint:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

- (CGPoint)touchPrePoint:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    return [touch previousLocationInView:self];
}

- (UIImage *)snapImage {
    return [self currentSnapShot];
}

- (UIImage *)currentSnapShot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapShot;
}

- (CGPoint)midPoint1:(CGPoint)p1 p2:(CGPoint)p2 {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (CGRect)drawRectWithPoint1:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3 {
    CGFloat minX = MIN(MIN(p1.x, p2.x), p3.x);
    CGFloat minY = MIN(MIN(p1.y, p2.y), p3.y);
    CGFloat maxX = MAX(MAX(p1.x, p2.x), p3.x);
    CGFloat maxY = MAX(MAX(p1.y, p2.y), p3.y);
    
    CGFloat space = self.paintWidth * 0.5 + 1;
    
    return CGRectMake(minX - space,
                      minY - space,
                      maxX - minX + self.paintWidth + 2,
                      maxY - minY + self.paintWidth + 2);
}

- (UIColor *)paintColor {
    if (!_paintColor) {
        _paintColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5];
    }
    return _paintColor;
}

- (CGFloat)paintWidth {
    if (_paintWidth < 0.01) {
        _paintWidth = 10.0;
    }
    return _paintWidth;
}

- (UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
        [_path setLineCapStyle:kCGLineCapRound];
        [_path setLineJoinStyle:kCGLineJoinRound];
        [_path setLineWidth:self.paintWidth];
        [_path setFlatness:1.0];
    }
    return _path;
}

@end
