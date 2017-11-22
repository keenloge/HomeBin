//
//  HBDrawingBoard.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBDrawingBoard.h"

@interface HBPath : UIBezierPath

@property (nonatomic, strong) UIColor *color;

@end

@implementation HBPath

@end

@interface HBDrawingBoard ()

@property (nonatomic, strong) UIImage *snapImage;
@property (nonatomic, strong) HBPath *path;
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *undoArray;
@property (nonatomic, assign) BOOL undoMode;

@end

@implementation HBDrawingBoard

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.undoMode) {
        // 撤销 或 恢复 模式
        for (HBPath *path in self.pathArray) {
            [self drawPath:path];
        }
        self.undoMode = NO;
    } else {
        // 普通画图模式
        if (_snapImage) {
            [_snapImage drawAtPoint:CGPointZero];
        }
        [self drawPath:self.path];
    }
    [super drawRect:rect];
}

- (void)drawPath:(HBPath *)path {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat alpha = 0.0;
    [path.color getRed:nil green:nil blue:nil alpha:&alpha];
    if (alpha > 0.1) {
        [path.color setStroke];
        CGContextSetBlendMode(context, kCGBlendModeNormal);
    } else {
        [[UIColor clearColor] setStroke];
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }
    [path stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.undoArray removeAllObjects];
    CGPoint point = [self touchPoint:touches];
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addLineWithTouches:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addLineWithTouches:touches];
    self.snapImage = [self currentSnapShot];
    [self.pathArray addObject:self.path];
    self.path = nil;
}

- (void)addLineWithTouches:(NSSet<UITouch *> *)touches {
    CGPoint lastPoint = self.path.currentPoint;
    CGPoint currentPoint = [self touchPoint:touches];
    CGPoint prePoint = [self touchPrePoint:touches];
    CGPoint midPoint = [self midPoint1:currentPoint p2:prePoint];
    
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
    
    CGFloat space = self.path.lineWidth * 0.5 + 1;
    
    return CGRectMake(minX - space,
                      minY - space,
                      maxX - minX + self.path.lineWidth + 2,
                      maxY - minY + self.path.lineWidth + 2);
}

- (HBPath *)path {
    if (!_path) {
        _path = [HBPath new];
        [_path setLineCapStyle:kCGLineCapRound];
        [_path setLineJoinStyle:kCGLineJoinRound];
        [_path setFlatness:1.0];
        
        HBPath *path = [self.pathArray lastObject];
        if (path) {
            [_path setLineWidth:path.lineWidth];
            [_path setColor:path.color];
        } else {
            [_path setLineWidth:10];
            [_path setColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5]];
        }
    }
    return _path;
}

- (NSMutableArray *)pathArray {
    if (!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (NSMutableArray *)undoArray {
    if (!_undoArray) {
        _undoArray = [NSMutableArray array];
    }
    return _undoArray;
}

#pragma mark - HBDrawingControlDelegate

- (UIColor *)hbPaintColor {
    return self.path.color;
}

- (void)updateHBPaintColor:(UIColor *)color {
    self.path.color = color;
}

- (CGFloat)hbPaintWidth {
    return self.path.lineWidth;
}

- (void)updateHBPaintWidth:(CGFloat)width {
    self.path.lineWidth = width;
}

- (UIImage *)hbSnapImage {
    return self.snapImage;
}

- (BOOL)hbCanUndo {
    return self.pathArray.count > 0;
}

- (BOOL)hbCanRedo {
    return self.undoArray.count > 0;
}

- (void)hbUndo {
    if ([self hbCanUndo]) {
        HBPath *path = [self.pathArray lastObject];
        [self.undoArray addObject:path];
        [self.pathArray removeLastObject];
        self.undoMode = YES;
        [self setNeedsDisplay];
        self.snapImage = [self currentSnapShot];
    }
}

- (void)hbRedo {
    if ([self hbCanRedo]) {
        HBPath *path = [self.undoArray lastObject];
        [self.pathArray addObject:path];
        [self.undoArray removeLastObject];
        self.undoMode = YES;
        [self setNeedsDisplay];
        self.snapImage = [self currentSnapShot];
    }
}

@end
