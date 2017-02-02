//
//  Utils.h
//  HDMovieTemplate
//
//  Created by iService on 1/11/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+(NSString*)timeToString:(NSTimeInterval)time;
+(NSArray*) getListResolution:(NSString*) data;
@end
