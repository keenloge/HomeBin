//
//  UIControl+Block.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "UIControl+Block.h"
#import <objc/runtime.h>

@implementation UIControl (Block)

#pragma mark - 点击

- (void)handleClickBlock:(id)sender {
    if (self.click) {
        self.click(self);
    }
}

- (void)setClick:(ControlBlock)click {
    objc_setAssociatedObject(self, @selector(handleClickBlock:), click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(handleClickBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (ControlBlock)click {
    return (ControlBlock)objc_getAssociatedObject(self, @selector(handleClickBlock:));
}

#pragma mark - 值改变

- (void)handleChangeBlock:(id)sender {
    if (self.change) {
        self.change(sender);
    }
}

- (void)setChange:(ControlBlock)change {
    objc_setAssociatedObject(self, @selector(handleChangeBlock:), change, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(handleChangeBlock:) forControlEvents:UIControlEventValueChanged];
}

- (ControlBlock)change {
    return (ControlBlock)objc_getAssociatedObject(self, @selector(handleChangeBlock:));
}

@end
