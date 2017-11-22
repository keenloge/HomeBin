//
//  UIColor+Additions.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/21.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

- (CGFloat)red {
    CGFloat value = 0;
    [self getRed:&value green:nil blue:nil alpha:nil];
    return value;
}

- (CGFloat)green {
    CGFloat value = 0;
    [self getRed:nil green:&value blue:nil alpha:nil];
    return value;
}

- (CGFloat)blue {
    CGFloat value = 0;
    [self getRed:nil green:nil blue:&value alpha:nil];
    return value;
}

- (CGFloat)alpha {
    CGFloat value = 0;
    [self getRed:nil green:nil blue:nil alpha:&value];
    return value;
}

@end
