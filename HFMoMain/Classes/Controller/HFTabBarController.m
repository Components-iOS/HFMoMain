//
//  HFTabBarController.m
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import "HFTabBarController.h"
#import "HFNavigationViewController.h"
#import "HFTabBar.h"

@interface HFTabBarController ()

@end

@implementation HFTabBarController

+ (instancetype)shareInstance {
    static HFTabBarController *tabbarC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbarC = [[HFTabBarController alloc] init];
    });
    
    return tabbarC;
}

+ (instancetype)tabBarControllerWithAddChildVCsBlock: (void(^)(HFTabBarController *tabBarC))addVCBlock {
    HFTabBarController *tabbarVC = [[HFTabBarController alloc] init];
    
    if (addVCBlock) {
        addVCBlock(tabbarVC);
    }

    return tabbarVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tabbar
    [self setUpTabbar];
}

- (void)setUpTabbar {
    [HFTabBar setGlobalBackGroundColor:UIColor.whiteColor];
    [self setValue:[HFTabBar new] forKey:@"tabBar"];
}

/**
 *  根据参数, 创建并添加对应的子控制器
 *
 *  @param vc                需要添加的控制器(会自动包装导航控制器)
 *  @param isRequired        标题
 *  @param normalImageName   一般图片名称
 *  @param selectedImageName 选中图片名称
 */
- (void)addChildVC:(UIViewController *)vc titleStr:(NSString *)titleStr normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName  isRequiredNavController:(BOOL)isRequired {
    if (isRequired) {
        HFNavigationViewController *nav = [[HFNavigationViewController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleStr image:[self originImageWithName:normalImageName] selectedImage:[self originImageWithName:selectedImageName]];
        [self addChildViewController:nav];
    } else {
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleStr image:[self originImageWithName:normalImageName] selectedImage:[self originImageWithName:selectedImageName]];
        [self addChildViewController:vc];
    }

}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
}

- (UIImage *)originImageWithName:(NSString *)name {
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
