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
#import "Utils.h"
#import "Resolution.h"
#import <STPopup/STPopup.h>
#import "SelectionQualityVC.h"
#import "SelectSubQC.h"
@interface PlayMovieVC() <SelectionQualityVCDelegate, QualitySelectionListener>
@end
@implementation PlayMovieVC
{
    MPMoviePlayerController *mp;
    MovePlay* movie;
    NSMutableArray* listSub;
    NSTimer *subtitleTimer;
    NSTimeInterval currentTime;
    NSInteger mCurrentSub;
    NSInteger mCurrentQuality;
    NSTimeInterval beforTime;
}
-(void)qualitySelectedVC:(SelectSubQC *)vc didFinishWithSelections:(NSInteger)selection{
    if(selection == mCurrentQuality){
        return;
    }
    beforTime = mp.currentPlaybackTime;
    mCurrentQuality = selection;
    if([movie.listResolution count] > 0){
        Resolution *res = ([movie.listResolution objectAtIndex:mCurrentQuality]);
        movie.LinkPlay = [res.url stringByReplacingOccurrencesOfString:@"\n" withString:@""];;
    }
    NSURL *movieURL = [NSURL URLWithString:[movie LinkPlay]];
    [mp setContentURL:movieURL];
    if(mp != nil){
        [mp play];
        mp.currentPlaybackTime = beforTime;
    }
}
-(void)selectionQualityVC:(SelectionQualityVC *)vc didFinishWithSelections:(NSInteger)selections{
    if(mp == nil) return;
    if(selections == mCurrentSub) return;
    if(selections < 0){
        mCurrentSub = -1;
        [mp hideSubtitles];
        return;
    }
    if(selections == 2){
        NSString *sub = movie.SubtitleExt.CHT.Content;
        if(sub != nil){
            [mp openWithSRTString:sub completion:^(BOOL finished) {
                [mp showSubtitles];
                mCurrentSub = 2;
            } failure:^(NSError *error) {
                NSLog(@"CHT ERror: %@", error);
            }];
        }else{
            NSLog(@"Sub CHT NIL");
        }
    }else if(selections == 1){
        NSString *sub = movie.SubtitleExt.ENG.Content;
        if(sub != nil){
            [mp openWithSRTString:sub completion:^(BOOL finished) {
                [mp showSubtitles];
                mCurrentSub = 1;
            } failure:^(NSError *error) {
                NSLog(@"ENG ERror: %@", error);
            }];
        }else{
            NSLog(@"Sub ENG NIL");
        }
    }else{
        NSString *sub = movie.SubtitleExt.VIE.Content;
        if(sub != nil){
            [mp openWithSRTString:sub completion:^(BOOL finished) {
                [mp showSubtitles];
                mCurrentSub = 0;
            } failure:^(NSError *error) {
                NSLog(@"VIE ERror: %@", error);
            }];
        }else{
            NSLog(@"Sub VIE NIL");
        }
    }
}
-(void)viewDidLoad{
    mCurrentSub = 0;
    [ApiConnect getVideoPlay:[self movieId] success:^(NSURLSessionDataTask * dd, id _Nullable response) {
        NSLog(@"JSON %@", response);
        NSDictionary* data = [response valueForKeyPath:@"r"];
        movie = [[MovePlay alloc] initWithDictionary:data error:nil];
        if (movie == nil) {
            return;
        }
        self.nameLb.text = [movie MovieName];
        NSString *linkPlay = movie.LinkPlay;
        NSString *place = [NSString stringWithFormat:@"%@_(.*)\\d{3,4}_\\d{3,4}", self.movieId];
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:place options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *matches = [regex matchesInString:linkPlay
                                            options:0
                                              range:NSMakeRange(0, [linkPlay length])];
        NSString *replace = @"%@_320_2000";
        for (int i = 0; i < [matches count]; i++) {
            NSTextCheckingResult *match = [matches objectAtIndex:i];
            NSRange matchRange = [match range];
            NSInteger numRange = [match numberOfRanges];
            if(numRange > 1){
                NSRange firstHalfRange = [match rangeAtIndex:1];
                NSString *resu03 = @"";
                resu03 = [linkPlay substringWithRange:firstHalfRange];
                NSLog(@"%@", resu03);
                replace = [NSString stringWithFormat:@"%s_%@320_2000", "%@",resu03];
            }
            
        }
        NSString *modifiedString = [regex stringByReplacingMatchesInString:linkPlay options:0 range:NSMakeRange(0, [linkPlay length]) withTemplate:[NSString stringWithFormat:replace, self.movieId]];
        NSLog(@"Modified String %@", modifiedString);
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:modifiedString
                                                            options:0
                                                              range:NSMakeRange(0, [modifiedString length])];
        if(numberOfMatches > 0){
            movie.LinkPlay = modifiedString;
        }
        NSString *placeRe = @"#EXT-X-STREAM-INF:.*BANDWIDTH=(\\d+).*RESOLUTION=([\\dx]+).*x([\\dx]+).*";
        NSString *resulotion = [ApiConnect getQuality:modifiedString];
        movie.listResolution = [[NSMutableArray alloc] init];
        if (resulotion != nil) {
            NSRegularExpression *regex02 = [NSRegularExpression regularExpressionWithPattern:placeRe options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *matches = [regex02 matchesInString:resulotion
                                              options:0
                                                range:NSMakeRange(0, [resulotion length])];
            for (int i = ([matches count] - 1); i >= 0; i--) {
                NSTextCheckingResult *match = [matches objectAtIndex:i];
                NSRange matchRange = [match range];
                NSString *resu = [resulotion substringWithRange:matchRange];
                NSRange firstHalfRange = [match rangeAtIndex:1];
                NSRange secondHalfRange = [match rangeAtIndex:3];
                NSString *resu02 = @"";
                if(i < [matches count] - 1){
                    NSTextCheckingResult *match02 = [matches objectAtIndex:i + 1];
                    NSRange matchRange02 = [match02 range];
                    resu02 = [resulotion substringWithRange:NSMakeRange(matchRange.location + matchRange.length, matchRange02.location - matchRange.length - matchRange.location)];
                }else{
                    resu02 = [resulotion substringWithRange:NSMakeRange(matchRange.location + matchRange.length, resulotion.length- matchRange.length - matchRange.location)];
                }
                NSLog(@"%@", resu02);
                Resolution *res = [[Resolution alloc] init];
                res.url = resu02;
                res.name = [resulotion substringWithRange:secondHalfRange];
                res.bandwidth = [resulotion substringWithRange:firstHalfRange];
                [movie.listResolution addObject:res];
            }
        }else{
            return;
        }
        if([movie.listResolution count] > 0){
            Resolution *res = ([movie.listResolution objectAtIndex:0]);
            movie.LinkPlay = [res.url stringByReplacingOccurrencesOfString:@"\n" withString:@""];;
            mCurrentQuality = 0;
        }
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
            self.currentTimeLb.text = [Utils timeToString:0];
            self.durationLb.text = [Utils timeToString:mp.duration];
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
    self.currentTimeLb.text = [Utils timeToString:mp.currentPlaybackTime];
    self.durationLb.text = [Utils timeToString:mp.duration];
    currentTime = mp.currentPlaybackTime;
}
//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if(mp.playbackState != MPMoviePlaybackStatePlaying){
        self.headerV.hidden = NO;
        self.controlV.hidden = NO;
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
    mp = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)progressChanged:(UISlider*)sender {
    NSLog(@"slider value = %f", sender.value);
    self.currentTimeLb.text = [Utils timeToString:sender.value * mp.duration];
    mp.currentPlaybackTime = sender.value * mp.duration;
}

- (IBAction)selectCC:(UIButton *)sender {
    SelectionQualityVC *selectionQVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BottomSheetDemoViewController"];
    selectionQVC.sub = movie.SubtitleExt;
    selectionQVC.currentSub = mCurrentSub;
    selectionQVC.delegate = self;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:selectionQVC];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

- (IBAction)selectQuality:(UIButton *)sender {
    SelectSubQC *selectionQVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectQualityViewController"];
    selectionQVC.resolution = movie.listResolution;
    selectionQVC.currentQuality = mCurrentQuality;
    selectionQVC.delegate = self;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:selectionQVC];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
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
