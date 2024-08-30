//
//  HFTabBarController.h
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import <UIKit/UIKit.h>

@interface HFTabBarController : UITabBarController

/**
 * 获取单例对象
 *
 * @return TabBarController
 */
+ (instancetype)shareInstance;

/**
 * 添加子控制器的block
 *
 * @param addVCBlock 添加代码块
 * @return TabBarController
 */
+ (instancetype)tabBarControllerWithAddChildVCsBlock: (void(^)(HFTabBarController *tabBarC))addVCBlock;

/**
 * 添加子控制器
 * @param vc                子控制器
 * @param titleStr          菜单标题
 * @param normalImageName   普通状态下图片
 * @param selectedImageName 选中图片
 * @param isRequired        是否需要包装导航控制器
 */
- (void)addChildVC:(UIViewController *)vc titleStr:(NSString *)titleStr normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName  isRequiredNavController:(BOOL)isRequired;

@end
