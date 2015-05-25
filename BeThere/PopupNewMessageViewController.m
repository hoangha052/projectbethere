//
//  PopupNewMessageViewController.m
//  BeThere
//
//  Created by hoangha052 on 11/6/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "PopupNewMessageViewController.h"
#import "ReadMessageViewController.h"
#import "ContactListViewController.h"
#import "BBContans.h"
#import "Message+Utils.h"
#import "NSManagedObject+TSCUtils.h"

@interface PopupNewMessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PopupNewMessageViewController

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
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    NSString *sender = [self.dicMessage objectForKey:@"sender"];
    NSString *image = [self.dicMessage objectForKey:@"imagename"];
    //add some code to display package name here
    self.lblTitle.text = [NSString stringWithFormat:@"You found [%@] from [%@]. Take a look?",image,sender];
    self.imageView.image = [UIImage imageNamed:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//- (void) updateDataToServer:(^BOOL *)finished{
//    PFQuery *query = [PFQuery queryWithClassName:@"message"];
//    [query getObjectInBackgroundWithId:[self.dicMessage valueForKey:@"objectId"] block:^(PFObject *object, NSError *error) {
//        object[@"readmessage"] = @(YES);
//        [object saveEventually];
//    }];
//  
//}
- (IBAction)OpenButtonPress:(id)sender {
    NSString *stringId = [self.dicMessage valueForKey:@"objectId"];
    Message *messageItem = [[Message entitiesWithValue:stringId forKey:@"messageid" fault:NO] firstObject];
    messageItem.readmessage = @(YES);
    [messageItem save];
    
    ReadMessageViewController *viewController =
    [[UIStoryboard storyboardWithName:@"Main"
                               bundle:NULL] instantiateViewControllerWithIdentifier:@"ReadMessageViewController"];
    viewController.message = self.dicMessage;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)cancelButtonPress:(id)sender {
    ContactListViewController *viewController =
    [[UIStoryboard storyboardWithName:@"Main"
                               bundle:NULL] instantiateViewControllerWithIdentifier:@"ContactListViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
