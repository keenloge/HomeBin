//
//  HomeData.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HomeData.h"

@interface HomeData ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) Class modClass;

@end

@implementation HomeData

+ (instancetype)homeDataTitle:(NSString *)title modClass:(Class)modClass {
    return [[HomeData alloc] initWithTitle:title modClass:modClass];
}

- (instancetype)initWithTitle:(NSString *)title
                     modClass:(Class)modClass {
    if (self = [super init]) {
        self.title = title;
        self.modClass = modClass;
    }
    return self;
}

- (NSString *)homeTitleString {
    return self.title;
}

- (Class)homeModClass {
    return self.modClass;
}

@end
