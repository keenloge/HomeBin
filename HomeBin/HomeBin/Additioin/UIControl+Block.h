//
//  UIControl+Block.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ControlBlock)(id sender);

@interface UIControl (Block)

@property (nonatomic, copy) ControlBlock click;     // 点击
@property (nonatomic, copy) ControlBlock change;    // 值改变

@end
