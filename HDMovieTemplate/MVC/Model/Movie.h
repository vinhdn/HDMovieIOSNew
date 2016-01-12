//
//  Movie.h
//  HDMovie
//
//  Created by iService on 1/6/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface Movie : JSONModel

@property (strong, nonatomic) NSString* MovieID;
@property (strong, nonatomic) NSString* MovieName;
@property (strong, nonatomic) NSString<Optional>* CategoryName;
@property (strong, nonatomic) NSString<Optional>* Cover;
@property (strong, nonatomic) NSString<Optional>* Link;
@property (strong, nonatomic) NSString<Optional>* KnownAs;
@property (strong, nonatomic) NSString<Optional>* Poster100x149;
@property (strong, nonatomic) NSString<Optional>* CategoryID;
@property (strong, nonatomic) NSString<Optional>* PlotVI;
@property (strong, nonatomic) NSString<Optional>* PlotEN;
@property (strong, nonatomic) NSString<Optional>* Backdrop;
@property (assign, nonatomic) NSInteger Sequence;
@end
