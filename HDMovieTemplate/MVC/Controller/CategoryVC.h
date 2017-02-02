//
//  CategoryVC.h
//  HDMovie
//
//  Created by iservice on 1/19/16.
//  Copyright © 2016 VinhDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface CategoryVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (assign) NSInteger cateID;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableResultSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *resultSearchView;
@property (nonatomic, strong, nullable) UIRefreshControl *refreshControl ;
- (IBAction)menuClick:(id)sender;

@end
