#import "UIViewController+HFTabBar.h"
#import <objc/runtime.h>
#import "HFTabBarController.h"
#import "HFTabBarItem.h"

static const void *kHFTabBarItemKey = &kHFTabBarItemKey;
static const void *kHFHidesBottomBarWhenPushedKey = &kHFHidesBottomBarWhenPushedKey;

@implementation UIViewController (HFTabBar)

- (void)setHf_tabBarItem:(HFTabBarItem *)hf_tabBarItem {
    objc_setAssociatedObject(self, kHFTabBarItemKey, hf_tabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HFTabBarItem *)hf_tabBarItem {
    return objc_getAssociatedObject(self, kHFTabBarItemKey);
}

- (void)setHf_hidesBottomBarWhenPushed:(BOOL)hf_hidesBottomBarWhenPushed {
    objc_setAssociatedObject(self, kHFHidesBottomBarWhenPushedKey, @(hf_hidesBottomBarWhenPushed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hf_hidesBottomBarWhenPushed {
    NSNumber *value = objc_getAssociatedObject(self, kHFHidesBottomBarWhenPushedKey);
    return value.boolValue;
}

- (HFTabBarController *)hf_tabBarController {
    UIViewController *parent = self.parentViewController;
    while (parent) {
        if ([parent isKindOfClass:HFTabBarController.class]) {
            return (HFTabBarController *)parent;
        }
        parent = parent.parentViewController;
    }
    return nil;
}

- (void)hf_bindTabBarItem:(HFTabBarItem *)item {
    self.hf_tabBarItem = item;
}

@end
