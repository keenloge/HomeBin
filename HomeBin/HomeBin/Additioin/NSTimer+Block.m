//
//  NSTimer+Block.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/8.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)

+ (NSTimer *)hb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(hb_blcokInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)hb_blcokInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end

