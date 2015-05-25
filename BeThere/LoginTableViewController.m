//
//  LoginTableViewController.m
//  bethere
//
//  Created by hoangha052 on 11/29/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "LoginTableViewController.h"
#import "LoginInfo.h"
#import "BBContans.h"
#import "ContactListViewController.h"
#import <Parse/Parse.h>


@interface LoginTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) UITextField *currentTextField;

@end

@implementation LoginTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{

    
    self.tfPassword.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.tfUserName.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.tfEmail.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.tfEmail.layer.cornerRadius = 8.0;
    self.tfEmail.layer.borderWidth = 1.0;
    self.tfEmail.layer.masksToBounds = YES;
    
    self.tfPassword.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.tfPassword.layer.cornerRadius = 8.0;
    self.tfPassword.layer.borderWidth = 1.0;
    self.tfPassword.layer.masksToBounds = YES;
    
    self.tfUserName.layer.borderColor  = [[UIColor whiteColor] CGColor];
    self.tfUserName.layer.cornerRadius = 8.0;
    self.tfUserName.layer.borderWidth = 1.0;
    self.tfUserName.layer.masksToBounds = YES;

//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginPress:(id)sender {
    [PFUser logInWithUsernameInBackground:_tfUserName.text  password:_tfPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user)
                                        {
                                            // Check email verification.
                                            if([[user objectForKey:@"emailVerified"] boolValue] == NO)
                                            {
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This user's email isn't verified, please verify your email before using app" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                                [alertView show];
                                                return;
                                            }

                                            // Save login credentials for accessing it throughout the app.
                                            PFInstallation *dataInstall = [PFInstallation currentInstallation];
                                            [dataInstall removeObjectForKey:@"channels"];
                                            [dataInstall addUniqueObject:_tfUserName.text forKey:@"channels"];
                                            [dataInstall saveInBackground];

                                            LoginInfo *saveLogin = [LoginInfo sharedObject];
                                            saveLogin.userName = user.username;
                                            saveLogin.password = user.password;
                                            saveLogin.userEmail = user.email;

                                            // Do stuff after successful login.
                                            [self performSegueWithIdentifier:kSegue_ContactListViewController sender:self];

                                            // @todo debug
//                                            NSDictionary *data =@{@"type":@"request",@"sender":@"phannam"};
//                                            [[[UIApplication sharedApplication] delegate] application:[UIApplication sharedApplication] didReceiveRemoteNotification:data];

                                        } else
                                        {
                                            // The login failed. Check error to see why.
                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Wrong username or password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                            [alertView show];
                                        }
                                    }];
    
}

- (IBAction)btnRegisterPress:(id)sender {
    PFUser *user = [PFUser user];
    user.username = _tfUserName.text;
    user.password = _tfPassword.text;
    user.email = _tfUserName.text;
    // other fields can be set just like with PFObject

    // Username is automatically set up using username in email address.
    NSArray* parts = [user.username componentsSeparatedByString:@"@"];
    if(parts.count > 0)
    {
        user.username = [parts objectAtIndex:0];
    }

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFInstallation *dataInstall = [PFInstallation currentInstallation];
            [dataInstall removeObjectForKey:@"channels"];
            if ([PFUser currentUser] !=nil) {
                [dataInstall setObject:[PFUser currentUser] forKey:@"user"];
            }
            // When users indicate they are Giants fans, we subscribe them to that channel.
            [dataInstall addUniqueObject:_tfUserName.text forKey:@"channels"];
            [dataInstall saveInBackground];
            LoginInfo *saveLogin = [LoginInfo sharedObject];
            saveLogin.userName = user.username;
            saveLogin.password = user.password;
            saveLogin.userEmail = user.email;
            // Hooray! Let them use the app now.
            [self performSegueWithIdentifier:kSegue_ContactListViewController sender:self];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Wrong email format or user already existed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.tfEmail]) {
        [self.tfUserName becomeFirstResponder];
    } else if ([textField isEqual:self.tfUserName]) {
        [self.tfPassword becomeFirstResponder];
    } else if ([textField isEqual:self.tfPassword]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// Fix error that the segue is currently connected from table view cell to another view controller,
// that's why when touching on the bottom cell, then the app will push to another view
// instead of touching on login and register button.
// We need to connect the segue from the view to another view instead of the table cell to another view.
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"ContactListViewController"])
    {
        LoginInfo *info = [LoginInfo sharedObject];
        if(info.userName == nil) return NO;
    }
    return YES;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return ;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
