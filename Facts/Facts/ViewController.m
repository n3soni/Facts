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


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tblFacts;
@property (strong, nonatomic) UILabel *lblHeaderTitle;
@property (nonatomic, strong) NSMutableArray *arrFacts;
@property (nonatomic, strong) NSMutableArray *arrHeights;
@property (nonatomic, assign) int heightChangedForIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrFacts = [NSMutableArray array];
    self.heightChangedForIndex = -1;
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
//    NSLayoutConstraint *headerViewConstraintLeft = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//    NSLayoutConstraint *headerViewConstraintRight = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//    NSLayoutConstraint *headerViewConstraintTop = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    NSLayoutConstraint *headerViewConstraintHeight = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
//    [headerView addConstraint:headerViewConstraintHeight];
    [self.view addSubview:headerView];
//    [headerView addConstraint:headerViewConstraintLeft];
//    [headerView addConstraint:headerViewConstraintRight];
//    [self.view addConstraint:headerViewConstraintTop];
    
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
    return self.arrFacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"called for cell = %d", indexPath.row);
    static NSString *cellId = @"factCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UILabel *lblTitle = [[UILabel alloc] init];
        lblTitle.numberOfLines = 0;
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView addSubview:lblTitle];
        
    }
    Fact *fact = self.arrFacts[indexPath.row];
    cell.textLabel.text = fact.title;
    cell.imageView.image = nil;
    cell.detailTextLabel.text = fact.internalBaseClassDescription;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fact.imageHref]];
//        if (imgData != nil){
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            cell.imageView.image = [UIImage imageWithData:imgData];
//            [tableView beginUpdates];
//            [tableView endUpdates];
//        });
//        }
//    });
    if (fact.imageHref != nil){
        [cell.imageView getImageFromUrl:fact.imageHref Callback:^{
            if ([[self.tblFacts visibleCells] containsObject:cell]){
//                self.heightChangedForIndex = indexPath.row;
//            [self.tblFacts reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tblFacts beginUpdates];
                [self.tblFacts reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];

                [self.tblFacts endUpdates];
            }
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.arrHeights[indexPath.row] == 0 || self.heightChangedForIndex == indexPath.row){
//        NSNumber *num = [NSNumber numberWithFloat:UITableViewAutomaticDimension];
//        [self.arrHeights replaceObjectAtIndex:indexPath.row withObject:num];
        return UITableViewAutomaticDimension;
//    }
//    return [self.arrHeights[indexPath.row] floatValue];
}



@end
