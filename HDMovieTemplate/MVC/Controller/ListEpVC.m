//
//  ListEpVC.m
//  HDMovieTemplate
//
//  Created by iService on 1/12/16.
//  Copyright © 2016 VinhDN. All rights reserved.
//

#import "ListEpVC.h"
#import <STPopup/STPopup.h>
#import "EPCell.h"

@implementation ListEpVC
-(void)viewDidLoad{
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numberEP;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EpisodeCell" forIndexPath:indexPath];
    cell.numberLb.text = [NSString stringWithFormat:@"%li", indexPath.row + 1];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.popupController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(epSelected:didSelectEP:)]) {
        [self.delegate epSelected:self didSelectEP:indexPath.row + 1];
    }
}
@end
