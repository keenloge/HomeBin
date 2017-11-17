//
//  HomeListView.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HomeListView.h"

@interface HomeListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray<id <HomeListDataDelegate>> *dataList;

@end

@implementation HomeListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)refreshDataList:(NSArray *)dataList {
    self.dataList = [dataList copy];
    [self.listView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identiferCell = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identiferCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiferCell];
    }
    
    id <HomeListDataDelegate> item = [self.dataList objectAtIndex:indexPath.row];
    cell.textLabel.text = [item homeTitleString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id <HomeListDataDelegate> item = [self.dataList objectAtIndex:indexPath.row];
    if (self.click) {
        self.click(item.homeModClass);
    }
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        [self addSubview:_listView];
        
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.estimatedRowHeight = 50.0;
        _listView.rowHeight = 50.0;
        _listView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"FooterNull"];
        
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _listView;
}

@end
