//
//  NSTimer+Block.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/8.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)

+ (NSTimer *)hb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end

