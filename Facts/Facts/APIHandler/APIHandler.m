//
//  APIHandler.m
//  Facts
//
//  Created by LMS on 23/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import "APIHandler.h"

@implementation APIHandler


- (void)executeRequest: (NSString *)urlRequest withCallback:(void(^)(NSDictionary *, NSError *))callback{
    self.completionBlock = callback;
        NSURL *url = [NSURL URLWithString:urlRequest];
    self.responseData = [NSMutableData data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    connection = nil;
}

#pragma mark URLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *err = nil;
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSISOLatin1StringEncoding];
    
    NSData *processedData = nil;
    if (responseString){
        processedData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        processedData = self.responseData;
    }
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:processedData options:NSJSONReadingAllowFragments error:&err];
    
    self.completionBlock(response, nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.completionBlock(nil, error);
}
@end
