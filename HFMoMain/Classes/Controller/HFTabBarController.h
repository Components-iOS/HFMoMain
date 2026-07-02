//
//  HFTabBarController.h
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HFTabBarItem;

@protocol HFTabBarControllerDelegate;

@interface HFTabBarController : UIViewController

@property (nonatomic, weak, nullable) id<HFTabBarControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong, readonly, nullable) UIViewController *selectedViewController;
@property (nonatomic, strong, readonly) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, strong, readonly) NSArray<HFTabBarItem *> *items;
@property (nonatomic, assign, readonly, getter=isToolbarHidden) BOOL toolbarHidden;
@property (nonatomic, assign) BOOL liquidGlassEnabled;
@property (nonatomic, assign) BOOL blurEnabled;
@property (nonatomic, assign) UIBlurEffectStyle blurStyle;
@property (nonatomic, strong, nullable) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL showTopSeparator;
@property (nonatomic, strong, nullable) UIColor *separatorColor;
@property (nonatomic, assign) BOOL extendContentUnderTabbar;

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

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                  items:(NSArray<HFTabBarItem *> *)items
                   defaultSelectedIndex:(NSInteger)defaultSelectedIndex;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                  items:(NSArray<HFTabBarItem *> *)items;

/**
 * 添加子控制器
 * @param vc                子控制器
 * @param titleStr          菜单标题
 * @param normalImageName   普通状态下图片
 * @param selectedImageName 选中图片
 * @param isRequired        是否需要包装导航控制器
 */
- (void)addChildVC:(UIViewController *)vc titleStr:(NSString *)titleStr normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName  isRequiredNavController:(BOOL)isRequired;

- (void)switchToIndex:(NSInteger)index;
- (void)replaceViewController:(UIViewController *)viewController atIndex:(NSInteger)index;
- (void)replaceViewController:(UIViewController *)viewController atIndex:(NSInteger)index andSwitchTo:(BOOL)switchTo;
- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)updateItem:(HFTabBarItem *)item atIndex:(NSInteger)index;
- (void)hf_selectedNavigationStateDidChangeAnimated:(BOOL)animated;

@end

@protocol HFTabBarControllerDelegate <NSObject>

@optional

- (void)hfTabBarController:(HFTabBarController *)tabBarController
            didSelectIndex:(NSInteger)index
            viewController:(UIViewController *)viewController;

- (BOOL)hfTabBarController:(HFTabBarController *)tabBarController
         shouldSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
