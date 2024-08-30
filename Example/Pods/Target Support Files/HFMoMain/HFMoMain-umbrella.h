#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HFNavigationViewController.h"
#import "HFTabBarController.h"
#import "HFMainModuleAPI.h"
#import "HFMainModuleRouter.h"
#import "HFNavBar.h"
#import "HFTabBar.h"

FOUNDATION_EXPORT double HFMoMainVersionNumber;
FOUNDATION_EXPORT const unsigned char HFMoMainVersionString[];

