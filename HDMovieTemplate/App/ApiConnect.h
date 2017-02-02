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
+(NSURLSessionDataTask *)getVideoPlay:(NSString*) movieId ep:(NSInteger)ep success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure;
+(AFHTTPRequestOperation *)getSub:(NSString*) url success:(void (^)(AFHTTPRequestOperation *, id _Nullable))success failure:(void (^)(AFHTTPRequestOperation * _Nullable, NSError *))failure;
+(NSURLSessionDataTask *)search:(NSString*) key success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure;
+(NSURLSessionDataTask *)getCategories:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure;
+(NSURLSessionDataTask *)getMoviesOfCategory:(NSInteger) cateID offset:(NSInteger) offset success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure;
+(NSString*)getSu:api params:(NSMutableDictionary*)params;
+(NSString*)getQuality:url;
@end
