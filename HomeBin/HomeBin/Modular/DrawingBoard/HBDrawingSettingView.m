//
//  HBDrawingSettingView.m
//  HomeBin
//
//  Created by HomeBin on 2017/11/20.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBDrawingSettingView.h"
#import "UIControl+Block.h"
#import "HBSlider.h"

@interface HBDrawingSettingView ()

@property (nonatomic, strong) UIControl *blankView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UIView *lineShow;
@property (nonatomic, strong) UIView *colorShow;

@property (nonatomic, strong) UIView *settingView;
@property (nonatomic, strong) HBSlider *redSlider;
@property (nonatomic, strong) HBSlider *greenSlider;
@property (nonatomic, strong) HBSlider *blueSlider;
@property (nonatomic, strong) HBSlider *alphaSlider;
@property (nonatomic, strong) HBSlider *widthSlider;

@property (nonatomic, strong) UIView *undoView;
@property (nonatomic, strong) UIButton *undoButton;
@property (nonatomic, strong) UIButton *redoButton;

@property (nonatomic, strong) UIColor *color;

@end

@implementation HBDrawingSettingView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.colorShow.layer.cornerRadius = CGRectGetMidY(self.colorShow.bounds);
}

- (void)showInView:(UIView *)view
             color:(UIColor *)color
             width:(CGFloat)width {
    
    self.blankView.opaque = NO;
    self.contentView.opaque = YES;
    self.undoView.opaque = YES;
    self.undoButton.opaque = YES;
    self.redoButton.opaque = YES;
    
    if (self.superview != view) {
        [view addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }

    self.hidden = NO;

    self.color = color;
    self.width = width;
}

- (void)hide {
    self.hidden = YES;
}

#pragma mark - 私有函数

- (NSString *)formatColorString:(CGFloat)value {
    return [NSString stringWithFormat:@"%.0f", value * 255];
}

- (UIColor *)currentColor {
    return [UIColor colorWithRed:self.redSlider.slider.value
                           green:self.greenSlider.slider.value
                            blue:self.blueSlider.slider.value
                           alpha:self.alphaSlider.slider.value];
}

- (CGFloat)currentWidth {
    return self.widthSlider.slider.value * 10 + 5;
}

#pragma mark - Setter

- (void)setColor:(UIColor *)color {
    _color = color;
    
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    if ([color getRed:&red green:&green blue:&blue alpha:&alpha]) {
        self.colorShow.backgroundColor = color;
        
        [self.redSlider.slider setValue:red];
        [self.greenSlider.slider setValue:green];
        [self.blueSlider.slider setValue:blue];
        [self.alphaSlider.slider setValue:alpha];
        
        self.redSlider.valueLabel.text = [self formatColorString:red];
        self.greenSlider.valueLabel.text = [self formatColorString:green];
        self.blueSlider.valueLabel.text = [self formatColorString:blue];
        self.alphaSlider.valueLabel.text = [NSString stringWithFormat:@"%.1f", alpha];
    }
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    
    [self.widthSlider.slider setValue:(width - 5) / 10];
    [self.lineShow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(width);
    }];
}

#pragma mark - Getter

- (UIControl *)blankView {
    if (!_blankView) {
        _blankView = [UIControl new];
        [self addSubview:_blankView];
        
        _blankView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.5);
        
        WeakObj(self);
        _blankView.click = ^(id sender) {
            [selfWeak hide];
            if (selfWeak.cancel) {
                selfWeak.cancel();
            }
        };
        
        [_blankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
        }];
    }
    return _blankView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        _contentView.backgroundColor = UIColorFromRGBA(255, 255, 255, 0.7);
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.equalTo(self.blankView.mas_bottom);
        }];
    }
    return _contentView;
}

- (UIView *)showView {
    if (!_showView) {
        _showView = [UIView new];
        [self.contentView addSubview:_showView];
        
        [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];
        
        self.lineShow.opaque = YES;
        self.colorShow.opaque = YES;
    }
    return _showView;
}

- (UIView *)colorShow {
    if (!_colorShow) {
        _colorShow = [UIView new];
        [self.showView addSubview:_colorShow];
        
        _colorShow.clipsToBounds = YES;
        _colorShow.backgroundColor = kColorRed;
        
        [_colorShow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.showView);
            make.top.mas_equalTo(8);
            make.width.equalTo(_colorShow.mas_height);
        }];
    }
    return _colorShow;
}

