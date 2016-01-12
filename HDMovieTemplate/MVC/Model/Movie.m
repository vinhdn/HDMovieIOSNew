//
//  Movie.m
//  HDMovie
//
//  Created by iService on 1/6/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import "Movie.h"

@implementation Movie
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString: @"Sequence"]) return YES;
    return NO;
}
@end
