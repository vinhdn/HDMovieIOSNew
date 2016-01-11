//
//  SelectSubQC.h
//  HDMovieTemplate
//
//  Created by iService on 1/11/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Resolution.h"
@class SelectSubQC;
@protocol QualitySelectionListener <NSObject>
- (void)qualitySelectedVC:(SelectSubQC *)vc didFinishWithSelections:(NSInteger)selection;
@end
@interface SelectSubQC : UITableViewController
@property(nonatomic) NSMutableArray *resolution;
@property(nonatomic) NSInteger currentQuality;
- (IBAction)done:(UIBarButtonItem *)sender;
@property (nonatomic, weak) id<QualitySelectionListener> delegate;
@end
