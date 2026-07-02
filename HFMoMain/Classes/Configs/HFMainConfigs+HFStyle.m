#import "HFMainConfigs+HFStyle.h"
#import "HFNavBar.h"
#import "HFTabBar.h"
#import "HFTabBarItem.h"

@implementation HFMainConfigs (HFStyle)

- (UIColor *)hf_effectiveTabbarBackgroundColor {
    if (self.tabbarLiquidGlassEnabled) {
        return nil;
    }
    return self.tabbarBGColor ?: UIColor.whiteColor;
}

- (BOOL)hf_effectiveTabbarSeparatorEnabled {
    if (self.tabbarLiquidGlassEnabled) {
        return NO;
    }
    return self.isTabbarSeparator;
}

- (UIColor *)hf_effectiveTabbarNormalTitleColor {
    return self.tabbarNormalTitleColor ?: UIColor.grayColor;
}

- (UIColor *)hf_effectiveTabbarSelectedTitleColor {
    return self.tabbarSelectedTitleColor ?: UIColor.systemBlueColor;
}

- (CGFloat)hf_effectiveTabbarNormalFontSize {
    return self.tabbarNormalFontSize > 0 ? self.tabbarNormalFontSize : 10.0;
}

- (CGFloat)hf_effectiveTabbarSelectedFontSize {
    if (self.tabbarSelectedFontSize > 0) {
        return self.tabbarSelectedFontSize;
    }
    return [self hf_effectiveTabbarNormalFontSize];
}

- (CGFloat)hf_effectiveTabbarTitleImageSpacing {
    return self.tabbarTitleImageSpacing;
}

- (void)hf_applyToNavigationBar:(HFNavBar *)navigationBar {
    if (!navigationBar) {
        return;
    }
    
    [navigationBar hf_applyBackgroundColor:self.navBarBGColor
                                titleColor:self.navBarTitleColor
                                  fontSize:self.navBarFontSize];
    navigationBar.hf_showsSeparator = self.isNavBarSeparator;
}

- (void)hf_applyToCustomTabBar:(HFTabBar *)tabBar {
    if (!tabBar) {
        return;
    }
    
    tabBar.barBackgroundColor = [self hf_effectiveTabbarBackgroundColor];
    tabBar.showsTopSeparator = [self hf_effectiveTabbarSeparatorEnabled];
}

- (void)hf_applyToTabBarItem:(HFTabBarItem *)item {
    if (!item) {
        return;
    }
    
    if (!item.normalColor) {
        item.normalColor = [self hf_effectiveTabbarNormalTitleColor];
    }
    if (!item.selectedColor) {
        item.selectedColor = [self hf_effectiveTabbarSelectedTitleColor];
    }
    if (item.normalFontSize <= 0) {
        item.normalFontSize = [self hf_effectiveTabbarNormalFontSize];
    }
    if (item.selectedFontSize <= 0) {
        item.selectedFontSize = [self hf_effectiveTabbarSelectedFontSize];
    }
    if (item.fontSize <= 0) {
        item.fontSize = [self hf_effectiveTabbarNormalFontSize];
    }
    if (item.titleImageSpacing == CGFLOAT_MIN) {
        item.titleImageSpacing = [self hf_effectiveTabbarTitleImageSpacing];
    }
}

- (void)hf_applyToSystemTabBar:(UITabBar *)tabBar {
    if (!tabBar) {
        return;
    }
    
    UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
    [appearance configureWithDefaultBackground];
    NSDictionary *normalTitleAttributes = @{
        NSForegroundColorAttributeName: [self hf_effectiveTabbarNormalTitleColor],
        NSFontAttributeName: [UIFont systemFontOfSize:[self hf_effectiveTabbarNormalFontSize]]
    };
    NSDictionary *selectedTitleAttributes = @{
        NSForegroundColorAttributeName: [self hf_effectiveTabbarSelectedTitleColor],
        NSFontAttributeName: [UIFont systemFontOfSize:[self hf_effectiveTabbarSelectedFontSize]]
    };
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalTitleAttributes;
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTitleAttributes;
    appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalTitleAttributes;
    appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedTitleAttributes;
    appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalTitleAttributes;
    appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedTitleAttributes;
    tabBar.standardAppearance = appearance;
    if (@available(iOS 15.0, *)) {
        tabBar.scrollEdgeAppearance = appearance;
    }
}

@end
