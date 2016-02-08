//
//  GOTRestAPI.m
//  GOTCharacters
//
//  Created by Piotr Bruź on 11/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import "GOTRestAPI.h"
#import "GOTExpandedArticle.h"


@implementation GOTRestAPI

+ (GOTRestAPI*)sharedInstance
{
	static GOTRestAPI *_sharedInstance = nil;
 
	static dispatch_once_t oncePredicate;
 
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[GOTRestAPI alloc] init];
	});
	
	return _sharedInstance;
}

-(UIImage*)getImageFromURL:(NSString*)__url
{
	UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:__url]]];
		
	return  downloadedImage;
}

-(void)getCharactersAsync:(int)__limit withCompletion:(void (^)(NSArray *articles, NSError *error))callback
{
	NSString *url = [[NSString alloc] initWithFormat:@"%s%s&category=%s&limit=%d",SERVER_API_URL, MOST_VIEWED_ARTICLES_ENDPOINT, ARTICLE_CATEGORY,__limit];
	
	
	NSURLSession *session = [NSURLSession sharedSession];
	[[session dataTaskWithURL:[NSURL URLWithString:url]
			completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
				
				if(error)
				{
					callback(nil, error);
				}
				else
				{
					NSError *jsonError;
					NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
					
					if(jsonError)
					{
						callback(nil, jsonError);
					}
					else
					{
						NSMutableArray *articles = [[NSMutableArray alloc] init];
						
						for (NSDictionary* articleDictionary in [result objectForKey:@"items"]) {
							GOTExpandedArticle *expandedArticle = [[GOTExpandedArticle alloc] initWithTitle:[articleDictionary objectForKey:ExpandedArticle_Title]
																								   abstract:[articleDictionary objectForKey:ExpandedArticle_Abstract]
																								  thumbnail:[articleDictionary objectForKey:ExpandedArticle_Thumbnail]];
							
							[articles addObject:expandedArticle];
						}
						
						
						callback(articles,error);
					}
				}
			}] resume];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
