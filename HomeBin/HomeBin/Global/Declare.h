//
//  Declare.h
//  HomeBin
//
//  Created by HomeBin on 2017/11/8.
//  Copyright © 2017年 HomeBin. All rights reserved.
//

#ifndef Declare_h
#define Declare_h

#ifdef DEBUG
//#define DDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DDLog(fmt, ...) NSLog(fmt, ## __VA_ARGS__);
#else
#define DDLog(...)
#endif

// Weak / Strong
#define WeakObj(o) @autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) @autoreleasepool{} __strong typeof(o) o = o##Weak;

#endif /* Declare_h */
