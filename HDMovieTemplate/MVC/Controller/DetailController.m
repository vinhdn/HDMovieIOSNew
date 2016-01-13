//
//  DetailController.m
//  HDMovie
//
//  Created by iService on 1/7/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import "DetailController.h"
#import "ApiConnect.h"
#import "Define.h"
#import <QuartzCore/QuartzCore.h>
#import <STPopup/STPopup.h>
#import <AFHTTPSessionManager.h>
#import "PlayMovieVC.h"
#import "ListEpVC.h"
@interface DetailController() <EPSelectedListener>
@end
@implementation DetailController

-(void)viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (IBAction)play:(UIButton *)sender {
    PlayMovieVC *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayMovieVC"];
    monitorMenuViewController.movieId = [self movieId];
    monitorMenuViewController.ep = 1;
    [self presentViewController:monitorMenuViewController animated:YES completion:nil];
}
-(void)epSelected:(ListEpVC *)vc didSelectEP:(NSInteger)ep{
    PlayMovieVC *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayMovieVC"];
    monitorMenuViewController.movieId = [self movieId];
    monitorMenuViewController.ep = ep;
    [self presentViewController:monitorMenuViewController animated:YES completion:nil];
}
- (IBAction)showListEP:(id)sender {
    ListEpVC *listEpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListEpVC"];
    listEpVC.numberEP = self.movie.Sequence;
    listEpVC.delegate = self;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:listEpVC];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.bgThumbV.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.bgThumbV.layer setShadowOpacity:0.8];
    [self.bgThumbV.layer setShadowRadius:3.0];
    [self.bgThumbV.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.desLb sizeToFit];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 2000)];
    self.desLb.frame = CGRectMake(self.desLb.frame.origin.x, self.desLb.frame.origin.y, self.view.frame.size.width, self.desLb.frame.size.height);
    NSDictionary *parameters = @{@"sign": [AppDelegate appSign], @"movieId" : [self movieId]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendString: [AppDelegate appLink]];
    [url appendString:@"/"];
    [url appendString:VIDEO_DETAIL_URL];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON %@", responseObject);
                NSDictionary *dict = [responseObject valueForKeyPath:@"r"];
                if(dict == nil){
        
                }else{
                    self.movie = [[Movie alloc] initWithDictionary:dict error:nil];
                    if(self.movie != nil){
                        [self.thumbIV setImageWithURL:[NSURL URLWithString:[self.movie Backdrop]]];
                        [self.thumb02IV setImageWithURL:[NSURL URLWithString:[self.movie Poster100x149]]];
                        self.engLb.text = self.movie.MovieName;
                        self.titleLb.text = self.movie.MovieName;
                        self.viLB.text = self.movie.KnownAs;
                        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<div style='text-align:justify; font-size:16px;font-family:HelveticaNeue;color:#362932;'>%@</div>", self.movie.PlotVI] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        self.desLb.attributedText = attrStr;
                    }
                }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"ERROR %@", error);
    }];

}
- (IBAction)moreDetail:(UIButton *)sender {
    if(self.desLb.numberOfLines > 0){
        self.desLb.numberOfLines = 0;
        [self.moreBtn setTitle:@"ẨN" forState:UIControlStateNormal];
    }
    else{
        self.desLb.numberOfLines = 3;
        [self.moreBtn setTitle:@"XEM THÊM" forState:UIControlStateNormal];
    }
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    NSLog(@"%ld", fromInterfaceOrientation);
}
@end
