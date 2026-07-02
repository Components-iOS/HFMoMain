#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HFTabBarController;
@class HFTabBarItem;

@interface UIViewController (HFTabBar)

@property (nonatomic, strong, nullable) HFTabBarItem *hf_tabBarItem;
@property (nonatomic, assign) BOOL hf_hidesBottomBarWhenPushed;
@property (nonatomic, weak, readonly, nullable) HFTabBarController *hf_tabBarController;

- (void)hf_bindTabBarItem:(nullable HFTabBarItem *)item;

@end

NS_ASSUME_NONNULL_END
