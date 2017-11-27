//
//  UIImageView+Addition.h
//  Facts
//
//  Created by Nitin Soni on 24/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Addition)
- (void)setImageFromUrl: (NSString *)imgUrl Callback:(void (^)(CGSize))callback;
@end

