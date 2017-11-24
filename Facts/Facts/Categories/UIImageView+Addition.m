//
//  UIImageView+Addition.m
//  Facts
//
//  Created by Nitin Soni on 24/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "UIImageView+Addition.h"

@implementation UIImageView (Addition)
- (void)getImageFromUrl: (NSString *)imgUrl Callback:(void (^)(void))callback{
//    NSLog(@"started for %@", imgUrl);
    NSString *imgName = [imgUrl componentsSeparatedByString:@"/"].lastObject;
    UIImage *img = [self getImageWithName:imgName];
    if (img != nil){
        self.image = img;
        callback();
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            NSLog(@"processing for %@", imgUrl);
            [self saveImageWithName:imgName Data:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = [UIImage imageWithData:data];
                callback();
            });
            
        });
    }
}

- (void)saveImageWithName: (NSString *)imgName Data: (NSData *)data{
    NSFileManager *fileManager = [[NSFileManager alloc] init];    NSString *ddPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imgFolderPath = [ddPath stringByAppendingString:@"/img"];
    NSString *imgPath = [imgFolderPath stringByAppendingPathComponent:imgName];
    [fileManager createFileAtPath:imgPath contents:data attributes:nil];
    
    NSLog(@"image saved with name %@",imgName);
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
        NSLog(@"image got with name %@",imgName);
    }else{
        return nil;
        
    }
}
@end
