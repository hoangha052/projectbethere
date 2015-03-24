//
//  CreatMessageViewController.m
//  BeThere
//
//  Created by hoangha052 on 11/6/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "CreatMessageViewController.h"
#import "NSPredicate+TSCUtils.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "LoginInfo.h"
#import "ContactListViewController.h"

@interface CreatMessageViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewReceiver;

@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (strong, nonatomic) UIBarButtonItem *dismissKeyboardButton;
@property (strong, nonatomic) NSArray *revicerArray;
@end

@implementation CreatMessageViewController

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
    LoginInfo *info = [LoginInfo sharedObject];
    NSString *stringReceiver = @"To: ";
    if (info.reply) {
        stringReceiver = [stringReceiver stringByAppendingString:info.receiverReply];
    }else
    {
        for (NSDictionary *dic in info.arrayReceiver)
        {
            PFUser *userReceiver = [dic objectForKey:@"user"];
            stringReceiver = [stringReceiver stringByAppendingString:[NSString stringWithFormat:@"%@, ",userReceiver.username]];
        }
        stringReceiver = [stringReceiver substringToIndex:[stringReceiver length]-2];
    }
    self.lblTo.text = stringReceiver;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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

- (IBAction)btnBeTherePress:(id)sender {
    LoginInfo *info = [LoginInfo sharedObject];
    if ([_tvMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFObject *objectMessage = [PFObject objectWithClassName:@"message"];
            for (NSDictionary *dic in info.arrayReceiver) {
                PFUser *userReceiver = [dic objectForKey:@"user"];
                NSString *receiver = userReceiver.username;
                objectMessage[@"content"] = _tvMessage.text;
                objectMessage[@"receiver"] = receiver;
                objectMessage[@"sender"] = info.userName;
                objectMessage[@"readmessage"] = @(NO);
                objectMessage[@"location"] = self.locationRecieve;
                objectMessage[@"radius"] = @(self.radiusReceiver);
                objectMessage[@"imagename"] = self.imageName;
                [objectMessage saveEventually];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                info.reply = NO;
                CreatMessageViewController *viewController =
                [[UIStoryboard storyboardWithName:@"Main"
                                           bundle:NULL] instantiateViewControllerWithIdentifier:@"ContactListViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            });
        });
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"THONG BAO" message:@"Ban chua nhap noi dung tin nhan" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (IBAction)btnBackPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
