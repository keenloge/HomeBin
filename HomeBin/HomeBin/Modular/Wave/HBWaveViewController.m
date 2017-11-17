//
//  HBWaveViewController.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBWaveViewController.h"
#import "HBScaleView.h"
#import "HBWaveView.h"
#import "UIControl+Block.h"

@interface HBWaveViewController ()

@property (nonatomic, strong) HBWaveView *waveView;
@property (nonatomic, strong) HBScaleView *scaleView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, assign) CGFloat present;

@end

@implementation HBWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"波浪";
    
    self.present = 0.3;
    self.slider.value = self.present;
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

#pragma mark - Setter

- (void)setPresent:(CGFloat)present {
    _present = present;
    self.scaleView.present = present;
}

#pragma mark - Getter

- (HBWaveView *)waveView {
    if (!_waveView) {
        _waveView = [[HBWaveView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
        [self.view addSubview:_waveView];
        
//        [_waveView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsZero);
//        }];
    }
    return _waveView;
}

- (HBScaleView *)scaleView {
    if (!_scaleView) {
        _scaleView = [HBScaleView new];
        [self.view addSubview:_scaleView];
        
        _scaleView.backgroundColor = [UIColor darkGrayColor];
        
        [_scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(20);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(_scaleView.mas_height);
        }];
    }
    return _scaleView;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [UISlider new];
        [self.view addSubview:_slider];
        
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 1.0;
        
        WeakObj(self);
        _slider.change = ^(id sender) {
            selfWeak.present = selfWeak.slider.value;
        };
        
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.centerX.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-30);
        }];
    }
    return _slider;
}

@end
