//
//  HomeListView.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeListDataDelegate

- (NSString *)homeTitleString;
- (Class)homeModClass;

@end

typedef void(^HomeListClick)(Class modClass);

@interface HomeListView : UIView

@property (nonatomic, copy) HomeListClick click;

- (void)refreshDataList:(NSArray<id <HomeListDataDelegate>> *)dataList;

@end
