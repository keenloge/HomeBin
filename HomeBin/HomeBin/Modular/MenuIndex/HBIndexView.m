//
//  HBIndexView.m
//  HBIndexMenu
//
//  Created by Keen on 2017/4/24.
//  Copyright © 2017年 Keen. All rights reserved.
//

#import "HBIndexView.h"

#define HBNormalColor  [UIColor blueColor]
#define HBSelectColor  [UIColor blackColor]

/** 无效的Index */
static NSInteger    const HBInvalidIndex    = -999999;

/** 预选标题个数，前后各自计算，即前面有 HBPrepCount 个或后面有 HBPrepCount 个 */
static CGFloat      const HBPrepCount       = 5.0;

/** 缩放比例 */
static CGFloat      const HBZoomScale       = 2.0;

/** 默认字体大小 */
static CGFloat      const HBDefaultFontSize = 14.0;

/** 默认间隙 */
static CGFloat      const HBDefaultOffset   = 8.0;

/** 最大X偏移量 */
static CGFloat      const HBMaxOffsetX      = 120.0;

/** 边界值，由 HBPrepCount 决定 */
static CGFloat      const HBBoundary        = 1.0 - (1.0 / (HBPrepCount * 2.0));



@interface HBIndexLabel : UILabel

/** 选中程度 */
@property (nonatomic, assign) CGFloat   degree;

/** 初始Frame */
@property (nonatomic, assign) CGRect    originFrame;

/** 最大X偏移量，单个标题具体最大偏移量在 HBMaxOffsetX 基础上有修正，请注意区别与联系 */
@property (nonatomic, assign) CGFloat   maxOffsetX;

/** 最大Y偏移量 */
@property (nonatomic, assign) CGFloat   maxOffsetY;

/** 最大宽度差值 */
@property (nonatomic, assign) CGFloat   maxOffsetWidth;

/** 最大高度差值 */
@property (nonatomic, assign) CGFloat   maxOffsetHeight;

@end

@implementation HBIndexLabel


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.originFrame = frame;
        self.font = [UIFont systemFontOfSize:HBDefaultFontSize * HBZoomScale];
        self.lineBreakMode = NSLineBreakByClipping;
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumScaleFactor = 1.0 / HBZoomScale;
        self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.textAlignment = NSTextAlignmentCenter;
        self.clipsToBounds = NO;
        self.degree = 0.0;
    }
    return self;
}

- (void)setText:(NSString *)value {
    [super setText:value];
    
    // 遇着空标题就默认为空格，方便计算大小
    if (value.length == 0) {
        value = @" ";
    }

    // 最小字体
    UIFont *minFont = [UIFont systemFontOfSize:HBDefaultFontSize];
    // 最小 Size，由标题首个字符决定
    CGSize minSize = [[value substringToIndex:1] sizeWithAttributes:@{NSFontAttributeName : minFont}];
    
    // 最大字体
    UIFont *maxFont = [UIFont boldSystemFontOfSize:HBDefaultFontSize * HBZoomScale];
    // 最大 Size
    CGSize maxSize = [value sizeWithAttributes:@{NSFontAttributeName : maxFont}];
    
    CGFloat offsetX = (CGRectGetWidth(self.originFrame) - minSize.width) / 2.0;
    CGFloat offsetY = (CGRectGetHeight(self.originFrame) - minSize.height) / 2.0;
    
    // 将标题的大小设置为 minSize，为后续渐变缩放做准备
    self.originFrame = CGRectInset(self.originFrame, offsetX, offsetY);
    self.frame = self.originFrame;

    // HBMaxOffsetX 仅仅是针对索引栏的偏移，所以 X 最大偏移还应加上 offsetX
    self.maxOffsetX = HBMaxOffsetX + offsetX;
    
    // Y，Width, Height 的最大偏移量，始终只与 maxSize 和 minSize 有关
    self.maxOffsetY = (maxSize.height - minSize.height) / 2.0;
    self.maxOffsetWidth = maxSize.width - minSize.width;
    self.maxOffsetHeight = maxSize.height - minSize.height;
}

