//
//  TopMovieCell.h
//  HDMovieTemplate
//
//  Created by iservice on 1/13/16.
//  Copyright © 2016 VinhDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMovieCell : UICollectionViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
-(void)scrollToPage:(NSInteger)page;
-(void)initView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property(nonatomic) NSMutableArray* movies;
-(void)scrollPages;
@end
