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
@import Foundation;
@interface CollectionViewController ()
@property (readwrite, nonatomic, strong) NSArray *posts;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:LINK_CONFIG parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *llba = [responseObject valueForKeyPath:@"link"];
        [AppDelegate setLink:llba];
        [AppDelegate setSign:[responseObject valueForKeyPath:@"sign"]];
        NSDictionary *parameters = @{@"sign": [AppDelegate appSign]};
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict= [ApiConnect sendRequest:HOMEPAGE method:@"GET" params:parameters];
            NSMutableArray *newData =  [[NSMutableArray alloc] init];
            if(dict == nil){
                
            }else{
                NSDictionary *rr = [dict valueForKeyPath:@"r"];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return [self.listData count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [[(Categories *)[self.listData objectAtIndex:section] Movies] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Categories *cat = [self.listData objectAtIndex:indexPath.section];
    Movie *mov = [cat.Movies objectAtIndex:indexPath.row];
    cell.nameLb.text = [mov MovieName];
    [cell.thumbIV setImageWithURL:[NSURL URLWithString:[mov Poster100x149]]];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
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
    Categories *cat = [self.listData objectAtIndex:indexPath.section];
    Movie *mov = [cat.Movies objectAtIndex:indexPath.row];
    monitorMenuViewController.movieId = [mov MovieID];
    [self presentViewController:monitorMenuViewController animated:NO completion:nil];
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortraitUpsideDown; // or Right of course
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
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