- (UIView *)lineShow {
    if (!_lineShow) {
        _lineShow = [UIView new];
        [self.showView addSubview:_lineShow];
        
        _lineShow.backgroundColor = kColorBlack;
        
        WeakObj(self);
        [_lineShow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.center.equalTo(selfWeak.showView);
            make.height.mas_equalTo(10);
        }];
    }
    return _lineShow;
}

- (UIView *)settingView {
    if (!_settingView) {
        _settingView = [UIView new];
        [self.contentView addSubview:_settingView];
        
        [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.showView.mas_bottom);
            make.left.right.equalTo(self.showView);
        }];
        
        [_settingView addSubview:self.redSlider];
        [_settingView addSubview:self.greenSlider];
        [_settingView addSubview:self.blueSlider];
        [_settingView addSubview:self.alphaSlider];
        [_settingView addSubview:self.widthSlider];
        
        [_settingView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        [_settingView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
    }
    return _settingView;
}

- (HBSlider *)redSlider {
    if (!_redSlider) {
        _redSlider = [HBSlider new];
        _redSlider.titleLabel.text = @"红";
        
        WeakObj(self);
        _redSlider.slider.change = ^(UISlider *sender) {
            selfWeak.color = [selfWeak currentColor];
        };
    }
    return _redSlider;
}

- (HBSlider *)greenSlider {
    if (!_greenSlider) {
        _greenSlider = [HBSlider new];
        _greenSlider.titleLabel.text = @"绿";
        
        WeakObj(self);
        _greenSlider.slider.change = ^(UISlider *sender) {
            selfWeak.color = [selfWeak currentColor];
        };
    }
    return _greenSlider;
}

- (HBSlider *)blueSlider {
    if (!_blueSlider) {
        _blueSlider = [HBSlider new];
        _blueSlider.titleLabel.text = @"蓝";
        
        WeakObj(self);
        _blueSlider.slider.change = ^(UISlider *sender) {
            selfWeak.color = [selfWeak currentColor];
        };
    }
    return _blueSlider;
}

- (HBSlider *)alphaSlider {
    if (!_alphaSlider) {
        _alphaSlider = [HBSlider new];
        _alphaSlider.titleLabel.text = @"透明";
        
        WeakObj(self);
        _alphaSlider.slider.change = ^(UISlider *sender) {
            selfWeak.color = [selfWeak currentColor];
        };
    }
    return _alphaSlider;
}

- (HBSlider *)widthSlider {
    if (!_widthSlider) {
        _widthSlider = [HBSlider new];
        _widthSlider.titleLabel.text = @"细";
        _widthSlider.valueLabel.text = @"粗";
        
        WeakObj(self);
        _widthSlider.slider.change = ^(UISlider *sender) {
            selfWeak.width = [selfWeak currentWidth];
        };
    }
    return _widthSlider;
}

- (UIView *)undoView {
    if (!_undoView) {
        _undoView = [UIView new];
        [self.contentView addSubview:_undoView];
        
        _undoView.backgroundColor = kColorGrayLight;
        
        [_undoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.settingView.mas_bottom);
        }];
    }
    return _undoView;
}


- (UIButton *)undoButton {
    if (!_undoButton) {
        _undoButton = [UIButton new];
        [self.undoView addSubview:_undoButton];
        
        [_undoButton setTitle:@"撤销" forState:UIControlStateNormal];
        
        WeakObj(self);
        _undoButton.click = ^(id sender) {
            if (selfWeak.undo) {
                selfWeak.undo();
            }
        };
        
        [_undoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.left.mas_equalTo(20);
        }];
    }
    return _undoButton;
}

- (UIButton *)redoButton {
    if (!_redoButton) {
        _redoButton = [UIButton new];
        [self.undoView addSubview:_redoButton];
        
        [_redoButton setTitle:@"恢复" forState:UIControlStateNormal];

        WeakObj(self);
        _redoButton.click = ^(id sender) {
            if (selfWeak.redo) {
                selfWeak.redo();
            }
        };
        
        [_redoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self.undoButton);
            make.left.equalTo(self.undoButton.mas_right).offset(8);
            make.right.mas_equalTo(-20);
        }];
    }
    return _redoButton;
}

@end
