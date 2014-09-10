//
//  FBLoginViewController.m
//  FBParse
//

#import "FBLoginViewController.h"
#import "MBProgressHUD.h"

@interface FBLoginViewController () <CommsDelegate>
@property (nonatomic, strong) IBOutlet UIButton *btnLogin;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityLogin;
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation FBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
        return;
    }
}

- (void) viewDidLoad
{
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
