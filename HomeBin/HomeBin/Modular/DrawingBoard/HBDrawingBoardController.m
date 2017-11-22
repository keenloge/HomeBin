//
//  HBDrawingBoardController.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBDrawingBoardController.h"
#import "HBDrawingBoard.h"
#import "HBDrawingSettingView.h"

@interface HBDrawingBoardController ()

@property (nonatomic, strong) HBDrawingBoard *boardView;
@property (nonatomic, strong) HBDrawingSettingView *settingView;

@end

@implementation HBDrawingBoardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"画板";

    [self commitSetting];
    self.boardView.opaque = YES;
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

- (void)showSetting {
    [self.settingView showInView:self.view color:self.boardView.hbPaintColor width:self.boardView.hbPaintWidth];
    
    WeakObj(self);
    [self addBarButtonItemRightTitle:@"完成" block:^(id sender) {
        [selfWeak commitSetting];
        [selfWeak.boardView updateHBPaintColor:selfWeak.settingView.color];
        [selfWeak.boardView updateHBPaintWidth:selfWeak.settingView.width];
        [selfWeak.settingView hide];
    }];
}

- (void)commitSetting {
    WeakObj(self);
    [self addBarButtonItemRightTitle:@"设置" block:^(id sender) {
        [selfWeak showSetting];
    }];
}

- (HBDrawingBoard *)boardView {
    if (!_boardView) {
        _boardView = [HBDrawingBoard new];
        [self.view addSubview:_boardView];
        
        [_boardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _boardView;
}

- (HBDrawingSettingView *)settingView {
    if (!_settingView) {
        _settingView = [[HBDrawingSettingView alloc] init];
        WeakObj(self);
        _settingView.cancel = ^{
            [selfWeak commitSetting];
        };
        _settingView.undo = ^{
            [selfWeak.boardView hbUndo];
        };
        _settingView.redo = ^{
            [selfWeak.boardView hbRedo];
        };
    }
    return _settingView;
}

@end
