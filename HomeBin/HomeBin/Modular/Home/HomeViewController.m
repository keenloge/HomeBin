//
//  HomeViewController.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeListView.h"
#import "HomeData.h"
#import "HBDrawingBoardController.h"
#import "HBMenuIndexController.h"
#import "HBWaveViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) HomeListView *listView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    
    [self.listView refreshDataList:self.dataList];
    
    WeakObj(self);
    self.listView.click = ^(Class modClass) {
        id con = [modClass new];
        [selfWeak pushViewController:con];
    };
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

- (HomeListView *)listView {
    if (!_listView) {
        _listView = [HomeListView new];
        [self.view addSubview:_listView];
        
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _listView;
}

- (NSArray *)dataList {
    if (!_dataList) {
        _dataList = @[
                      [HomeData homeDataTitle:@"目录索引" modClass:[HBMenuIndexController class]],
                      [HomeData homeDataTitle:@"画板" modClass:[HBDrawingBoardController class]],
                      [HomeData homeDataTitle:@"波浪" modClass:[HBWaveViewController class]],
                      ];
    }
    return _dataList;
}

@end
