//
//  GOTExpandedArticle.m
//  GOTCharacters
//
//  Created by Piotr Bruź on 11/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import "GOTExpandedArticle.h"

@implementation GOTExpandedArticle


-(instancetype)initWithTitle:(NSString*)__title abstract:(NSString*)__abstract thumbnail:(NSString*)__thumbnail
{
	self = [super init];
	
	if(self)
	{
		self.title = __title;
		self.abstract = __abstract;
		
		if([__thumbnail isKindOfClass:[NSString class]])
		{
		   self.thumbnail = __thumbnail;
		}
	}
	
	return self;
}

@end
