//
//  ColorHelper.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/8.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#ifndef ColorHelper_h
#define ColorHelper_h

#define UIColorFromRGB(r, g, b) [UIColor colorWithRed: (r)/255.0 green: (g)/255.0 blue: (b)/255.0 alpha : 1]

#define UIColorFromRGBA(r, g, b, a) [UIColor colorWithRed: (r)/255.0 green: (g)/255.0 blue: (b)/255.0 alpha: (a)]

#define UIColorFromHex(hex) [UIColor colorWithRed: ((float)((hex & 0xFF0000) >> 16))/255.0 green: ((float)((hex & 0xFF00) >> 8))/255.0 blue: ((float)(hex & 0xFF))/255.0 alpha: 1.0]

// 基础颜色定义
#define kColorBlue                  UIColorFromHex(0x1376c2)    // 蓝色,主色调
#define kColorClear                 [UIColor clearColor]
#define kColorWhite                 [UIColor whiteColor]
#define kColorBlack                 UIColorFromRGB(52, 52, 52)
#define kColorGray                  UIColorFromRGB(136, 136, 136)
#define kColorRed                   UIColorFromRGB(253, 127, 107)
#define kColorGreen                 UIColorFromRGB(116, 216, 107)
#define kColorYellow                UIColorFromRGB(212, 208, 55)

// 暗白,主要用作主界面背景
#define kColorWhiteDark             UIColorFromRGB(243, 243, 243)
// 浅灰,主要用作边框,分界线
#define kColorGrayLight             UIColorFromRGB(214, 214, 214)

#endif /* ColorHelper_h */
