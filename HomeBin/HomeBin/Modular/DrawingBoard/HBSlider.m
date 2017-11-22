//
//  HBSlider.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/21.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBSlider.h"

@interface HBSlider ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;


@end

@implementation HBSlider

- (instancetype)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init {

}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(50);
        }];
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
        [self addSubview:_valueLabel];
        
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(50);
        }];
    }
    return _valueLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [UISlider new];
        [self addSubview:_slider];
        
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
            make.right.equalTo(self.valueLabel.mas_left).offset(-8);
        }];
    }
    return _slider;
}

@end
