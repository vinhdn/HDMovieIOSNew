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
#import "Sub.h"

@implementation PlayMovieVC
{
    MPMoviePlayerController *mp;
    MovePlay* movie;
    NSMutableArray* listSub;
    NSTimer *subtitleTimer;
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
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                         name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                       object:nil];
            mp.view.frame = self.view.bounds;
            
            // save the movie player object
            [mp setFullscreen:NO];
            [self.progressV setValue:0];
            // Play the
            //        [self presentMoviePlayerViewControllerAnimated:mp];
            [mp play];
            mp.controlStyle = MPMovieControlStyleNone;
            listSub = [NSMutableArray new];
            [self.parentPlayerV addSubview:mp.view];
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
            [mp.view addGestureRecognizer:singleFingerTap];
            [self.topV addGestureRecognizer:singleFingerTap];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(movie.SubtitleExt.VIE != nil){
                    movie.SubtitleExt.VIE.Content = [ApiConnect getSu:movie.SubtitleExt.VIE.Source params:nil];
                }
                if(movie.SubtitleExt.ENG != nil){
                    movie.SubtitleExt.ENG.Content = [ApiConnect getSu:movie.SubtitleExt.ENG.Source params:nil];
                }
                if(movie.SubtitleExt.CHT != nil){
                    movie.SubtitleExt.CHT.Content = [ApiConnect getSu:movie.SubtitleExt.CHT.Source params:nil];
                }
                NSString *sub = movie.SubtitleExt.VIE.Content;
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

- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    if (mp.playbackState == MPMoviePlaybackStatePlaying)
    { //playing
        UIImage *btnImage = [UIImage imageNamed:@"ic_pause_yellow.png"];
        [self.playBtn setImage:btnImage forState:UIControlStateNormal];
        subtitleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                              target:self
                                                            selector:@selector(playTime)
                                                            userInfo:nil
                                                             repeats:YES];
        
    }
    if (mp.playbackState == MPMoviePlaybackStateStopped)
    { //stopped
        if(subtitleTimer.isValid){
            [subtitleTimer invalidate];
        }
        [self.progressV setValue:0];
        UIImage *btnImage = [UIImage imageNamed:@"ic_play_blue.png"];
        [self.playBtn setImage:btnImage forState:UIControlStateNormal];
        self.headerV.hidden = NO;
        self.controlV.hidden = NO;
    }if (mp.playbackState == MPMoviePlaybackStatePaused)
    { //paused
        UIImage *btnImage = [UIImage imageNamed:@"ic_play_blue.png"];
        [self.playBtn setImage:btnImage forState:UIControlStateNormal];
        self.headerV.hidden = NO;
        self.controlV.hidden = NO;
    }if (mp.playbackState == MPMoviePlaybackStateInterrupted)
    { //interrupted
        UIImage *btnImage = [UIImage imageNamed:@"ic_play_blue.png"];
        [self.playBtn setImage:btnImage forState:UIControlStateNormal];
    }if (mp.playbackState == MPMoviePlaybackStateSeekingForward)
    { //seeking forward
    }if (mp.playbackState == MPMoviePlaybackStateSeekingBackward)
    { //seeking backward
    }
    
}
-(void) playTime{
    [self.progressV setValue:mp.currentPlaybackTime/mp.duration animated:YES];
}
//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if(mp.playbackState != MPMoviePlaybackStatePlaying){
        
        return;
    }
    if(self.headerV.hidden){
        self.headerV.hidden = NO;
        self.controlV.hidden = NO;
        NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hiddenView) userInfo:nil repeats:NO];
    }
    else{
        self.headerV.hidden = YES;
        self.controlV.hidden = YES;
    }
    //Do stuff here...
}

- (IBAction)pauseOrPlay:(UIButton*)sender {
    if(mp == nil) return;
    if (mp.playbackState == MPMoviePlaybackStatePlaying) {
        [mp pause];
        UIImage *btnImage = [UIImage imageNamed:@"ic_play_blue.png"];
        [sender setImage:btnImage forState:UIControlStateNormal];
    }else{
        [mp play];
        UIImage *btnImage = [UIImage imageNamed:@"ic_pause_yellow.png"];
        [sender setImage:btnImage forState:UIControlStateNormal];
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)progressChanged:(UISlider*)sender {
    NSLog(@"slider value = %f", sender.value);
    mp.currentPlaybackTime = sender.value * mp.duration;
}

-(void)hiddenView{
    self.headerV.hidden = YES;
    self.controlV.hidden = YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft; // or Right of course
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end
