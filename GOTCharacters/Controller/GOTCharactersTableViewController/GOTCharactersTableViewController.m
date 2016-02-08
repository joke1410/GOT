//
//  GOTCharactersTableViewController.m
//  GOTCharacters
//
//  Created by Piotr Bruź on 14/09/15.
//  Copyright (c) 2015 Piotr Bruź. All rights reserved.
//

#import "GOTCharactersTableViewController.h"

#import "GOTCharactersAPI.h"
#import "GOTExpandedArticle.h"
#import "GOTCharacterCustomViewCell.h"


#define CHARACTERS_LIMIT 75


@interface GOTCharactersTableViewController ()

@property (nonatomic, strong) NSArray *td_articles;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;

- (IBAction)clearData:(id)__sender;

@end


@implementation GOTCharactersTableViewController

#pragma mark - synthesize properties section

@synthesize td_articles;
@synthesize clearButton;

#pragma mark - main methods to override

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	td_articles = [[NSArray alloc] init];
	
	[self prepareTableView];
	
	[self prepareRefreshControl];
	
	[self prepareClearButton];
	
	[self addNotificationObservers];
}

#pragma mark - prepare UI

-(void)prepareTableView
{
	self.tableView.layoutMargins = UIEdgeInsetsZero;
	
	self.edgesForExtendedLayout=UIRectEdgeNone;
	self.extendedLayoutIncludesOpaqueBars=NO;
	self.automaticallyAdjustsScrollViewInsets=NO;
}

-(void)prepareRefreshControl
{
	self.refreshControl = [[UIRefreshControl alloc] init];
	self.refreshControl.backgroundColor = [UIColor darkGrayColor];
	self.refreshControl.tintColor = [UIColor whiteColor];
	[self.refreshControl addTarget:self
							action:@selector(getCharacters)
				  forControlEvents:UIControlEventValueChanged];
}

-(void)prepareClearButton
{
	clearButton.enabled = NO;
}


#pragma mark - getCharacters

-(void)getCharacters
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[GOTCharactersAPI sharedInstance] getCharactersAsync:CHARACTERS_LIMIT withCompletion:^(NSArray *expandedArticles, NSError *error) {
			if(!error)
			{
				td_articles = [NSArray arrayWithArray:expandedArticles];
				
				dispatch_sync(dispatch_get_main_queue(), ^{
					clearButton.enabled = YES;
				});
				
				[self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
			}
			else
			{
				NSString *errorMessage;
				
				if(error.code==-1009)
				{
					errorMessage = @"There is no Internet connection - turn it on.";
				}
				else
				{
					errorMessage = @"An unknown error occured. Please try again.";
				}
				
				dispatch_sync(dispatch_get_main_queue(), ^{
					UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
																	  message:errorMessage
																	 delegate:nil
															cancelButtonTitle:@"OK"
															otherButtonTitles:nil];
					[message show];
				});
				
				[self.refreshControl endRefreshing];
			}
		}];
	});
}


#pragma mark - tableView helper methods

-(void)reloadTableView
{
	[self.tableView reloadData];
	
	if (self.refreshControl)
	{
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MMM d, h:mm a"];
		NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
		NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
																	forKey:NSForegroundColorAttributeName];
		NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
		self.refreshControl.attributedTitle = attributedTitle;
		
		[self.refreshControl endRefreshing];
	}
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)__tableView numberOfRowsInSection:(NSInteger)__section
{
    return td_articles.count;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)__indexPath
{
	GOTCharacterCustomViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GOTCharacterCustomViewCell" owner:self options:nil] objectAtIndex:0];
	
	GOTExpandedArticle *currentArticle = (GOTExpandedArticle*)[td_articles objectAtIndex:__indexPath.row];
	
	[cell setTitle:currentArticle.title];
	[cell setAbstract:currentArticle.abstract];
	[cell setThumbnail:currentArticle.thumbnail];
	
	
	cell.backgroundColor = [UIColor darkGrayColor];
	cell.layoutMargins = UIEdgeInsetsZero;
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)__tableView
{
	if (!td_articles.count==0)
	{
		return 1;
	}
	else
	{
		UILabel *messageLabel = [[UILabel alloc] init];
		messageLabel.text = @"Pull down to get list of most view characters.";
		messageLabel.textColor = [UIColor whiteColor];
		messageLabel.numberOfLines = 2;
		messageLabel.textAlignment = NSTextAlignmentCenter;
		messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:23];
		[messageLabel sizeToFit];
		
		self.tableView.backgroundView = messageLabel;
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return 0;
}


#pragma mark - NSNotifications management

-(void)addNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)removeNotificationObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


#pragma mark - Button's methods

- (IBAction)clearData:(id)__sender
{
	td_articles = [[NSArray alloc] init];
	
	clearButton.enabled = NO;
	
	[self.tableView reloadData];
}

@end
