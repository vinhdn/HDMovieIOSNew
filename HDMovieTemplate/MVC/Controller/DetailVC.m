//
//  DetailVC.m
//  HDMovie
//
//  Created by iservice on 1/21/16.
//  Copyright © 2016 VinhDN. All rights reserved.
//

#import "DetailVC.h"
#import "CollectionViewCell.h"

@implementation DetailVC

-(void)viewDidLoad{
    [super viewDidLoad];
    UINib *nibColor = [UINib nibWithNibName:@"HeaderDetail" bundle: nil];
    [self.collectionView registerNib:nibColor forCellWithReuseIdentifier:@"HeaderDetail"];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0) return 1;
    return 10;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderDetail" forIndexPath:indexPath];
        return cell;
    }
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.3;
    CGSize size = CGSizeMake(cellWidth, cellWidth * 16.0 / 10.0);
    if (indexPath.section == 0) {
        CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
        size = CGSizeMake(screenWidth, defaultSize.height);
    }
    return size;
}
@end
