//
//  UIButton+Block.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/8.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(UIButton *sender);

@interface UIButton (Block)

- (void)handleClick:(ActionBlock)action;

@end
