//
//  PlayMovieVC.m
//  HDMovieTemplate
//
//  Created by iService on 1/9/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "PlayMovieVC.h"
#import "ApiConnect.h"
#import  "MPMoviePlayerController+Subtitles.h"

@implementation PlayMovieVC
{
    MPMoviePlayerController *mp;
    MovePlay* movie;
}
-(void)viewDidLoad{
    
    [ApiConnect getVideoPlay:[self movieId] success:^(NSURLSessionDataTask * dd, id _Nullable response) {
        NSLog(@"JSON %@", response);
        NSDictionary* data = [response valueForKeyPath:@"r"];
        movie = [[MovePlay alloc] initWithDictionary:data error:nil];
        if (movie == nil) {
            return;
        }
        self.nameLb.text = [movie MovieName];
        NSURL *movieURL = [NSURL URLWithString:[movie LinkPlay]];
        mp = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        
        if (mp)
        {
            mp.view.frame = self.view.bounds;
            
            // save the movie player object
            [mp setFullscreen:NO];
            
            // Play the
            //        [self presentMoviePlayerViewControllerAnimated:mp];
            [mp play];
            
            [self.parentPlayerV addSubview:mp.view];
            for (NSDictionary *subD in movie.SubtitleExt) {
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString* sub = [ApiConnect getSu:@"http://s.vn-hd.com:8080/store6/01032013/Hancock_2008_2in1_1080p_BluRay_DTS_x264_CtrlHD/Hancock_2008_2in1_1080p_BluRay_DTS_x264_CtrlHD_ENG.srt" params:nil];
                if(sub != nil){
                    [mp openWithSRTString:sub completion:^(BOOL finished) {
                        [mp showSubtitles];
                    } failure:^(NSError *error) {
                        NSLog(@"ERror: %@", error);
                    }];
                }else{
                    NSLog(@"Sub NIL");
                }
                });
        }

    } failure:^(NSURLSessionDataTask * _Nullable ee, NSError * error) {
        NSLog(@"ERROR %@", error);
    }];
    
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
