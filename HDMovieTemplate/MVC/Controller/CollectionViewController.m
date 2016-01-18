//
//  CollectionViewController.m
//  HDMovie
//
//  Created by iService on 1/4/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "HeaderCollectionView.h"
#import "ResultSearchCell.h"
#import "TopMovieCell.h"

@import Foundation;
@interface CollectionViewController ()
@property (readwrite, nonatomic, strong) NSArray *posts;

@end

@implementation CollectionViewController{
    NSURLSessionDataTask *searchManager;
    NSMutableArray *resultSearch;
    NSMutableArray *headerMovie;
    CGFloat scrollBefore;
    CGFloat heightHeader;
}

static NSString * const reuseIdentifier = @"Cell";
-(void)viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:LINK_CONFIG parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if(self.refreshControl != nil){
            [self.refreshControl endRefreshing];
        }
        NSString *llba = [responseObject valueForKeyPath:@"link"];
        [AppDelegate setLink:llba];
        [AppDelegate setSign:[responseObject valueForKeyPath:@"sign"]];
        NSDictionary *parameters = @{@"sign": [AppDelegate appSign]};
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict= [ApiConnect sendRequest:HOMEPAGE method:@"GET" params:parameters];
            NSMutableArray *newData =  [[NSMutableArray alloc] init];
            if(dict == nil){
                
            }else{
                NSDictionary *rr = [dict valueForKeyPath:@"r"];
                NSArray *movHeader = [rr valueForKeyPath:@"Movies_Banners"];
                headerMovie = [[NSMutableArray alloc] init];
                for (NSDictionary *mo in movHeader) {
                    Movie *moo = [[Movie alloc] initWithDictionary:mo error:nil];
                    int aValue = [[moo.MovieID stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
                    if(aValue >= 0)
                        [headerMovie addObject:moo];
                }
                NSArray *movStr = [rr valueForKeyPath:@"MoviesByCates"];
                for (NSDictionary* cate in movStr) {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cate options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *data =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    Categories *catee = [[Categories alloc] initWithString:data error:nil];
                    [newData addObject:catee];
                }
                if([newData count] > 0){
                    self.listData = newData;
                    [self.collectionView reloadData];
                }
            }
        });
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.listData=[[NSMutableArray alloc] init];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return [self.listData count] + 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    return [[(Categories *)[self.listData objectAtIndex:section - 1] Movies] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(indexPath.section == 0){
        TopMovieCell *topCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopCell" forIndexPath:indexPath];
        topCell.scrollView.pagingEnabled =true;
        topCell.scrollView.contentSize = CGSizeMake(topCell.scrollView.bounds.size.width * [headerMovie count], topCell.scrollView.bounds.size.width * 9.0 / 16.0);
        topCell.scrollView.delegate = topCell;
        topCell.pageControl.numberOfPages = [headerMovie count];
        topCell.movies = headerMovie;
        for (int i = 0; i < [headerMovie count]; i++) {
            Movie *mov = [headerMovie objectAtIndex:i];
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.width * 9.0 / 16.0)];
            [view setImageWithURL:[NSURL URLWithString:mov.Cover]];
            [topCell.scrollView addSubview:view];
        }
        [topCell initView];
        topCell.scrollView.userInteractionEnabled = NO;
        [topCell addGestureRecognizer:topCell.scrollView.panGestureRecognizer];
        return topCell;
    }
    // Configure the cell
    Categories *cat = [self.listData objectAtIndex:indexPath.section];
    Movie *mov = [cat.Movies objectAtIndex:indexPath.row];
    cell.nameLb.text = [mov KnownAs];
    [cell.thumbIV setImage:nil];
    [cell.thumbIV setImageWithURL:[NSURL URLWithString:[mov Poster100x149]]];
    return cell;
}

- (IBAction)menuClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(void)headerClicked:(UIScrollView *)sender{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView.contentOffset.y < 0){
//        scrollBefore = 0;
//        return;
//    }
//    CGFloat top = scrollBefore - scrollView.contentOffset.y;
//    NSLog(@"Scrolled CollectionView %f", top);
//    if(top <= 0 && self.headerV.layer.position.y <= self.headerV.layer.frame.size.height){
//        self.headerV.layer.position = CGPointMake(self.headerV.layer.position.x, -self.headerV.layer.frame.size.height);
//        return;
//    }
//    if(top >= 0 && self.headerV.layer.position.y >= 0){
//        self.headerV.layer.position = CGPointMake(self.headerV.layer.position.x, 0.0);
//        return;
//    }
//    if(self.headerV.layer.position.y > 0){
//        self.headerV.layer.position = CGPointMake(self.headerV.layer.position.x, 0.0);
//    }else if(self.headerV.layer.position.y < -64){
//        self.headerV.layer.position = CGPointMake(self.headerV.layer.position.x, -self.headerV.layer.frame.size.height);
//    }else{
//        self.headerV.layer.position = CGPointMake(self.headerV.layer.position.x, self.headerV.layer.position.y + top);
//    }
//    scrollBefore = scrollView.contentOffset.y;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if(indexPath.section == 0){
        if(kind == UICollectionElementKindSectionHeader){
            HeaderCollectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
            NSString *title = [[NSString alloc]initWithFormat:@"%@", @"TOP"];
            headerView.headerLb.text = title;
            reusableview = headerView;
        }
        return reusableview;
    }
    if(kind == UICollectionElementKindSectionHeader){
        HeaderCollectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
         NSString *title = [[NSString alloc]initWithFormat:@"%@", [(Categories *)[self.listData objectAtIndex:indexPath.section] CategoryName]];
        headerView.headerLb.text = title;
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark <UICollectionViewDelegate>


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%li/%li",indexPath.section, indexPath.row);
    DetailController *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailController"];
    if(indexPath.section == 0){
        TopMovieCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        Movie *mov = [headerMovie objectAtIndex:cell.pageControl.currentPage];
        monitorMenuViewController.movieId = [mov MovieID];
    }else{
        Categories *cat = [self.listData objectAtIndex:indexPath.section];
        Movie *mov = [cat.Movies objectAtIndex:indexPath.row];
        monitorMenuViewController.movieId = [mov MovieID];
    }
    [self presentViewController:monitorMenuViewController animated:NO completion:nil];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.3;
    CGSize size = CGSizeMake(cellWidth, cellWidth * 16.0 / 10.0);
    if (indexPath.section == 0) {
        size = CGSizeMake(screenWidth, screenWidth * 9.0 / 16.0);
    }
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGSizeZero;
    }else{
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 50);
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
