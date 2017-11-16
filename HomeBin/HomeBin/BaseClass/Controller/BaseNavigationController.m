//
//  BaseNavigationController.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/7.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self _init];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        [self _init];
    }
    return self;
}

- (void)_init {
    self.navigationBar.barTintColor = kColorBlue;
    //    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)]) {
    //        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bkg_ios7"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    //    } else if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
    //        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bkg"] forBarMetrics:UIBarMetricsDefault];
    //    }
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                 }];
}

@end
