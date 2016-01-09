//
//  PlayMovieVC.h
//  HDMovieTemplate
//
//  Created by iService on 1/9/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovePlay.h"

@interface PlayMovieVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIView *parentPlayerV;
@property(nonatomic) NSString *movieId;
@end
