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

#import "CTMediator+HandyTools.h"
#import "CTMediator.h"
#import "MGJRouter.h"

FOUNDATION_EXPORT double HFRouterVersionNumber;
FOUNDATION_EXPORT const unsigned char HFRouterVersionString[];

