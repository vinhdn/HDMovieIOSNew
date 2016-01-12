//
//  DetailController.h
//  HDMovie
//
//  Created by iService on 1/7/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>
#import "Movie.h"
#import <QuartzCore/QuartzCore.h>
#import "EPCell.h"

@interface DetailController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *thumbIV;
@property (weak, nonatomic) IBOutlet UIImageView *thumb02IV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *engLb;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *viLB;
- (IBAction)moreDetail:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *desLb;
@property (weak, nonatomic) IBOutlet UIView *bgThumbV;
- (IBAction)play:(UIButton *)sender;
- (IBAction)showListEP:(id)sender;
- (IBAction)back:(UIButton *)sender;
@property(nonatomic) NSString *movieId;
@property(nonatomic) Movie *movie;
@end
