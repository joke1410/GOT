//
//  GOTExpandedArticle.h
//  GOTCharacters
//
//  Created by Piotr Bruź on 11/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ExpandedArticle_Title @"title"
#define ExpandedArticle_Abstract @"abstract"
#define ExpandedArticle_Thumbnail @"thumbnail"


@interface GOTExpandedArticle : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *abstract;
@property (strong, nonatomic) NSString *thumbnail;


-(instancetype)initWithTitle:(NSString*)__title abstract:(NSString*)__abstract thumbnail:(NSString*)__thumbnail;

@end
