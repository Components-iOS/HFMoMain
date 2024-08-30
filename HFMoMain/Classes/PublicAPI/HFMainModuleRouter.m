//
//  HFMainModuleRouter.m
//  HFMoMain
//
//  Created by liuhongfei on 2021/4/15.
//

#import "HFMainModuleRouter.h"
#import "HFMainModuleAPI.h"
#import <HFRouter/MGJRouter.h>

@implementation HFMainModuleRouter

+ (void)load {
    [MGJRouter registerURLPattern:@"xmg://getRootVC" toObjectHandler:^id(NSDictionary *routerParameters) {
        return [HFMainModuleAPI rootTabBarCcontroller];
    }];
    
    [MGJRouter registerURLPattern:@"xmg://addChildVC" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *params = routerParameters[MGJRouterParameterUserInfo];
        
        UIViewController *vc = params[@"vc"];
        NSString *title = params[@"title"];
        NSString *nImg = params[@"nImg"];
        NSString *sImg = params[@"sImg"];
        BOOL isR = [params[@"isR"] boolValue];
                
        [HFMainModuleAPI addChildVC:vc titleStr:title normalImageName:nImg selectedImageName:sImg isRequiredNavController:isR];
        
        void(^block)(id result) = routerParameters[MGJRouterParameterCompletion];
        
        if (block) {
            block([NSString stringWithFormat:@"%@菜单加载完成",title]);
        }
    }];
}

@end
