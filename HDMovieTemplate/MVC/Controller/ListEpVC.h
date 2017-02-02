//
//  ListEpVC.h
//  HDMovieTemplate
//
//  Created by iService on 1/12/16.
//  Copyright © 2016 VinhDN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListEpVC;
@protocol EPSelectedListener<NSObject>
-(void) epSelected:(ListEpVC*)vc didSelectEP:(NSInteger) ep;
@end
@interface ListEpVC : UICollectionViewController
@property(nonatomic) NSInteger numberEP;
@property(nonatomic, weak) id<EPSelectedListener> delegate;
@end
