//
//  UIImageView+Addition.m
//  Facts
//
//  Created by Nitin Soni on 24/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "UIImageView+Addition.h"

@implementation UIImageView (Addition)
- (void)setImageFromUrl: (NSString *)imgUrl Callback:(void (^)(CGSize))callback{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = [UIImage imageWithData:data];
                callback(self.image.size);
            });
        });
}
@end
