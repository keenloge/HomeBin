//
//  HBIndexView.h
//  HBIndexMenu
//
//  Created by Keen on 2017/4/24.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 滑动过程中选中Block */
typedef void(^HBIndexProgressBlock)(NSInteger index);

/** 结束选中Block */
typedef void(^HBIndexFinishBlock)(NSInteger index);



@interface HBIndexView : UIView

/**
 更新索引目录

 @param aTitleArr 目录列表
 @param aProgressBlock 过程Block
 @param aFinishBlock 结束Block
 */
- (void)refreshIndexTitleArr:(NSArray<NSString *> *)aTitleArr
                    progress:(HBIndexProgressBlock)aProgressBlock
                      finish:(HBIndexFinishBlock)aFinishBlock;

@end
