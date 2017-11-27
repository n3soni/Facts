//
//  FactsTests.m
//  FactsTests
//
//  Created by LMS on 22/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIImageView+Addition.h"

@interface FactsTests : XCTestCase
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation FactsTests

- (void)setUp {
    [super setUp];
    self.imgView = [[UIImageView alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        NSString *imgUrl = @"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg";
        [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    }];
}

- (void)testImageLoadInASecond{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Long method"];
    [self.imgView setImageFromUrl:@"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg" Callback:^(CGSize imgSize) {
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:^(NSError * _Nullable error) {
    }];
}

@end
