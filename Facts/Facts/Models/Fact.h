//
//  Fact.h
//  Facts
//
//  Created by LMS on 23/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fact : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *internalBaseClassDescription;
@property (nonatomic, strong) NSString *imageHref;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
