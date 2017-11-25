//
//  FactCell.m
//  Facts
//
//  Created by Nitin Soni on 25/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "FactCell.h"
#import "Fact.h"
#import "UIImageView+Addition.h"

@implementation FactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.lblTitle.numberOfLines = 0;
        self.lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self.lblTitle setFont:[UIFont boldSystemFontOfSize:18]];
        [self.contentView addSubview:self.lblTitle];
        //constrains
        NSLayoutConstraint *lblTitleTop = [NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lblTitle.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:8];
        NSLayoutConstraint *lblTitleCenterX = [NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.lblTitle.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self.lblTitle.superview addConstraint:lblTitleTop];
        [self.lblTitle.superview addConstraint:lblTitleCenterX];
        
        self.lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        self.lblDescription.numberOfLines = 0;
        self.lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblDescription.textAlignment = NSTextAlignmentCenter;
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = NO;
        [self.lblDescription setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:self.lblDescription];
        //constrains
        NSLayoutConstraint *lblDescriptionTop = [NSLayoutConstraint constraintWithItem:self.lblDescription attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lblTitle attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8];
        NSLayoutConstraint *lblDescriptionCenterX = [NSLayoutConstraint constraintWithItem:self.lblDescription attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.lblDescription.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *lblDescriptionLeft = [NSLayoutConstraint constraintWithItem:self.lblDescription attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblDescription.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:6];
        NSLayoutConstraint *lblDescriptionRight = [NSLayoutConstraint constraintWithItem:self.lblDescription attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblDescription.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:6];
        [self.lblDescription.superview addConstraint:lblDescriptionTop];
        [self.lblDescription.superview addConstraint:lblDescriptionCenterX];
        [self.lblDescription.superview addConstraint:lblDescriptionLeft];
        [self.lblDescription.superview addConstraint:lblDescriptionRight];
        
        self.imgFact = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 200)];
        self.imgFact.translatesAutoresizingMaskIntoConstraints = NO;
        self.imgFact.contentMode = UIViewContentModeScaleAspectFit;
        [self.imgFact setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:self.imgFact];
        
        //constraints
        NSLayoutConstraint *imgConstraintTop = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblDescription attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8];
        NSLayoutConstraint *imgConstraintBottom = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:6];
        NSLayoutConstraint *imgConstraintLeft = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *imgConstraintRight = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        
        [self.imgFact.superview addConstraint:imgConstraintTop];
        [self.imgFact.superview addConstraint:imgConstraintBottom];
        [self.imgFact.superview addConstraint:imgConstraintLeft];
        [self.imgFact.superview addConstraint:imgConstraintRight];
        
    }
    return self;
}

- (void)configureCell:(Fact *)fact{
    [self.lblTitle setText:fact.title];
    [self.lblDescription setText:fact.internalBaseClassDescription];
    [self.imgFact setImage:nil];
    if (fact.imageHref){
        self.imgConstraintHeight.constant = 200;
        [self layoutIfNeeded];
    [self.imgFact getImageFromUrl:fact.imageHref Callback:^(CGSize imgSize) {
        
    }];
    }else{
        self.imgConstraintHeight.constant = 0;
        [self layoutIfNeeded];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
