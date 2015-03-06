// Copyright (c) 2014-2015 Martijn Walraven
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "METDDPClient+AccountsPassword.h"

#import "NSString+METAdditions.h"

@implementation METDDPClient (AccountsPassword)

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completionHandler:(METLogInCompletionHandler)completionHandler {
  [self loginWithMethodName:@"login" parameters:@[@{@"user": @{@"email": email}, @"password": @{@"digest": [password SHA256String], @"algorithm": @"sha-256"}}] completionHandler:^(id result, NSError *error) {
    if (completionHandler) {
      completionHandler(error);
    }
  }];
}

- (void)signUpWithEmail:(NSString *)email password:(NSString *)password completionHandler:(METLogInCompletionHandler)completionHandler {
  [self loginWithMethodName:@"createUser" parameters:@[[self createUserParametersObjectWithEmail:email password:password]] completionHandler:^(id result, NSError *error) {
    if (completionHandler) {
      completionHandler(error);
    }
  }];
}

- (void)signUpWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName completionHandler:(METLogInCompletionHandler)completionHandler {
  [self loginWithMethodName:@"createUser" parameters:@[[self createUserParametersObjectWithEmail:email password:password firstName:firstName lastName:lastName]] completionHandler:^(id result, NSError *error) {
    if (completionHandler) {
      completionHandler(error);
    }
  }];
}

- (NSDictionary *)createUserParametersObjectWithEmail:(NSString *)email password:(NSString *)password
{
  return [self createUserParametersObjectWithEmail:email password:password firstName:nil lastName:nil];
}

- (NSDictionary *)createUserParametersObjectWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName {
  NSDictionary *params =  @{
                            @"email": email,
                            @"password": @{@"digest": [password SHA256String], @"algorithm": @"sha-256"}
                            };
  
  if (firstName || lastName) {
    NSMutableDictionary *profileParams = [NSMutableDictionary dictionary];
    if (firstName) {
      profileParams[@"first_name"] = firstName;
    }
    if (lastName) {
      profileParams[@"last_name"] = lastName;
    }
    
    NSMutableDictionary *mutableParams = [params mutableCopy];
    mutableParams[@"profile"] = profileParams;
    params = mutableParams;
  }
  
  return params;
}

@end
