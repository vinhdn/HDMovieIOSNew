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
#import <AFHTTPSessionManager.h>
#import "PlayMovieVC.h"
@implementation DetailController

- (IBAction)play:(UIButton *)sender {
    PlayMovieVC *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayMovieVC"];
    [self presentViewController:monitorMenuViewController animated:NO completion:nil];
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
                        self.desLb.text = self.movie.PlotVI;
                    }
                }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"ERROR %@", error);
    }];

}
- (IBAction)moreDetail:(UIButton *)sender {
    if(self.desLb.numberOfLines > 0){
        self.desLb.numberOfLines = 0;
    }
    else{
        self.desLb.numberOfLines = 3;
    }
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
}

@end
