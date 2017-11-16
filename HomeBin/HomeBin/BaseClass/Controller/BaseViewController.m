//
//  BaseViewController.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/7.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import "BaseViewController.h"
#import <MBProgressHUD.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init {
    if (self = [super init]) {
        [self baseInitBehind];
    }
    return self;
}

- (void)baseInitBehind {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = UIColorFromHex(0xeeeeee);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLog(@"dealloc : %@", self.class);
}

- (BOOL)baseCheckInputNotEmpty:(UITextField *)textField {
    if ([textField isKindOfClass:[UITextField class]] ||
        [textField isKindOfClass:[UITextView class]]) {
        if (textField.text.length > 0) {
            return YES;
        } else {
            self.baseMessageNotify = textField.placeholder;
            [textField becomeFirstResponder];
        }
    }
    return NO;
}

#pragma mark - Keyboard

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end

#pragma mark - HUD

@implementation BaseViewController (HUD)

- (BOOL)baseLoading {
    return NO;
}

- (NSString *)baseLoadingContent {
    return nil;
}

- (NSString *)baseMessageNotify {
    return nil;
}

- (void)setBaseLoading:(BOOL)baseLoading {
    if (baseLoading) {
        self.baseLoadingContent = @"请稍候...";
    } else {
        // 隐藏
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)setBaseLoadingContent:(NSString *)baseLoadingContent {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = baseLoadingContent;
}

- (void)setBaseMessageNotify:(NSString *)baseMessageNotify {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.backgroundColor = kColorRed;
    hud.label.text = baseMessageNotify;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.0];
}

@end
