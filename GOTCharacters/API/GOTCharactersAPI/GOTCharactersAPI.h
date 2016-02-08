//
//  GOTCharactersAPI.h
//  GOTCharacters
//
//  Created by Piotr Bruź on 15/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOTCharactersAPI : NSObject

+ (GOTCharactersAPI*)sharedInstance;

-(void)getCharactersAsync:(int)__limit withCompletion:(void (^)(NSArray *expandedArticles, NSError *error))callback;

@end