- (void)setDegree:(CGFloat)value {
    // value 有正负之分，以示区分上下，上方为正，下方为负
    // degree 无正负，取值 0.0 ~ 1.0 之间
    _degree = fabs(value);
    
    self.font = [UIFont systemFontOfSize:HBDefaultFontSize * HBZoomScale];
    if (_degree > 0.0) {
        // 预备选择
        self.textColor = HBNormalColor;
        if (_degree >= HBBoundary) {
            // 预备选中
            if (_degree > HBBoundary) {
                // 确定选中
                self.alpha = 1.0;
                self.textColor = HBSelectColor;
                self.font = [UIFont boldSystemFontOfSize:HBDefaultFontSize * HBZoomScale];
            } else {
                // 这是一个非常特殊的情况，刚好点击在两个标题标准的中间，两个标题的degree相同，按照算法，应该选定下方的标题
                if (value < 0.0) {
                    self.alpha = 1.0;
                    self.textColor = HBSelectColor;
                    self.font = [UIFont boldSystemFontOfSize:HBDefaultFontSize * HBZoomScale];
                } else {
                    self.alpha = 1.0 - _degree;
                }
            }
        } else {
            // 预选标题，渐变透明
            self.alpha = 1.0 - _degree;
        }
    } else {
        // 缩小到索引栏的标题
        self.textColor = HBNormalColor;
        self.alpha = 1.0;
    }

    self.frame = CGRectMake(CGRectGetMinX(_originFrame)     - (_maxOffsetX       * _degree),
                            CGRectGetMinY(_originFrame)     - (_maxOffsetY       * _degree),
                            CGRectGetWidth(_originFrame)    + (_maxOffsetWidth   * _degree),
                            CGRectGetHeight(_originFrame)   + (_maxOffsetHeight  * _degree));
}

@end


@interface HBIndexView () {
    NSMutableArray<HBIndexLabel *>* labIndexArr;
    NSArray<NSString *>* titleArr;
    HBIndexProgressBlock progressBlock;
    HBIndexFinishBlock finishBlock;
    
    CGFloat itemHeight;         // 单个标题的高度，最小等于 self.font.lineHeight
    CGFloat offsetPointY;       // 相邻两个标题的 Y 值偏移量，非重叠布局时等于 itemHeight
    CGFloat originPointY;       // 布局索引标题时，首个标题的 Y 值
    CGFloat calculatePointY;    // 计算 Index 时的 Y 偏移量，非重叠排列时等于 originPointY
}

/** 选中标题的 Index，定义为 CGFloat 是为方便计算预选标题选中程度 */
@property (nonatomic, assign) CGFloat highlightedIndex;

@end

@implementation HBIndexView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setHighlightedIndex:(CGFloat)value {
    _highlightedIndex = value;
    
    HBIndexLabel *labTitle = nil;
    CGFloat offsetIndex = 0.0;
    CGFloat preDegree = 0.0;
    
    for (NSInteger i = 0; i < labIndexArr.count; i++) {
        // 遍历每一个标题
        labTitle = [labIndexArr objectAtIndex:i];
        // 以标题的中心点作为参考点，0.5的偏移就是为了取中心
        offsetIndex = fabs(i + 0.5 - _highlightedIndex);
        if (offsetIndex < HBPrepCount) {
            preDegree = 1.0 - (offsetIndex / HBPrepCount);
            // 这里用正负区分处于中间状态的标题
            labTitle.degree = preDegree * (_highlightedIndex > i ? 1 : -1);
        } else {
            labTitle.degree = 0.0;
        }
    }
}

