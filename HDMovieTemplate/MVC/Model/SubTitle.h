//
//  SubTitle.h
//  HDMovieTemplate
//
//  Created by Do Ngoc Vinh on 1/10/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Sub.h"

@interface SubTitle : JSONModel
@property (strong, nonatomic) Sub<Optional>* VIE;
@property (strong, nonatomic) Sub<Optional>* ENG;
@property (strong, nonatomic) Sub<Optional>* CHT;
@end
