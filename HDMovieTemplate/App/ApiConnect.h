//
//  ApiConnect.h
//  HDMovie
//
//  Created by iService on 1/6/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Define.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>

@interface ApiConnect : NSObject{
    
}
+(NSDictionary*)sendRequest:api method:(NSString*)method params:(NSMutableDictionary*)params;
+ (nullable NSURLSessionDataTask *)getHomePage:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
+(NSURLSessionDataTask *)getVideoPlay:(NSString*) movieId success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure;
@end
