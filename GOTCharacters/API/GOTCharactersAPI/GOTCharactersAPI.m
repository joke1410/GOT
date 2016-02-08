//
//  GOTCharactersAPI.m
//  GOTCharacters
//
//  Created by Piotr Bruź on 15/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOTCharactersAPI.h"
#import "GOTImageManager.h"
#import "GOTRestAPI.h"
#import "GOTExpandedArticle.h"


@implementation GOTCharactersAPI

+ (GOTCharactersAPI*)sharedInstance
{
	static GOTCharactersAPI *_sharedInstance = nil;
 
	static dispatch_once_t oncePredicate;
 
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[GOTCharactersAPI alloc] init];
		
		[_sharedInstance observeDownloadImageNotification];
	});
	
	return _sharedInstance;
}

-(void)downloadImage:(NSNotification*)__notification
{
	UIImageView *imageView = __notification.userInfo[@"imageView"];
	NSString *imageUrl = __notification.userInfo[@"thumbnailUrl"];
	NSString *title	= __notification.userInfo[@"title"];
	
	
	imageView.image = [[GOTImageManager sharedInstance] getImage:title];
	
	if(!imageView.image)
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			UIImage *downloadedImage = [[GOTRestAPI sharedInstance] getImageFromURL:imageUrl];

			dispatch_sync(dispatch_get_main_queue(), ^{
				imageView.image = downloadedImage;
				[[GOTImageManager sharedInstance] saveImage:downloadedImage filename:title];
			});
		});
	}
}

-(void)getCharactersAsync:(int)__limit withCompletion:(void (^)(NSArray *expandedArticles, NSError *error))callback
{
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[GOTRestAPI sharedInstance] getCharactersAsync:__limit withCompletion:^(NSArray *articles, NSError *error) {
			callback(articles,error);
		}];
	});
}

-(void)observeDownloadImageNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"GOTDownloadImageNotification" object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
