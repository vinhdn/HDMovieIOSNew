//
//  SelectSubQC.m
//  HDMovieTemplate
//
//  Created by iService on 1/11/16.
//  Copyright © 2016 Vinhdn. All rights reserved.
//

#import "SelectSubQC.h"
#import <STPopup/STPopup.h>
#import "SelectionSubCell.h"

static NSString * const reuseIdentifier = @"SelectionSubCell";
@implementation SelectSubQC
-(void)viewDidLoad{
    if(self.currentQuality < 0){
        self.currentQuality = 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.resolution count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectionSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionSubCell"];
    
    // Configure the cell
    Resolution *re = [self.resolution objectAtIndex:indexPath.row];
    cell.titleLb.text = re.name;
    if(indexPath.row == self.currentQuality){
        cell.selectBtn.hidden = NO;
    }else{
        cell.selectBtn.hidden = YES;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != self.currentQuality){
        self.currentQuality = indexPath.row;
        [tableView reloadData];
    }
}
- (IBAction)done:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(qualitySelectedVC:didFinishWithSelections:)]) {
        [self.delegate qualitySelectedVC:self didFinishWithSelections:self.currentQuality];
    }
    [self.popupController popViewControllerAnimated:YES];
}
@end
