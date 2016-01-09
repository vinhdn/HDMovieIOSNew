//
//  Sub.h
//  HDMovieTemplate
//
//  Created by Do Ngoc Vinh on 1/9/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Sub : JSONModel
@property (strong, nonatomic) NSString<Optional>* Label;
@property (strong, nonatomic) NSString<Optional>* Source;
@property (strong, nonatomic) NSString<Ignore>* Content;
@end
