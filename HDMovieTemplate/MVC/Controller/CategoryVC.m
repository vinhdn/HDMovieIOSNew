//
//  CategoryVC.m
//  HDMovie
//
//  Created by iservice on 1/19/16.
//  Copyright © 2016 VinhDN. All rights reserved.
//

#import "CategoryVC.h"
#import "REFrostedViewController.h"
#import "CollectionViewController.h"
#import "ResultSearchCell.h"
#import "CollectionViewCell.h"

@implementation CategoryVC{
        NSMutableArray *movies, *resultSearch;
    NSURLSessionDataTask *searchManager;
    NSInteger total;
}
static NSString * const reuseIdentifier = @"Cell";
-(void)viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    movies = [[NSMutableArray alloc] init];
    [self loadData];
}

-(void) loadData{
    if ([movies count] >= total) {
        return;
    }
    if(self.refreshControl != nil){
        [self.refreshControl beginRefreshing];
    }
    [ApiConnect getMoviesOfCategory:self.cateID offset:[movies count] success:^(NSURLSessionDataTask *session, id _Nullable response) {
        NSLog(@"CATE Response %@",response);
        NSDictionary *data = [response valueForKeyPath:@"r"];
        total = [[data valueForKeyPath:@"Total"] integerValue];
        Categories *cate = [[Categories alloc] initWithDictionary:data error:nil];
        if (cate == nil || cate.Movies == nil){
            return;
        }
        [movies addObjectsFromArray:cate.Movies];
        if(movies == nil)
            return;
        [self.collectionView reloadData];
        if(self.refreshControl != nil){
            [self.refreshControl endRefreshing];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(self.refreshControl != nil){
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    movies=[[NSMutableArray alloc] init];
    total = 20;
    self.title = @"HDMovie";
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.collectionView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    [self reload:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menuClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [movies count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


#pragma mark <UISearchBarDelegate>

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length > 0){
        self.resultSearchView.hidden = NO;
        if(searchManager != nil) [searchManager cancel];
        searchManager = [ApiConnect search:searchText success:^(NSURLSessionDataTask *mana, id _Nullable success) {
            resultSearch = [[NSMutableArray alloc] init];
            NSLog(@"SEARCH RESULT %@", success);
            NSDictionary *data = [success valueForKeyPath:@"Title"];
            for (NSDictionary *key in [data allValues]) {
                
                Movie *mov = [[Movie alloc] init];
                mov.MovieID = [key valueForKeyPath:@"MovieID"];
                mov.MovieName = [key valueForKeyPath:@"MovieName"];
                mov.Backdrop = [key valueForKeyPath:@"Backdrop"];
                mov.KnownAs = [key valueForKeyPath:@"KnownAs"];
                [resultSearch addObject:mov];
            }
            [self.tableResultSearch reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable mana, NSError *error) {
            NSLog(@"SEARCH ERROR %@", error);
            resultSearch = [[NSMutableArray alloc] init];
        }];
    }
    else{
        self.resultSearchView.hidden = YES;
        [searchBar resignFirstResponder];
    }
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //    [searchBar becomeFirstResponder];
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.resultSearchView.hidden = NO;
    //    [searchBar becomeFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.resultSearchView.hidden = YES;
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

#pragma mark <UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [resultSearch count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultSearchCell"];
    Movie *mov = [resultSearch objectAtIndex:indexPath.row];
    cell.titleLb.text = mov.MovieName;
    cell.knowAsLb.text = mov.KnownAs;
    [cell.imageV setImage:nil];
    [cell.imageV setImageWithURL:[NSURL URLWithString:mov.Backdrop]];
    return cell;
}

#pragma mark <UITableViewDelegate>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailController *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailController"];
    Movie *mov = [resultSearch objectAtIndex:indexPath.row];
    monitorMenuViewController.movieId = [mov MovieID];
    [self presentViewController:monitorMenuViewController animated:NO completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        // Configure the cell
    Movie *mov = [movies objectAtIndex:indexPath.row];
    cell.nameLb.text = [mov KnownAs];
    [cell.thumbIV setImage:nil];
    [cell.thumbIV setImageWithURL:[NSURL URLWithString:[mov Poster100x149]]];
    if(indexPath.row == [movies count] - 1){
        [self loadData];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailController *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailController"];
    Movie *mov = [movies objectAtIndex:indexPath.row];
    monitorMenuViewController.movieId = [mov MovieID];
    [self presentViewController:monitorMenuViewController animated:YES completion:nil];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.3;
    CGSize size = CGSizeMake(cellWidth, cellWidth * 16.0 / 10.0);
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{        return CGSizeZero;
}

@end
