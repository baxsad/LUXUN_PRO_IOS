
#import <Foundation/Foundation.h>

#pragma mark 屏幕旋转方向

typedef NS_ENUM(NSUInteger, LXScreenDirection) {
    LXScreenDirectionVertical    = 0, //<- 竖屏 >
    LXScreenDirectionCross    = 1 << 0 //<- 横屏 >
};

#pragma mark 首页布局相关

#define ITEM_NUMBER_INLINE 3 //<- 每行现实多少个分组 >
#define ITEM_PADDING 11 //<- 分组之间间距 >
#define RATIO_OF_LENGTH_TO_WIDTH 0.8f // <-分组长宽比 >

#pragma mark 分集

#define SETS_COLLECTION_INSET UIEdgeInsetsMake(0, 10, 0, 10)
#define SET_ITEM_NUMBER_IN_LINE 7 //<- 一行显示多少分集 >
#define SET_ITEM_MARGIN__T_B 5 //<- 分集item上下边距 >
#define SET_ITEM_MARGIN__L_R 5 //<- 分集item左右边距 >
#define SET_ITEM_HEIGHT 30 //<- 分集item高度 >
#define SET_BG_COLOR_NORMALL UIColorHex(0xFEE0ED) //<- 分集普通状态背景颜色 >
#define SET_BG_COLOR_SELECTED UIColorHex(0xF32A7D) //<- 分集选中状态背景颜色 >
#define SET_TITLE_COLOR_NORMALL UIColorHex(0xF32A7D) //<-  分集普通状态字体颜色 >
#define SET_TITLE_COLOR_SELECTED UIColorHex(0xFFFFFF) //<-  分集选中状态字体颜色 >

#pragma mark 视频页

#define CONTENTS_INPUT_HEIGHT 110 //<- 评论框高度 >

#pragma mark 用户信息的缓存key

#define kUSERCACHE @"kUSERCACHE" //<- 用户信息缓存 >
#define kLUXUNDATA @"kLUXUNDATA" //<- 首页数据缓存 >

#pragma mark 常用参数

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_HEIGHT SCREEN_SIZE.height
#define SCREEN_WIDTH SCREEN_SIZE.width
#define SCREEN_SCALE [UIScreen mainScreen].scale
#define SINGLE_LINE_WIDTH   (1 / SCREEN_SCALE)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / SCREEN_SCALE) / 2)
#define NAVCOLOR UIColorHex(0xF9F7F4) //<- 导航控制器颜色 >
#define TEMCOLOR UIColorHex(0xE52D7A) //<- 主题颜色 >

#pragma mark 用户登录相关

#define ACCOUNT_CENTER [AccountCenter shareInstance]
#define USER_TOKEN ACCOUNT_CENTER.sss
#define ISLOGIN (USER_TOKEN && USER_TOKEN.length > 5)

#pragma mark 视频源地址集合

#define VIDEO_SOURCES @[\
                         @"http://boku.luxun.pro",\
                         @"http://0.luxun.pro:12580",\
                         @"http://kayo.luxun.pro",\
                         @"http://usagi.luxun.pro",\
                       ]

#pragma mark 网络请求
#define Referer @"http://luxun.pro/"
