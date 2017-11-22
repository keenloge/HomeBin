//
//  HBDrawingBoard.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBDrawingControlDelegate

- (UIColor *)hbPaintColor;
- (void)updateHBPaintColor:(UIColor *)color;

- (CGFloat)hbPaintWidth;
- (void)updateHBPaintWidth:(CGFloat)width;

- (UIImage *)hbSnapImage;

- (BOOL)hbCanUndo;
- (BOOL)hbCanRedo;
- (void)hbUndo;
- (void)hbRedo;

@end

@interface HBDrawingBoard : UIView <HBDrawingControlDelegate>


@end
