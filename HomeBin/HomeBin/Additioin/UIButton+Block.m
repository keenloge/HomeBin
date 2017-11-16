//
//  UIButton+Block.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/8.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

static char overviewKey;

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block(self);
    }
}

- (void)handleClick:(ActionBlock)action {
    objc_setAssociatedObject(self, &overviewKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}

@end
