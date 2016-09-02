//
//  PYScrollViewAdjustTool.h
//  yr
//
//  Created by yr on 15/9/14.
//  Copyright (c) 2015年 yr. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author YangRui, 16-02-24 17:02:34
 *
 *  键盘弹起和隐藏时,改变视图位置的工具类
 */
@interface PYScrollViewAdjustTool : NSObject<UITextFieldDelegate>

/*键盘弹起时,移动指定视图到键盘上方*/
+(void)adjustViewToKeyboardTop:(UIView*)view atScrollView:(UIScrollView*)sv;
/*重置指定视图的位置,一般在键盘关闭的时候调用*/
+(void)restoreView:(UIView*)view;

@end
