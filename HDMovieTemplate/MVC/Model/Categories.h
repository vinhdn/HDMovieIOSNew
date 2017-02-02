//
//  Categories.h
//  HDMovie
//
//  Created by iService on 1/7/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "JSONModel.h"
@protocol Movie
@end
@interface Categories : JSONModel
@property (strong, nonatomic) NSNumber<Optional> *CategoryID;
@property (strong, nonatomic) NSString<Optional>* CategoryName;
@property (strong, nonatomic) NSArray<Movie, Optional>* Movies;
@end
