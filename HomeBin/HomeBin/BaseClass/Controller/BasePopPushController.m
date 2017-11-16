//
//  BasePopPushController.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/7.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import "BasePopPushController.h"
#import "BaseButton.h"

/**
 导航栏按钮位置
 
 - NavigationBarPositionLeft: 左
 - NavigationBarPositionRight: 右
 */
typedef NS_ENUM(NSInteger, NavigationBarPosition) {
    NavigationBarPositionLeft = 0,
    NavigationBarPositionRight = 1,
};

@interface BasePopPushController ()

@property (nonatomic, assign) BOOL baseIsDidAppear;
@property (nonatomic, assign) BOOL baseHasPushView;

@end

@implementation BasePopPushController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 自动添加返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        [self addBarButtonItemBack];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.baseIsDidAppear = YES;
    self.baseHasPushView = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.baseIsDidAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - PUSH

- (void)pushViewController:(UIViewController *)con {
    [self pushViewController:con skip:0];
}

- (void)pushViewController:(UIViewController *)con skip:(NSInteger)count {
    if (self.baseIsDidAppear) {
        [self doPushViewController:con skip:count];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self doPushViewController:con skip:count];
        });
    }
}

- (void)doPushViewController:(UIViewController *)con skip:(NSInteger)count {
    if (!con) {
        return;
    }
    
    if (self.baseHasPushView) {
        return;
    }
    
    self.baseHasPushView = YES;
    con.hidesBottomBarWhenPushed = YES;
    if (count <= 0) {
        [self.navigationController pushViewController:con animated:YES];
    } else {
        NSInteger navCount = self.navigationController.viewControllers.count;
        if (count >= navCount) {
            // 跳过全部
            [self.navigationController setViewControllers:@[con] animated:YES];
        } else {
            NSRange subRange = NSMakeRange(0, (navCount - count));
            NSArray *conArray = [self.navigationController.viewControllers subarrayWithRange:subRange];
            conArray = [conArray arrayByAddingObject:con];
            [self.navigationController setViewControllers:conArray animated:YES];
        }
    }
}

#pragma mark - POP

- (void)popViewController {
    [self popViewControllerSkip:0];
}

- (void)popViewControllerSkip:(NSInteger)count {
    if (self.baseIsDidAppear) {
        [self doPopViewControllerSkip:count];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self doPopViewControllerSkip:count];
        });
    }
}

- (void)doPopViewControllerSkip:(NSInteger)count {
    if (self.baseHasPushView) {
        return;
    }
    
    if (count <= 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // count > 0
        NSInteger navCount = self.navigationController.viewControllers.count;
        if (count >= (navCount - 1)) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSRange subRange = NSMakeRange(0, (navCount - count - 1));
            NSArray *conArr = [self.navigationController.viewControllers subarrayWithRange:subRange];
            [self.navigationController setViewControllers:conArr animated:YES];
        }
    }
}

#pragma mark - 导航按钮

- (void)addBarButtonItemBack {
    WeakObj(self);
    [self addBarButtonItemBackBlock:^(id sender) {
        [selfWeak popViewController];
    }];
}

- (void)addBarButtonItemBackBlock:(ButtonItemBlock)aBlock {
    [self addBarButtonItemLeftTitle:@"<<" block:aBlock];
}

- (void)addBarButtonItemRightImage:(NSString*)imageName block:(ButtonItemBlock)block {
    BaseButton *btn = [self baseButtonImage:imageName block:block];
    [self addBarButtonItemCustomView:btn position:NavigationBarPositionRight];
}

- (void)addBarButtonItemLeftImage:(NSString*)imageName block:(ButtonItemBlock)block {
    BaseButton *btn = [self baseButtonImage:imageName block:block];
    [self addBarButtonItemCustomView:btn position:NavigationBarPositionLeft];
}

- (void)addBarButtonItemRightTitle:(NSString*)title block:(ButtonItemBlock)block {
    BaseButton *btn = [self baseButtonTitle:title block:block];
    [self addBarButtonItemCustomView:btn position:NavigationBarPositionRight];
}

- (void)addBarButtonItemLeftTitle:(NSString*)title block:(ButtonItemBlock)block {
    BaseButton *btn = [self baseButtonTitle:title block:block];
    [self addBarButtonItemCustomView:btn position:NavigationBarPositionLeft];
}

- (void)addBarButtonItemCustomView:(UIView *)customView position:(NavigationBarPosition)position {
    UIBarButtonItem * bbItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    if (position == NavigationBarPositionLeft) {
        self.navigationItem.leftBarButtonItem = bbItem;
    } else {
        self.navigationItem.rightBarButtonItem = bbItem;
    }
}

#pragma mark - Creater

- (BaseButton *)baseButtonImage:(NSString *)imageName block:(ButtonItemBlock)block {
    BaseButton *btn = [self baseButtonBlock:block];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

- (BaseButton *)baseButtonTitle:(NSString *)title block:(ButtonItemBlock)block {
    BaseButton *btn = [self baseButtonBlock:block];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

- (BaseButton *)baseButtonBlock:(ButtonItemBlock)block {
    BaseButton *btn = [BaseButton new];
    [btn handleClick:^(UIButton *sender) {
        if (block) {
            block(sender);
        }
    }];
    return btn;
}

@end
