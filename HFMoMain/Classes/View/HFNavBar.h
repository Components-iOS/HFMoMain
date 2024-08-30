//
//  HFNavBar.h
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import <UIKit/UIKit.h>

@interface HFNavBar : UINavigationBar

/**
 *  设置全局的导航栏背景颜色
 *
 *  @param globalColor 全局导航栏背景颜色
 */
+ (void)setGlobalBackGroundColor:(UIColor *)globalColor;

/**
 *  设置全局导航栏标题颜色, 和文字大小
 *
 *  @param globalTextColor 全局导航栏标题颜色
 *  @param fontSize        全局导航栏文字大小
 */
+ (void)setGlobalTextColor:(UIColor *)globalTextColor andFontSize:(CGFloat)fontSize;

@end
