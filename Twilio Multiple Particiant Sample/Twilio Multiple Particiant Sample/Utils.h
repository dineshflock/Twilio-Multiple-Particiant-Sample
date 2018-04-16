//
//  Utils.h
//  Talkto
//
//  Created by Dinesh Kumar on 2/2/18.
//  Copyright © 2018 Talk.to FZC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlatformUtils : NSObject

+ (BOOL)isSimulator;

@end

@interface TokenUtils : NSObject

+ (void)retrieveAccessTokenFromURL:(NSString *)tokenURLStr
                        completion:(void (^)(NSString* token, NSError *err)) completionHandler;

@end
