//
//  APIHandler.h
//  Facts
//
//  Created by LMS on 23/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIHandler : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableData *responseData;
@property (copy) void(^completionBlock)(NSDictionary *, NSError*);
//+ (id)sharedHandler;
- (void)executeRequest: (NSString *)urlRequest withCallback:(void(^)(NSDictionary *, NSError *))callback;
@end
