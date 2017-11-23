//
//  Fact.m
//  Facts
//
//  Created by LMS on 23/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "Fact.h"


NSString *const kBaseClassTitle = @"title";
NSString *const kBaseClassDescription = @"description";
NSString *const kBaseClassImageHref = @"imageHref";


@interface Fact ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Fact

@synthesize title = _title;
@synthesize internalBaseClassDescription = _internalBaseClassDescription;
@synthesize imageHref = _imageHref;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.title = [self objectOrNilForKey:kBaseClassTitle fromDictionary:dict];
        self.internalBaseClassDescription = [self objectOrNilForKey:kBaseClassDescription fromDictionary:dict];
        self.imageHref = [self objectOrNilForKey:kBaseClassImageHref fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.title forKey:kBaseClassTitle];
    [mutableDict setValue:self.internalBaseClassDescription forKey:kBaseClassDescription];
    [mutableDict setValue:self.imageHref forKey:kBaseClassImageHref];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.title = [aDecoder decodeObjectForKey:kBaseClassTitle];
    self.internalBaseClassDescription = [aDecoder decodeObjectForKey:kBaseClassDescription];
    self.imageHref = [aDecoder decodeObjectForKey:kBaseClassImageHref];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_title forKey:kBaseClassTitle];
    [aCoder encodeObject:_internalBaseClassDescription forKey:kBaseClassDescription];
    [aCoder encodeObject:_imageHref forKey:kBaseClassImageHref];
}

- (id)copyWithZone:(NSZone *)zone {
    Fact *copy = [[Fact alloc] init];
    
    
    
    if (copy) {
        
        copy.title = [self.title copyWithZone:zone];
        copy.internalBaseClassDescription = [self.internalBaseClassDescription copyWithZone:zone];
        copy.imageHref = [self.imageHref copyWithZone:zone];
    }
    
    return copy;
}


@end
