//
//  FactCell.m
//  Facts
//
//  Created by Nitin Soni on 25/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "FactCell.h"
#import "Fact.h"

NSString *const kFactCellIdWithImage = @"factCellWithImage";
NSString *const kFactCellIdWithoutImage = @"factCellWithoutImage";
@implementation FactCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        NSLayoutConstraint *lblTitleTop = [NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lblTitle.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:8];
        NSLayoutConstraint *lblTitleCenterX = [NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.lblTitle.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *lblTitleLeft = [NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblTitle.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:6];
        NSLayoutConstraint *lblTitleRight = [NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblTitle.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:6];
        [self.lblTitle.superview addConstraint:lblTitleTop];
        [self.lblTitle.superview addConstraint:lblTitleCenterX];
        [self.lblTitle.superview addConstraint:lblTitleLeft];
        [self.lblTitle.superview addConstraint:lblTitleRight];
        
        self.lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        self.lblDescription.numberOfLines = 0;
        self.lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblDescription.textAlignment = NSTextAlignmentCenter;
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = NO;
        [self.lblDescription setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:self.lblDescription];
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
        NSLayoutConstraint *imgConstraintTop = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblDescription attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8];
        NSLayoutConstraint *imgConstraintBottom = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:6];
        NSLayoutConstraint *imgConstraintLeft = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *imgConstraintRight = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.imgFact.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        if ([reuseIdentifier isEqualToString:kFactCellIdWithImage]){
            self.imgConstraintHeight = [NSLayoutConstraint constraintWithItem:self.imgFact attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
            [self.imgFact addConstraint:self.imgConstraintHeight];
        }
        [self.imgFact.superview addConstraint:imgConstraintTop];
        [self.imgFact.superview addConstraint:imgConstraintBottom];
        [self.imgFact.superview addConstraint:imgConstraintLeft];
        [self.imgFact.superview addConstraint:imgConstraintRight];
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
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *imgPath = [self imagePathWithName:imgName];
    [fileManager createFileAtPath:imgPath contents:data attributes:nil];
    fileManager = nil;
}

- (UIImage *)getImageWithName: (NSString *)imgName{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *imgPath = [self imagePathWithName:imgName];
    if ([fileManager fileExistsAtPath:imgPath]){
        NSData *imgData = [fileManager contentsAtPath:imgPath];
        return [UIImage imageWithData:imgData];
    }else{
        return nil;
    }
    fileManager = nil;
}

- (NSString *)imagePathWithName:(NSString *)imageName{
    NSString *ddPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imgFolderPath = [ddPath stringByAppendingString:@"/img"];
    return [imgFolderPath stringByAppendingPathComponent:imageName];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *subview in self.contentView.subviews){
        if ([subview isKindOfClass:[UILabel class]]){
            NSDictionary *attributes = @{NSFontAttributeName: ((UILabel *)subview).font};

            CGRect rect = [((UILabel *)subview).text boundingRectWithSize:CGSizeMake(self.contentView.superview.bounds.size.width, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributes
                                                      context:nil];
            CGRect newFrame = ((UILabel *)subview).frame;
            newFrame.size.height = rect.size.height;
            newFrame.origin.x = 6;
            ((UILabel *)subview).frame = newFrame;
        }
    }
}

@end
