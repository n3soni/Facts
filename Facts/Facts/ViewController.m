//
//  ViewController.m
//  Facts
//
//  Created by LMS on 22/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "APIHandler.h"
#import "Fact.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tblFacts;
@property (strong, nonatomic) UILabel *lblHeaderTitle;
@property (nonatomic, strong) NSMutableArray *arrFacts;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUserInterface];
    self.arrFacts = [NSMutableArray array];
    [self fetchFacts];
}

- (void)configureUserInterface{
    //prepare header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    headerView.backgroundColor = [UIColor blueColor];
    self.lblHeaderTitle = [[UILabel alloc] init];
    self.lblHeaderTitle.text = @"Facts";
    self.lblHeaderTitle.font = [UIFont boldSystemFontOfSize:20];
    self.lblHeaderTitle.textColor = [UIColor whiteColor];
    [self.lblHeaderTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:self.lblHeaderTitle];
    NSLayoutConstraint *lblCenterX = [NSLayoutConstraint constraintWithItem:self.lblHeaderTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *lblCenterY = [NSLayoutConstraint constraintWithItem:self.lblHeaderTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [headerView addConstraint:lblCenterX];
    [headerView addConstraint:lblCenterY];
    [self.view addSubview:headerView];
    
    //prepare table and populate
    CGRect tblFrame = self.view.frame;
    tblFrame.origin.y = headerView.bounds.size.height;
    tblFrame.size.height -= headerView.bounds.size.height;
    self.tblFacts = [[UITableView alloc] initWithFrame:tblFrame style:UITableViewStylePlain];
    self.tblFacts.dataSource = self;
    self.tblFacts.delegate = self;
    [self.view addSubview:self.tblFacts];
}

- (void)fetchFacts{
    APIHandler *newAPIHandler = [[APIHandler alloc] init];
        [newAPIHandler executeRequest:requestFetchFacts Method:kMethodGet withCallback:^(NSDictionary *response, NSError *error) {
            NSLog(@"facts = %@",response);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblHeaderTitle.text = response[@"title"];
            });
            NSArray *rawFacts = response[@"rows"];
            for (NSDictionary *rawFact in rawFacts){
                Fact *fact = [[Fact alloc] initWithDictionary:rawFact];
                [self.arrFacts addObject:fact];
            }
            
                [self.tblFacts reloadData];
//                });
        }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"arr count = %d",self.arrFacts.count);
    return self.arrFacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"factCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    Fact *fact = self.arrFacts[indexPath.row];
    cell.textLabel.text = fact.title;
    
    cell.detailTextLabel.text = fact.internalBaseClassDescription;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


@end
