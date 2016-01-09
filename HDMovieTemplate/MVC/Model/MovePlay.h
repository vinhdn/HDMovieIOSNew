//
//  MovePlay.h
//  HDMovieTemplate
//
//  Created by Do Ngoc Vinh on 1/9/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MovePlay : JSONModel
@property (strong, nonatomic) NSString<Optional>* MovieID;
@property (strong, nonatomic) NSString* MovieName;
@property (strong, nonatomic) NSString<Optional>* LinkPlay;
@property (strong, nonatomic) NSString<Optional>* SourceLinkPlay;
@property (strong, nonatomic) NSDictionary<Optional>* SubtitleExt;
@property (assign, nonatomic) int Episode;
@property (assign, nonatomic) NSNumber<Optional>* CurrentSeason;
@end
