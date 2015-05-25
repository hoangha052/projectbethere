//
//  ReadMessageViewController.m
//  BeThere
//
//  Created by hoangha052 on 11/6/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "ReadMessageViewController.h"
#import "CreatMessageViewController.h"
#import "ContactListViewController.h"
#import "MapViewController.h"
#import "LoginInfo.h"

@interface ReadMessageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;

@end

@implementation ReadMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    // Do any additional setup after loading the view.
    self.tvMessage.text = [self.message objectForKey:@"content"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnReply:(id)sender {
    LoginInfo *info = [LoginInfo sharedObject];
    info.reply = YES;
    info.receiverReply = [self.message objectForKey:@"sender"];

    // Get user info from cloud for sending message.
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[self.message objectForKey:@"sender"]];
    info.arrayReceiver = @[@{@"user":[query getFirstObject]}];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MapViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnBackPress:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ContactListViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ContactListViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

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
