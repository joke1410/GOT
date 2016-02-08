//
//  GOTImageManager.m
//  GOTCharacters
//
//  Created by Piotr Bruź on 15/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import "GOTImageManager.h"

@implementation GOTImageManager


+ (GOTImageManager*)sharedInstance
{
	static GOTImageManager *_sharedInstance = nil;
 
	static dispatch_once_t oncePredicate;
 
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[GOTImageManager alloc] init];
	});
	
	return _sharedInstance;
}

- (void)saveImage:(UIImage*)image filename:(NSString*)filename
{
	filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
	NSData *data = UIImagePNGRepresentation(image);
	[data writeToFile:filename atomically:YES];
}

- (UIImage*)getImage:(NSString*)filename
{
	filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
	NSData *data = [NSData dataWithContentsOfFile:filename];
	return [UIImage imageWithData:data];
}

@end
