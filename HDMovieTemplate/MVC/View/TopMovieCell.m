//
//  TopMovieCell.m
//  HDMovieTemplate
//
//  Created by iservice on 1/13/16.
//  Copyright © 2016 VinhDN. All rights reserved.
//

#import "TopMovieCell.h"
#import "Movie.h"

@implementation TopMovieCell{
    NSTimer *timer;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = pageNumber;
    self.titleLb.text = [(Movie*)[self.movies objectAtIndex:pageNumber] KnownAs];
}
-(void)scrollToPage:(NSInteger)aPage{
    [self.scrollView setContentOffset:CGPointMake(aPage * self.scrollView.bounds.size.width,0) animated:YES];
}
-(void)initView{
    if(self.movies != nil && [self.movies count] > 0){
    self.titleLb.text = [(Movie*)[self.movies objectAtIndex:0] KnownAs];
    }else{
        self.titleLb.text = @"";
    }
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:4
                                     target:self
                                   selector:@selector(scrollPages)
                                   userInfo:Nil
                                    repeats:YES];
    [timer fire];
}
-(void)scrollPages{
    if(self.pageControl.numberOfPages > 0)
    [self scrollToPage:(self.pageControl.currentPage + 1) % self.pageControl.numberOfPages];

}
@end
