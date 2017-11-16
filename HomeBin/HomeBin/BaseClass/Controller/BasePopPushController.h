//
//  BasePopPushController.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/7.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonItemBlock)(id sender);

@interface BasePopPushController : UIViewController

- (void)pushViewController:(UIViewController *)con;
- (void)pushViewController:(UIViewController *)con skip:(NSInteger)count;
- (void)popViewController;
- (void)popViewControllerSkip:(NSInteger)count;

#pragma mark - 导航按钮
- (void)addBarButtonItemBack;
- (void)addBarButtonItemBackBlock:(ButtonItemBlock)aBlock;
- (void)addBarButtonItemRightImage:(NSString*)imageName block:(ButtonItemBlock)block;
- (void)addBarButtonItemLeftImage:(NSString*)imageName block:(ButtonItemBlock)block;
- (void)addBarButtonItemRightTitle:(NSString*)title block:(ButtonItemBlock)block;
- (void)addBarButtonItemLeftTitle:(NSString*)title block:(ButtonItemBlock)block;

@end
