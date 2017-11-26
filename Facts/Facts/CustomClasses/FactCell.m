//
//  FactCell.m
//  Facts
//
//  Created by Nitin Soni on 25/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "FactCell.h"
#import "Fact.h"


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
        self.imgFact.contentMode = UIViewContentModeCenter;
        self.imgFact.clipsToBounds = YES;
        [self.imgFact setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:self.imgFact];
        
        //constraints
        NSLayoutConstraint *imgConstraintTop = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblDescription attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8];
        NSLayoutConstraint *imgConstraintBottom = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:6];
        NSLayoutConstraint *imgConstraintLeft = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *imgConstraintRight = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        if ([reuseIdentifier isEqualToString:@"factCell"]){
        self.imgConstraintHeight = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        }
        
        
        [self.imgFact.superview addConstraint:imgConstraintTop];
        [self.imgFact.superview addConstraint:imgConstraintBottom];
        [self.imgFact.superview addConstraint:imgConstraintLeft];
        [self.imgFact.superview addConstraint:imgConstraintRight];
        if ([reuseIdentifier isEqualToString:@"factCell"]){
            [self.imgFact addConstraint:self.imgConstraintHeight];
        }
        
    }
    return self;
}

- (void)configureCell:(Fact *)fact forIndexPath:(NSIndexPath *)indPath{
    [self.lblTitle setText:fact.title];
    [self.lblDescription setText:fact.internalBaseClassDescription];
    [self.imgFact setImage:nil];
    NSString *imgName = [fact.imageHref componentsSeparatedByString:@"/"].lastObject;
    UIImage *img = [self getImageWithName:imgName];
    if (img != nil){
        [self.imgFact setImage:img];
    }else{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^(void) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fact.imageHref]];
                             
                             UIImage* image = [[UIImage alloc] initWithData:imageData];
        NSString *imgName = [fact.imageHref componentsSeparatedByString:@"/"].lastObject;
        [self saveImageWithName:imgName Data:imageData];
                             if (image) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if (self.tag == indPath.row) {
                                         self.imgFact.image = image;
                                         
                                     }
                                 });
                             }
                             });
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)saveImageWithName: (NSString *)imgName Data: (NSData *)data{
    NSFileManager *fileManager = [[NSFileManager alloc] init];    NSString *ddPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imgFolderPath = [ddPath stringByAppendingString:@"/img"];
    NSString *imgPath = [imgFolderPath stringByAppendingPathComponent:imgName];
    [fileManager createFileAtPath:imgPath contents:data attributes:nil];
    
}

- (UIImage *)getImageWithName: (NSString *)imgName{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *ddPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imgFolderPath = [ddPath stringByAppendingString:@"/img"];
    if (![fileManager fileExistsAtPath:imgFolderPath]){
        [fileManager createDirectoryAtPath:imgFolderPath withIntermediateDirectories:false attributes:nil error:nil];
    }
    NSString *imgPath = [imgFolderPath stringByAppendingPathComponent:imgName];
    if ([fileManager fileExistsAtPath:imgPath]){
        NSData *imgData = [fileManager contentsAtPath:imgPath];
        return [UIImage imageWithData:imgData];
    }else{
        return nil;
        
    }
}

@end
