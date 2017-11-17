//
//  HBDrawingBoardController.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBDrawingBoardController.h"
#import "HBDrawingBoard.h"

@interface HBDrawingBoardController ()

@property (nonatomic, strong) HBDrawingBoard *boardView;

@end

@implementation HBDrawingBoardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"画板";
    
    self.boardView.backgroundColor = [UIColor whiteColor];
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

@end
