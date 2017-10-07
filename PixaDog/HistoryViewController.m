//
//  HistoryViewController.m
//  PixaDog
//
//  Created by Ali Mir on 10/6/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController


#pragma mark - Lifecycles

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // display saved dogIDs
    NSArray *savedDogIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedDogIDs"];
    self.savedDogIDs = savedDogIDs;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"historyCell"];
}

#pragma mark - TableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    NSString *savedDogID = self.savedDogIDs[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"dog-%@", savedDogID];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedDogIDs.count;
}

- (IBAction)onTapButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
