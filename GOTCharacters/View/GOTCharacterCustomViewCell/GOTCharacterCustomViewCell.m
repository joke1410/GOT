//
//  GOTCharacterCustomViewCell.m
//  GOTCharacters
//
//  Created by Piotr Bruź on 12/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import "GOTCharacterCustomViewCell.h"

@interface GOTCharacterCustomViewCell ()

@property (strong, nonatomic) NSString* thumbnailUrl;

@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *thumbnailBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *centralView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;


@end


@implementation GOTCharacterCustomViewCell

#pragma mark - synthesize properties section

@synthesize thumbnailUrl;
@synthesize titleBackgroundView, thumbnailBackgroundView, centralView;
@synthesize titleLabel, abstractLabel;
@synthesize thumbnailImageView;



#pragma mark - main methods to override

- (void)drawRect:(CGRect)rect
{

	[self prepareCentralView];
	
	[self prepareTitleBackgroundView];
	
	[self prepareTitleLabel];
	
	[self prepareThumbnailBackgroundView];
	
	if(thumbnailUrl)
	{
		[self postDownloadImageNotification];
	}
}


#pragma mark - prepare UI

-(void)prepareCentralView
{
	centralView.backgroundColor = [UIColor clearColor];
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = CGRectMake(0, 0, centralView.frame.size.width, centralView.frame.size.height);
	gradient.colors = [NSArray arrayWithObjects: (id)[UIColor colorWithRed:(215/255.0) green:(203/255.0) blue:(171/255.0) alpha:1].CGColor, (id)[UIColor colorWithRed:(193/255.0) green:(182/255.0) blue:(153/255.0) alpha:1].CGColor, nil];
	
	[centralView.layer insertSublayer:gradient atIndex:0];
}

-(void)prepareTitleBackgroundView
{
	titleBackgroundView.backgroundColor = [UIColor clearColor];
	
	UIBezierPath *pathTitleDecoration = [UIBezierPath bezierPath];
	[pathTitleDecoration fill];
	[pathTitleDecoration moveToPoint:CGPointMake(0, titleBackgroundView.frame.size.height/2-1)];
	
	[pathTitleDecoration addLineToPoint:CGPointMake(titleBackgroundView.frame.size.width/8, titleBackgroundView.frame.size.height/2-1)];
	[pathTitleDecoration addLineToPoint:CGPointMake(titleBackgroundView.frame.size.width/8+15, 0)];
	[pathTitleDecoration addLineToPoint:CGPointMake(7*titleBackgroundView.frame.size.width/8-15, 0)];
	[pathTitleDecoration addLineToPoint:CGPointMake(7*titleBackgroundView.frame.size.width/8, titleBackgroundView.frame.size.height/2-1)];
	[pathTitleDecoration addLineToPoint:CGPointMake(titleBackgroundView.frame.size.width, titleBackgroundView.frame.size.height/2-1)];
	
	[pathTitleDecoration addLineToPoint:CGPointMake(titleBackgroundView.frame.size.width, titleBackgroundView.frame.size.height/2+1)];
	[pathTitleDecoration addLineToPoint:CGPointMake(7*titleBackgroundView.frame.size.width/8, titleBackgroundView.frame.size.height/2+1)];
	[pathTitleDecoration addLineToPoint:CGPointMake(7*titleBackgroundView.frame.size.width/8-15, titleBackgroundView.frame.size.height)];
	[pathTitleDecoration addLineToPoint:CGPointMake(titleBackgroundView.frame.size.width/8+15, titleBackgroundView.frame.size.height)];
	[pathTitleDecoration addLineToPoint:CGPointMake(titleBackgroundView.frame.size.width/8, titleBackgroundView.frame.size.height/2+1)];
	[pathTitleDecoration addLineToPoint:CGPointMake(0, titleBackgroundView.frame.size.height/2+1)];
	
	[pathTitleDecoration closePath];
	
	
	CAShapeLayer *titleDecorationShapeLayer = [[CAShapeLayer alloc] init];
	titleDecorationShapeLayer.fillColor = [UIColor colorWithRed:(42/255.0) green:(116/255.0) blue:(142/255.0) alpha:1].CGColor;
	titleDecorationShapeLayer.path = pathTitleDecoration.CGPath;
	
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = CGRectMake(0, 0, titleBackgroundView.frame.size.width, titleBackgroundView.frame.size.height);
	gradient.colors = [NSArray arrayWithObjects:
					   (id)[UIColor colorWithRed:(63/255.0) green:(129/255.0) blue:(153/255.0) alpha:1].CGColor,
					   (id)[UIColor colorWithRed:(42/255.0) green:(116/255.0) blue:(142/255.0) alpha:1].CGColor,
					   nil];
	gradient.mask = titleDecorationShapeLayer;
	
	
	[titleBackgroundView.layer insertSublayer:gradient atIndex:0];
}

-(void)prepareTitleLabel
{
	titleLabel.textColor = [UIColor whiteColor];
}

-(void)prepareThumbnailBackgroundView
{
	thumbnailBackgroundView.backgroundColor = [UIColor colorWithRed:(215/255.0) green:(203/255.0) blue:(171/255.0) alpha:1];
	thumbnailBackgroundView.layer.cornerRadius = 5;
	thumbnailBackgroundView.layer.borderColor = [UIColor darkGrayColor].CGColor;
	thumbnailBackgroundView.layer.borderWidth = 0.5;
	thumbnailBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
	thumbnailBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
	thumbnailBackgroundView.layer.shadowOpacity = 0.7;
	thumbnailBackgroundView.layer.shadowRadius = 1;
}


#pragma mark - NSNotifications management

-(void)postDownloadImageNotification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GOTDownloadImageNotification"
														object:self
													  userInfo:@{@"imageView":thumbnailImageView, @"thumbnailUrl":thumbnailUrl, @"title":titleLabel.text}];
}


#pragma mark - public methods to set view's data

-(void)setTitle:(NSString*)__title
{
	titleLabel.text = __title;
}

-(void)setAbstract:(NSString*)__abstract
{
	//abstractLabel.text = __abstract;
	
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = NSTextAlignmentJustified;
	paragraphStyle.firstLineHeadIndent = 0.01;
	NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:__abstract attributes:attributes];
	abstractLabel.attributedText = attributedString;

}

-(void)setThumbnail:(NSString*)__thumbnail
{
	thumbnailUrl = [[NSString alloc] init];
	thumbnailUrl = __thumbnail;
}

@end
