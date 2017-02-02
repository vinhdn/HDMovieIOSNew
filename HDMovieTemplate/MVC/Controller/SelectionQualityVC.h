//
//  SelectionQualityVC.h
//  HDMovieTemplate
//
//  Created by iService on 1/11/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTitle.h"

@class SelectionQualityVC;
@protocol SelectionQualityVCDelegate <NSObject>

- (void)selectionQualityVC:(SelectionQualityVC *)vc didFinishWithSelections:(NSInteger)selections;

@end
@interface SelectionQualityVC : UITableViewController
@property(nonatomic) SubTitle *sub;
- (IBAction)done:(UIBarButtonItem *)sender;
@property(nonatomic) NSInteger currentSub;
@property (nonatomic, weak) id<SelectionQualityVCDelegate> delegate;
@end
