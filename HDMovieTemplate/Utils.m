//
//  Utils.m
//  HDMovieTemplate
//
//  Created by iService on 1/11/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(NSString *)timeToString:(NSTimeInterval)timeInterval{
    NSInteger interval = timeInterval;
    NSInteger ms = (fmod(timeInterval, 1) * 1000);
    long seconds = interval % 60;
    long minutes = (interval / 60) % 60;
    long hours = (interval / 3600);
    if(hours >0){
    return [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld", hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%0.2ld:%0.2ld", minutes, seconds];
    }
}
+(NSArray *)getListResolution:(NSString *)data{
    return nil;
}
@end
