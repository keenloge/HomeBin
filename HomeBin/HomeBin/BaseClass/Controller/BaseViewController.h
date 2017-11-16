//
//  BaseViewController.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/7.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import "BasePopPushController.h"

@interface BaseViewController : BasePopPushController

/**
 初始化后调用函数
 */
- (void)baseInitBehind;

/**
 检查输入框是否不为空, 当为空时, 自动提示并获取焦点(弹出键盘)
 
 @param textField 输入框
 @return YES:非空 NO:空
 */
- (BOOL)baseCheckInputNotEmpty:(UITextField *)textField;

@end

@interface BaseViewController (HUD)

@property (nonatomic, assign) BOOL baseLoading;
@property (nonatomic, strong) NSString *baseLoadingContent;
@property (nonatomic, strong) NSString *baseMessageNotify;

@end
