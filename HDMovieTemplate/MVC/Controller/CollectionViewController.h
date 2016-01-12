//
//  CollectionViewController.h
//  HDMovie
//
//  Created by iService on 1/4/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConnect.h"
#import "AppDelegate.h"
#import "Categories.h"
#import "Movie.h"
#import "DetailController.h"
@import Foundation;

@interface CollectionViewController : UIViewController<UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *resultSearchView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableResultSearch;
@property (nonatomic, strong, nullable) UIRefreshControl *refreshControl ;
@property (nonatomic,strong,nullable) NSMutableArray * listData;
@end
