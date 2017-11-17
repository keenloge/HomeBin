//
//  HBDrawingBoard.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/16.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBDrawingBoard : UIView

@property (nonatomic, readonly) UIImage *snapImage;
@property (nonatomic, strong) UIColor *paintColor;
@property (nonatomic, assign) CGFloat paintWidth;

@end
