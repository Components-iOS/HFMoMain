//
//  HFNavigationViewController.m
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import "HFNavigationViewController.h"
#import "HFNavBar.h"
#import "HFMainConfigs.h"
#import "HFMainConfigs+HFStyle.h"
#import "HFTabBarController.h"
#import "UIViewController+HFTabBar.h"

@interface HFNavigationViewController () <UIGestureRecognizerDelegate>

@end

@implementation HFNavigationViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        HFMainConfigs *mainConfigs = [HFMainConfigs defaultManager];

        HFNavBar *navigationBar = [HFNavBar new];
        [mainConfigs hf_applyToNavigationBar:navigationBar];
        [self setValue:navigationBar forKey:@"navigationBar"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 检查系统版本是否支持 iOS 13 及以上
    if (@available(iOS 13.0, *)) {
        // 设置全局的外观主题为浅色模式
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    // 设置手势代理
    UIGestureRecognizer *gester = self.interactivePopGestureRecognizer;

    // 自定义手势
    // 手势加在谁身上, 手势执行谁的什么方法
    UIPanGestureRecognizer *panGester = [[UIPanGestureRecognizer alloc] initWithTarget:gester.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
    // 其实就是控制器的容器视图
    [gester.view addGestureRecognizer:panGester];

    gester.delaysTouchesBegan = YES;
    panGester.delegate = self;
    self.navigationBar.translucent = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self hf_notifyTabBarControllerIfNeededAnimated:NO];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        viewController.hf_hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hf_hidesBottomBarWhenPushed = NO;
    }
        
    [super pushViewController:viewController animated:animated];
    [self hf_notifyTabBarControllerIfNeededAnimated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    [self hf_notifyTabBarControllerIfNeededAnimated:animated];
    return viewController;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    [self hf_notifyTabBarControllerIfNeededAnimated:animated];
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToViewController:viewController animated:animated];
    [self hf_notifyTabBarControllerIfNeededAnimated:animated];
    return viewControllers;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    [self hf_notifyTabBarControllerIfNeededAnimated:animated];
}

- (void)hf_notifyTabBarControllerIfNeededAnimated:(BOOL)animated {
    HFTabBarController *tabBarController = self.hf_tabBarController;
    if (!tabBarController) {
        return;
    }
    [tabBarController hf_selectedNavigationStateDidChangeAnimated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果根控制器也要返回手势有效, 就会造成假死状态
    // 所以, 需要过滤根控制器
    if(self.childViewControllers.count == 1) {
        return NO;
    }

    return YES;
}

@end
