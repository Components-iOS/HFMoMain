//
//  HFMainModuleAPI.h
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFMainModuleAPI : NSObject

/**
 * 获取根控制器
 *
 * @return rootTabBarCcontroller
 */
+ (UITabBarController *)rootTabBarCcontroller;

/**
 * 添加子控制器
 *
 * @param vc                子控制器
 * @param titleStr          菜单标题
 * @param normalImageName   普通状态下图片
 * @param selectedImageName 选中图片
 * @param isRequired        是否需要包装导航控制器
 */
+ (void)addChildVC:(UIViewController *)vc titleStr:(NSString *)titleStr normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController:(BOOL)isRequired;

/**
 *  设置全局导航栏标题颜色, 和文字大小
 *
 *  @param globalTextColor 全局导航栏标题颜色
 *  @param fontSize        全局导航栏文字大小
 */
+ (void)setNavBarGlobalTextColor:(UIColor *)globalTextColor andFontSize: (CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
