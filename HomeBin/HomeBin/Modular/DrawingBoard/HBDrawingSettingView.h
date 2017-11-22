//
//  HBDrawingSettingView.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/20.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBDrawingSettingView : UIView

@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly) CGFloat width;

@property (nonatomic, copy) dispatch_block_t cancel;
@property (nonatomic, copy) dispatch_block_t undo;
@property (nonatomic, copy) dispatch_block_t redo;

- (void)showInView:(UIView *)view
             color:(UIColor *)color
             width:(CGFloat)width;

- (void)hide;

@end
