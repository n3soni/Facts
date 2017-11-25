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
#import "UIImageView+Addition.h"
#import "FactCell.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tblFacts;
@property (strong, nonatomic) UILabel *lblHeaderTitle;
@property (nonatomic, strong) NSMutableArray *arrFacts;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrFacts = [NSMutableArray array];
    [self fetchFacts];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self configureUserInterface];
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
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:headerView];
    //constrains for header
    NSLayoutConstraint *headerViewConstraintLeft = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headerView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *headerViewConstraintRight = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:headerView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *headerViewConstraintTop = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *headerViewConstraintHeight = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
    [headerView addConstraint:headerViewConstraintHeight];
    [headerView.superview addConstraint:headerViewConstraintLeft];
    [headerView.superview addConstraint:headerViewConstraintRight];
    [headerView.superview addConstraint:headerViewConstraintTop];
    
    //prepare table and populate
    CGRect tblFrame = self.view.frame;
    tblFrame.origin.y = headerView.bounds.size.height;
    tblFrame.size.height -= headerView.bounds.size.height;
    self.tblFacts = [[UITableView alloc] initWithFrame:tblFrame style:UITableViewStylePlain];
    self.tblFacts.dataSource = self;
    self.tblFacts.delegate = self;
    [self.view addSubview:self.tblFacts];
    self.tblFacts.translatesAutoresizingMaskIntoConstraints = NO;
    
    //constraints for tblFacts
    NSLayoutConstraint *tblFactsConstraintLeft = [NSLayoutConstraint constraintWithItem:self.tblFacts attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.tblFacts.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *tblFactsConstraintRight = [NSLayoutConstraint constraintWithItem:self.tblFacts attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.tblFacts.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *tblFactsConstraintTop = [NSLayoutConstraint constraintWithItem:self.tblFacts attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *tblFactsConstraintBottom = [NSLayoutConstraint constraintWithItem:self.tblFacts attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tblFacts.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.tblFacts.superview addConstraint:tblFactsConstraintTop];
    [self.tblFacts.superview addConstraint:tblFactsConstraintLeft];
    [self.tblFacts.superview addConstraint:tblFactsConstraintRight];
    [self.tblFacts.superview addConstraint:tblFactsConstraintBottom];
}

- (void)fetchFacts{
    APIHandler *newAPIHandler = [[APIHandler alloc] init];
        [newAPIHandler executeRequest:requestFetchFacts withCallback:^(NSDictionary *response, NSError *error) {
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
//            [self.tblFacts updateConstraints];
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
    return self.arrFacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"called for cell = %d", indexPath.row);
    static NSString *cellId = @"factCell";
    FactCell *cell = (FactCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[FactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    Fact *fact = self.arrFacts[indexPath.row];
    [cell configureCell:fact];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return UITableViewAutomaticDimension;
}



@end
