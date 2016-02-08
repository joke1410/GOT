//
//  GOTRestAPI.h
//  GOTCharacters
//
//  Created by Piotr Bruź on 11/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SERVER_API_URL "http://gameofthrones.wikia.com/api/"
#define MOST_VIEWED_ARTICLES_ENDPOINT "v1/Articles/Top?expand=1"
#define ARTICLE_CATEGORY "Characters"


@interface GOTRestAPI : NSObject

+(GOTRestAPI*)sharedInstance;

-(void)getCharactersAsync:(int)__limit withCompletion:(void (^)(NSArray *articles, NSError *error))callback;
-(UIImage*)getImageFromURL:(NSString*)__url;

@end
