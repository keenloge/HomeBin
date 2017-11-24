//
//  HBMenuIndexController.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBMenuIndexController.h"
#import "HBIndexView.h"

@interface HBMenuIndexController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HBIndexView *indexView;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray *menuArray;

@end

@implementation HBMenuIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"目录索引";
    self.listView.opaque = YES;
    self.indexView.opaque = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WeakObj(self);
    [self.indexView refreshIndexTitleArr:self.menuArray progress:^(NSInteger index) {
        [selfWeak.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } finish:^(NSInteger index) {
        [selfWeak.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menuArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.menuArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %zd Section: %zd", indexPath.row, indexPath.section];
    
    return cell;
}

//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.menuArray;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return index;
//}

#pragma mark - UITableViewDelegate

#pragma mark - Getter

- (HBIndexView *)indexView {
    if (!_indexView) {
        _indexView = [HBIndexView new];
        [self.view addSubview:_indexView];

        [_indexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(40);
        }];
    }
    return _indexView;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:_listView];
        
        _listView.rowHeight = 40;
        _listView.delegate = self;
        _listView.dataSource = self;
        
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _listView;
}

- (NSArray *)menuArray {
    if (!_menuArray) {
        _menuArray = @[
                       @"一鸣惊人",
                       @"两全其美",
                       @"三山五岳",
                       @"四海升平",
                       @"五花八门",
                       @"六神无主",
                       @"七情六欲",
                       @"八面玲珑",
                       @"九霄云外",
                       @"十面埋伏",
                       @"百发百中",
                       @"千秋万载",
                       @"万无一失"
                       ];
    }
    return _menuArray;
}

@end
