//
//  PlayMovieVC.m
//  HDMovieTemplate
//
//  Created by iService on 1/9/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "PlayMovieVC.h"
#import "ApiConnect.h"
@import  MediaPlayer;

@implementation PlayMovieVC
{
    MPMoviePlayerController *mp;
}
-(void)viewDidLoad{
    
    [ApiConnect getVideoPlay:@"1148" success:^(NSURLSessionDataTask * dd, id _Nullable response) {
        NSLog(@"JSON %@", response);
    } failure:^(NSURLSessionDataTask * _Nullable ee, NSError * error) {
        NSLog(@"ERROR %@", error);
    }];
    
    NSURL *movieURL = [NSURL URLWithString:@"http://plist.vn-hd.com/mp4v3/9c961ce97563121eaebf0f2a0b98142c/fa13e64f97dc41beb41d3835f90a1f9d/00000000000000000000000000000000/1148_320_480_ifpt.smil/playlist.m3u8"];
    mp = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    if (mp)
    {
        mp.view.frame = self.view.bounds;
        
        // save the movie player object
        [mp setFullscreen:YES];
    
        // Play the
//        [self presentMoviePlayerViewControllerAnimated:mp];
        [mp play];
        [self.view addSubview:mp.view];
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft; // or Right of course
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
