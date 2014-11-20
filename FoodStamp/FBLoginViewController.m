//
//  FBLoginViewController.m
//  FBParse
//  FoodStamp
//
//  Copyright (c) 2014  FoodStamp and/or its affiliates.
//	All rights reserved.
//
//  Created by Jesus Cruz Perez on 01/04/14.
//
//	Purpose:
//	This file is for Login using Facebook and as such, content may include code created and shared by Facebook, Inc.
//
//  Modifications:
//
//  File    Patching Date in
//  Version Bug      Production   Author           Modification
//  ======= ======== ============ ================ ===================================
//  1.0     00000000 DD-MMM-YYYY  Author's Name    - created
//
//  ==================================================================================
//

#import "FBLoginViewController.h"
#import "MBProgressHUD.h"

@interface FBLoginViewController () <CommsDelegate>
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) IBOutlet UIButton *btnLogin;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityLogin;
@property (nonatomic, strong) MBProgressHUD *hud;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation FBLoginViewController

@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    [self scrollViewWillAppear];
    self.navigationController.navigationBar.hidden = YES;
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
        return;
        
        
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
    // Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
    // Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void) viewDidLoad
{
    
    [self initializeScrollView];
    [super viewDidLoad];
}

// Outlet for FBLogin button
- (IBAction) loginPressed:(id)sender
{
   // Disable the Login button to prevent multiple touches
   [_btnLogin setEnabled:NO];
   
   // Show an activity indicator
   //[_activityLogin startAnimating];
   
   self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   self.hud.labelText = NSLocalizedString(@"Loading", nil);
   self.hud.dimBackground = YES;

   // Do the login
   [Comms login:self];
}

- (void) initializeScrollView{
    
    
    self.pageImages = [[NSArray alloc] initWithObjects:
                 [UIImage imageNamed:@"App_Tutorial1.png"],
                 [UIImage imageNamed:@"App_Tutorial2.png"],
                 [UIImage imageNamed:@"App_Tutorial3.png"],
                 [UIImage imageNamed:@"App_Tutorial4.png"],
                 [UIImage imageNamed:@"App_Tutorial5.png"],
                 nil];
    NSInteger pageCount = self.pageImages.count;

    
    // 2
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // 3
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    
}




-(void) scrollViewWillAppear {
    
    // 4
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // 5
    [self loadVisiblePages];

    
}
- (void) commsDidLogin:(BOOL)loggedIn {
	// Re-enable the Login button
	[_btnLogin setEnabled:YES];
   
	// Stop the activity indicator
	[_activityLogin stopAnimating];
   
	// Did we login successfully ?
	if (loggedIn) {
		// Seque to the Image Wall
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];

	} else {
		// Show error alert
		[[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                  message:@"Facebook Login failed. Please try again"
                                 delegate:nil
                        cancelButtonTitle:@"Ok"
                        otherButtonTitles:nil] show];
	}
}




@end
