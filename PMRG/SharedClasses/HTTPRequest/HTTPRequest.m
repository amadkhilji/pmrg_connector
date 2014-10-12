//
//  HTTPRequest.m
//  WaitlessPO
//
//  Created by Amad Khilji on 29/10/2013.
//  Copyright (c) 2013 Amad Khilji. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest ()

@property (atomic, weak) id<HTTPRequestDelegate> delegate;

-(void)requestGetWithMethod:(NSString*)methodName Params:(NSDictionary*)params andDelegate:(id<HTTPRequestDelegate>)requestDelegate;
-(void)requestPostWithMethod:(NSString*)methodName Params:(NSDictionary*)params andDelegate:(id<HTTPRequestDelegate>)requestDelegate;

@end

@implementation HTTPRequest

@synthesize requestType;

-(id)init {
    
    if (self = [super init]) {
        
        urlData = [[NSMutableData alloc] init];
        requestType = HTTPRequestTypeUNKNOWN;
    }
    
    return self;
}

#pragma mark
#pragma mark Static Methods

+(void)requestGetWithMethod:(NSString*)methodName Params:(NSDictionary*)params andDelegate:(id<HTTPRequestDelegate>)requestDelegate {
    
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request requestGetWithMethod:methodName Params:params andDelegate:requestDelegate];
}

+(void)requestPostWithMethod:(NSString*)methodName Params:(NSDictionary*)params andDelegate:(id<HTTPRequestDelegate>)requestDelegate {
    
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request requestPostWithMethod:methodName Params:params andDelegate:requestDelegate];
}

#pragma mark
#pragma mark Private Methods

-(void)requestGetWithMethod:(NSString*)methodName Params:(NSDictionary*)params andDelegate:(id<HTTPRequestDelegate>)requestDelegate {
    
    self.delegate = requestDelegate;
    [urlData setLength:0];
    
    NSMutableString *method = [NSMutableString stringWithString:@""];
    if (methodName) {
        [method appendString:methodName];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (params) {
        [parameters addEntriesFromDictionary:params];
    }
    if ([[parameters allValues] count] > 0) {
        [method appendString:@"?"];
        for (int i=0; i<[[parameters allValues] count]; i++) {
            if (i>0) {
                [method appendString:@"&"];
            }
            [method appendFormat:@"%@=%@", [[parameters allKeys] objectAtIndex:i], [[parameters allValues] objectAtIndex:i]];
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVER_URL, [method stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    request.timeoutInterval = TIMEOUT_INTERVAL;
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

-(void)requestPostWithMethod:(NSString*)methodName Params:(NSDictionary*)params andDelegate:(id<HTTPRequestDelegate>)requestDelegate {
    
    self.delegate = requestDelegate;
    [urlData setLength:0];
    
    NSMutableString *method = [NSMutableString stringWithString:@""];
    if (methodName) {
        [method appendString:methodName];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (params) {
        [parameters addEntriesFromDictionary:params];
    }
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVER_URL, [method stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/raw" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = TIMEOUT_INTERVAL;
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if (httpResponse.statusCode == 200) {// http OK status code
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didStartRequest:)]) {
            [self.delegate didStartRequest:self];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    id responseData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishRequest:withData:)]) {
        [self.delegate didFinishRequest:self withData:responseData];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailRequest:withError:)]) {
        [self.delegate didFailRequest:self withError:[error localizedDescription]];
    }
}

@end