- (void)refreshIndexTitleArr:(NSArray<NSString *> *)aTitleArr progress:(HBIndexProgressBlock)aProgressBlock finish:(HBIndexFinishBlock)aFinishBlock {
    // 准备与清理
    self.clipsToBounds = NO;
    if (!labIndexArr) {
        labIndexArr = [[NSMutableArray alloc] init];
    }
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [labIndexArr removeAllObjects];
    
    // 缓存数据
    titleArr = [aTitleArr copy];
    progressBlock = [aProgressBlock copy];
    finishBlock = [aFinishBlock copy];

    // 为了索引标题排列尽量美观，做如下考虑
    // 若空间足够，则居中，但不紧贴
    // 若空间不足，则重叠排列，最小行高由字体决定，且首尾不超出边界
    
    // 当默认间隙，最小行高，以及标题个数确定后，排列会遇到以下三种情况
    // 情况1，即便带上默认间隙，高度也足够
    // 情况2，情况1的间隙设置过大，减小间隙，高度才足够
    // 情况3，高度根本就不够，须重叠排列
    
    originPointY = 0.0;
    offsetPointY = 0.0;
    calculatePointY = 0.0;
    CGFloat totalHeight = 0.0;
    
    UIFont *font = [UIFont systemFontOfSize:HBDefaultFontSize];
    
    // 预设单个标题高度 = 最小行高 + 默认间隙
    itemHeight = font.lineHeight + HBDefaultOffset;
    totalHeight = itemHeight * titleArr.count;
    if (totalHeight < CGRectGetHeight(self.frame)) {
        // 情况 1，高度富裕，将多余的空间均分到上下两端，完成居中排列
        // 首个标题的起始Y坐标 = 剩余空间的一半
        originPointY = (CGRectGetHeight(self.frame) - totalHeight) / 2.0;
        // 相邻两个标题的坐标Y值偏差刚好等于单个标题高度
        offsetPointY = itemHeight;
        // 计算Index的Y值偏差 = originPointY
        calculatePointY = originPointY;
    } else {
        // 预设单个标题高度 = 最小行高
        itemHeight = font.lineHeight;
        totalHeight = itemHeight * titleArr.count;
        if (totalHeight < CGRectGetHeight(self.frame)) {
            // 情况 2，间隙过大，不过高度还算足够，直接将高度均摊，就不必关心当前间隙具体为多少了
            itemHeight = CGRectGetHeight(self.frame) / titleArr.count;
            // 相邻两个标题的坐标Y值偏差刚好等于单个标题高度
            offsetPointY = itemHeight;
            // 计算Index的Y值偏差 = originPointY
            calculatePointY = originPointY;
        } else {
            // 情况 3
            // itemHeight，保持最小行高
            // 将不足的空间均摊到（N-1）个标题上，N等于标题总数，完成重叠排列，且首尾标题不超出边界，
            offsetPointY = itemHeight - (totalHeight - CGRectGetHeight(self.frame)) / (titleArr.count - 1);
            /* 
             请注意，中间标题上下两端均有一部分与相邻标题重叠，而首尾标题则只有一方有重叠,
             故首尾标题独占面积比中间的标题略大，而相邻两个标题的分割线应与两标题的中心点距离相等。
             因此，此处计算Index的Y值偏差将不再等于 originPointY。
             itemHeight - offsetPointY = 相邻两个标题重叠部分的高度
             为公平起见，首标题的起始有效计算坐标应减去重叠高度的一半。
             */
            calculatePointY = (itemHeight - offsetPointY) / 2.0;
        }
    }
    
    CGFloat pointY = originPointY;
    for (NSString *strTitle in titleArr) {
        // 循环生成标题
        HBIndexLabel *labTitle = [[HBIndexLabel alloc] initWithFrame:CGRectMake(0, pointY, CGRectGetWidth(self.frame), itemHeight)];
        labTitle.text = strTitle;
        [labIndexArr addObject:labTitle];
        [self addSubview:labTitle];
        // 下一个标题 Y 偏移 offsetPointY
        pointY += offsetPointY;
    }
}

- (CGFloat)indexFromTouches:(NSSet<UITouch *> *)touches {
    CGFloat result = HBInvalidIndex;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    
    // 这是一个更为广义的 Index，小数部分可以确定相对位置
    result = (point.y - calculatePointY) / offsetPointY;
    
    return result;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat index = [self indexFromTouches:touches];
    self.highlightedIndex = index;
    
    if (_highlightedIndex >= 0 && _highlightedIndex < titleArr.count && progressBlock) {
        progressBlock(_highlightedIndex);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat index = [self indexFromTouches:touches];
    self.highlightedIndex = index;
    
    if (_highlightedIndex >= 0 && _highlightedIndex < titleArr.count && progressBlock) {
        progressBlock(_highlightedIndex);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_highlightedIndex >= 0 && _highlightedIndex < titleArr.count && finishBlock) {
        finishBlock(_highlightedIndex);
    }
    
    self.highlightedIndex = HBInvalidIndex;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlightedIndex = HBInvalidIndex;
}

@end
