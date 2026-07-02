#import "HFMainConfigs.h"

NS_ASSUME_NONNULL_BEGIN

@class HFNavBar;
@class HFTabBar;
@class HFTabBarItem;
@class UITabBar;

@interface HFMainConfigs (HFStyle)

- (nullable UIColor *)hf_effectiveTabbarBackgroundColor;
- (BOOL)hf_effectiveTabbarSeparatorEnabled;
- (UIColor *)hf_effectiveTabbarNormalTitleColor;
- (UIColor *)hf_effectiveTabbarSelectedTitleColor;
- (CGFloat)hf_effectiveTabbarNormalFontSize;
- (CGFloat)hf_effectiveTabbarSelectedFontSize;

- (void)hf_applyToNavigationBar:(HFNavBar *)navigationBar;
- (void)hf_applyToCustomTabBar:(HFTabBar *)tabBar;
- (void)hf_applyToTabBarItem:(HFTabBarItem *)item;
- (void)hf_applyToSystemTabBar:(UITabBar *)tabBar;

@end

NS_ASSUME_NONNULL_END
