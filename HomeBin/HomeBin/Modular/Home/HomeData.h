//
//  HomeData.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeListView.h"

@interface HomeData : NSObject <HomeListDataDelegate>

+ (instancetype)homeDataTitle:(NSString *)title modClass:(Class)modClass;

@end
