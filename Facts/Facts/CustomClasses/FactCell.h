//
//  FactCell.h
//  Facts
//
//  Created by Nitin Soni on 25/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kFactCellIdWithImage;
extern NSString *const kFactCellIdWithoutImage;
@class Fact;
@interface FactCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDescription;
@property (nonatomic, strong) UIImageView *imgFact;
@property (nonatomic, strong) NSLayoutConstraint *imgConstraintHeight;
- (void)configureCell:(Fact *)fact forIndexPath:(NSIndexPath *)indPath;
@end
