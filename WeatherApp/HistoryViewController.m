//
//  HistoryViewController.m
//  WeatherApp
//
//  Created by Potter on 11/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryDataController.h"
#import "HeaderConstants.h"

@interface HistoryViewController ()

//UI Components
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

//Data controller
@property (nonatomic,retain) HistoryDataController *dataCtrl;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_dataCtrl)
    {
        _dataCtrl = [[HistoryDataController alloc] init];
    }
    
    //Remove unwanted cells
    _historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataCtrl.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCellIdentifier"];
    
    NSString *cityNAme = [_dataCtrl.historyArray objectAtIndex:indexPath.row];
    [cell setupHistoryCellWithCityName:cityNAme];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - Button Action

- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
