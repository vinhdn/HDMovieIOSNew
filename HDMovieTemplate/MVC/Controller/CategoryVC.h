//
//  CategoryVC.h
//  HDMovie
//
//  Created by iservice on 1/19/16.
//  Copyright © 2016 VinhDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface CategoryVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)menuClick:(id)sender;

@end
