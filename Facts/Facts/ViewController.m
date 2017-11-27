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
#import "FactCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tblFacts;
@property (strong, nonatomic) UILabel *lblHeaderTitle;
@property (nonatomic, strong) NSMutableArray *arrFacts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrFacts = [NSMutableArray array];
}

- (void)addRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    if (@available(iOS 10.0, *)) {
        self.tblFacts.refreshControl = self.refreshControl;
    } else {
        [self.tblFacts addSubview:self.refreshControl];
    }
    UIColor *refreshContentsColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    [self.refreshControl setTintColor:refreshContentsColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:refreshContentsColor forKey:NSForegroundColorAttributeName];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Fetching Facts..." attributes:attributes]];
    [self.refreshControl addTarget:self action:@selector(fetchFacts) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self configureUserInterface];
    [self addRefreshControl];
    [self fetchFacts];
}

- (void)configureUserInterface{
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
    NSLayoutConstraint *headerViewConstraintLeft = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headerView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *headerViewConstraintRight = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:headerView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *headerViewConstraintTop = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *headerViewConstraintHeight = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
    [headerView addConstraint:headerViewConstraintHeight];
    [headerView.superview addConstraint:headerViewConstraintLeft];
    [headerView.superview addConstraint:headerViewConstraintRight];
    [headerView.superview addConstraint:headerViewConstraintTop];
    CGRect tblFrame = self.view.frame;
    tblFrame.origin.y = headerView.bounds.size.height;
    tblFrame.size.height -= headerView.bounds.size.height;
    self.tblFacts = [[UITableView alloc] initWithFrame:tblFrame style:UITableViewStylePlain];
    self.tblFacts.dataSource = self;
    self.tblFacts.delegate = self;
    [self.tblFacts setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tblFacts];
    self.tblFacts.translatesAutoresizingMaskIntoConstraints = NO;
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
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblHeaderTitle.text = response[@"title"];
            });
            [self.arrFacts removeAllObjects];
            NSArray *rawFacts = response[@"rows"];
            for (NSDictionary *rawFact in rawFacts){
                Fact *fact = [[Fact alloc] initWithDictionary:rawFact];
                [self.arrFacts addObject:fact];
            }
            [self.tblFacts reloadData];
            [self.refreshControl endRefreshing];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableview delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrFacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Fact *fact = self.arrFacts[indexPath.row];
    static NSString *cellId = @"";
    if (fact.imageHref == (NSString *)[NSNull null] || [fact.imageHref isEqualToString:@"null"] || fact.imageHref == nil){
        cellId = kFactCellIdWithoutImage;
    }else{
        cellId = kFactCellIdWithImage;
    }
    FactCell *cell = (FactCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[FactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = indexPath.row;
    [cell configureCell:fact forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return UITableViewAutomaticDimension;
}
@end
