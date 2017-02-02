//
//  SelectionQualityVC.m
//  HDMovieTemplate
//
//  Created by iService on 1/11/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import "SelectionQualityVC.h"
#import "SelectionCell.h"
#import <STPopup/STPopup.h>

static NSString * const reuseIdentifier = @"SelectionCell";
@implementation SelectionQualityVC{
    NSInteger num;
}
-(void)viewDidLoad{
    if(self.currentSub > 2 || self.currentSub < 0){
        self.currentSub = 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    num = 0;
    if(self.sub != nil){
        if(self.sub.VIE.Content != nil){
            num ++;
        }
        if(self.sub.ENG.Content != nil){
            num ++;
        }
        if(self.sub.CHT.Content != nil){
            num ++;
        }
    }
    return num + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(indexPath.row == num){
        cell.titleLb.text = @"Tắt/OFF";
        if (self.currentSub < 0){
            cell.selectBtn.hidden = NO;
        }else{
            cell.selectBtn.hidden = YES;
        }
        return cell;
    }
    if(indexPath.row == self.currentSub){
        cell.selectBtn.hidden = NO;
    }else{
        cell.selectBtn.hidden = YES;
    }
    // Configure the cell
    if(indexPath.row == 0){
        cell.titleLb.text = @"Tiếng Việt";
    }
    if(indexPath.row == 1){
        cell.titleLb.text = @"English";
    }
    if(indexPath.row == 2){
        cell.titleLb.text = @"Chinese";
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == num) {
        self.currentSub = -1;
        [tableView reloadData];
    }
    if(indexPath.row != self.currentSub){
        self.currentSub = indexPath.row;
        [tableView reloadData];
    }
}
- (IBAction)done:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(selectionQualityVC:didFinishWithSelections:)]) {
        [self.delegate selectionQualityVC:self didFinishWithSelections:self.currentSub];
    }
    [self.popupController popViewControllerAnimated:YES];

}
@end
