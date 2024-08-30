//
//  HFMainModuleAPI.m
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import "HFMainModuleAPI.h"
#import "HFTabBarController.h"
#import "HFNavBar.h"

@implementation HFMainModuleAPI

+ (HFTabBarController *)rootTabBarCcontroller {
    return [HFTabBarController shareInstance];
}

+ (void)addChildVC:(UIViewController *)vc titleStr:(NSString *)titleStr normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController:(BOOL)isRequired {
    [[HFTabBarController shareInstance] addChildVC:vc titleStr:titleStr normalImageName:normalImageName selectedImageName:selectedImageName isRequiredNavController:isRequired];
}

+ (void)setNavBarGlobalTextColor:(UIColor *)globalTextColor andFontSize:(CGFloat)fontSize {
    [HFNavBar setGlobalTextColor:globalTextColor andFontSize:fontSize];
}

@end
