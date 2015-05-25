//
//  MapViewController.m
//  BeThere
//
//  Created by hoangha052 on 11/7/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "MapViewController.h"
#import "BBContans.h"
#import "ContactListViewController.h"
#import "CreatMessageViewController.h"
#import <MapKit/MapKit.h>
#import "CircleView.h"
#import "LoginInfo.h"
#import "MyCustomAnnotation.h"
#import "CustomAnnotationView.h"

#import <QuartzCore/QuartzCore.h>

@interface MapViewController ()<CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *locationUser;
@property (strong, nonatomic) PFGeoPoint *curentPoint;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *radiusValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *radius_slider;
@property (nonatomic) NSInteger radiusValue;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRadius;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *stringImage;
@property (strong, nonatomic) LoginInfo *loginInfo;

@property (weak, nonatomic) IBOutlet UIScrollView *pkView;
@property (nonatomic, retain) NSMutableArray *pkButtons;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CreatMessageViewController *controller = [segue destinationViewController];
    controller.locationRecieve = (PFGeoPoint *)sender;
}*/


- (IBAction)btnBetherePress:(id)sender {
    if ([self.mapview.annotations count] > 0) {
        MKPointAnnotation *point = [self.mapview.annotations lastObject];
        CLLocation* locationUser = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:locationUser];
        [self sendLocation:geoPoint];
    }
    else
    {
        [self.locationManager startUpdatingLocation];
        
    }
}

- (void)sendLocation:(PFGeoPoint *)geoPoint
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CreatMessageViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"CreatMessageViewController"];
    controller.locationRecieve = geoPoint;
    controller.radiusReceiver = self.radiusValue;
    controller.imageName = self.stringImage;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnCancelPress:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ContactListViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ContactListViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnBackPress:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ContactListViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ContactListViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Location Delegate


- (void)viewDidLoad
{
    //Count number of packages in folder package
    /*NSMutableString *bundlePath = [NSMutableString stringWithCapacity:4];
    [bundlePath appendString:[[NSBundle mainBundle] bundlePath]];
    [bundlePath appendString:@"/BeThere/ResourceImage/Package"];
    NSArray *packageContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundlePath error:nil];
    int numberOfPackage = [packageContent  count];
    */

    //NSArray *packageContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/package"] error:Nil];
    NSMutableArray *packageContent = [[NSMutableArray alloc]init];
    NSArray *allContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] resourcePath] error:Nil];
    int numberOfContent = [allContent count];
    
    for (int i=0; i<numberOfContent; i++) {
        NSString *packageName = [[allContent objectAtIndex:i]  stringByDeletingPathExtension];
        NSString *packageType = [packageName substringFromIndex: [packageName length] - 2];
        NSString *ISpackage = [packageName substringToIndex:2];
        if ((! [packageType isEqualToString:@"2x"]) && ([ISpackage isEqualToString:@"pk"])) {
            [packageContent addObject:packageName];
        };
    }
    
    int numberOfPackage = [packageContent count];
   // NSString *path = [NSBundle mainBundle] resourcePath;

   NSLog(@"%d", numberOfPackage);
   NSLog(@"%d", numberOfContent);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1111" ofType:@"png"];
    NSLog(@"%@", filePath);
      //Create buttons = number of package files
    for(int i=0;i<numberOfPackage;i++){
        //Create the button
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((i+1)*30 + i*10,8,30, 30)];

        //You may want to set button titles here
        //or perform other customizations
        UIImage *buttonImage = [UIImage imageNamed:[packageContent objectAtIndex:i]];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        button.titleLabel.text= [packageContent objectAtIndex:i];
        button.titleLabel.hidden= YES;
        [self.pkView addSubview:button];
        
        // Update the contentSize to include the new button.
        CGFloat width = CGRectGetMaxX(button.frame);
        CGFloat height = self.pkView.bounds.size.height;
        self.pkView.contentSize = CGSizeMake(width+30, height);
        
        //Store the button in our array
        [self.pkButtons addObject:button];
        //Release the button (our array retains it for us)
        
        //add action
        [button addTarget:self action:@selector(pkSelected:) forControlEvents:UIControlEventTouchDown];
       // [button release];
    }
    
    //
    // Show the buttons onscreen
    //
    
    /*for(UIButton *button in self.pkButtons){
        //add the button to the view
        [self.view addSubview:button];
        //add the action
        [button addTarget:self action:@selector(pkSelected:) forControlEvents:UIControlEventTouchDown];
    }*/
    
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    self.radiusValue = 10;
    self.stringImage = @"pk1";
    self.loginInfo = [LoginInfo sharedObject];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapview.showsUserLocation = YES;
    self.mapview.delegate = self;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    
    [self.mapview addGestureRecognizer:tapRecognizer];
}

/*/popup
+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if (iOSVersion >= 8.0)
    {
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}*/

//https://gist.github.com/a1phanumeric/2249553
-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer
{
    [self.mapview removeAnnotations:self.mapview.annotations];
    CGPoint point = [recognizer locationInView:self.mapview];
    self.coordinate = [self.mapview convertPoint:point toCoordinateFromView:self.mapview];
    
    
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = self.coordinate;
    
    MyCustomAnnotation *pointAnnotation = [[MyCustomAnnotation alloc] initWithLocation:self.coordinate];
    [self.mapview addAnnotation:pointAnnotation];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.coordinate, self.radiusValue * 10,self.radiusValue * 10);
    [self.mapview setRegion:viewRegion animated:YES];

    [self changeRadiusValue:self.radius_slider];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MyCustomAnnotation";
    if ([annotation isKindOfClass:[MyCustomAnnotation class]]) {
        CustomAnnotationView *annotationView = (CustomAnnotationView *) [self.mapview dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"fluke-pinpoint"];
            //here we use a nice image instead of the default pins
            self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.stringImage]];
//            [self.imageView sizeToFit];
            self.imageView.frame = CGRectMake(2, -35, 30, 30);
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [annotationView addSubview:self.imageView];
            
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    return nil;
}
/*- (IBAction)selectedImage:(id)sender {
    UIButton *button = (UIButton *)sender;
    self.stringImage = [self.loginInfo.arrayImage objectAtIndex:button.tag];
    self.imageView.image = [UIImage imageNamed:self.stringImage];
}*/

- (void)pkSelected:(UIButton*)button
{
    self.stringImage = button.titleLabel.text;
    self.imageView.image = [UIImage imageNamed:self.stringImage];
    NSLog(@"pressed %@", _stringImage);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        if (!error && [placemarks count]> 0) {
            [self issueLocalSearchLookup:theSearchBar.text usingPlacemarksArray:placemarks];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"That place doesn't exist... yet" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Deal with it", nil];
            [alert show];
        }
    }];
    
}

-(void)issueLocalSearchLookup:(NSString *)searchString usingPlacemarksArray:(NSArray *)placemarks {
    
    // Search 0.250km from point for stores.
    CLPlacemark *placemark = placemarks[0];
    CLLocation *location = placemark.location;
    // Set the size (local/span) of the region (address, w/e) we want to get search results for.
    MKCoordinateSpan span;
    double radius = placemark.region.radius / 1000; // convert to km
    span.latitudeDelta = radius / 112.0;
    MKCoordinateRegion region = MKCoordinateRegionMake( location.coordinate, span);
    
    [self.mapview setRegion:region animated:NO];
    
    // Create the search request
    MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init];
    localSearchRequest.region = region;
    localSearchRequest.naturalLanguageQuery = searchString;
    
    // Perform the search request...
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        if(error){
            NSLog(@"localSearch startWithCompletionHandlerFailed!  Error: %@", error);
            return;
            
        } else {
            for(MKMapItem *mapItem in response.mapItems){
                // Show pins, pix, w/e...
                NSLog(@"Name for result: = %@", mapItem.name);
//                    MKPointAnnotation *annotation =
//                    [[MKPointAnnotation alloc]init];
//                    annotation.coordinate = mapItem.placemark.coordinate;
//                    annotation.title = mapItem.name;
                MyCustomAnnotation *pointAnnotation = [[MyCustomAnnotation alloc] initWithLocation:mapItem.placemark.coordinate];
                    [self.mapview addAnnotation:pointAnnotation];
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// http://stackoverflow.com/questions/7199832/i-need-a-dead-simple-implementation-of-mkcircle-overlay
- (IBAction)changeRadiusValue:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.radiusValue = slider.value;
    self.radiusValueLabel.text = [NSString stringWithFormat:@"%0.0f m",slider.value];
    [self.mapview removeOverlays:self.mapview.overlays];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:self.radiusValue];
    [self.mapview addOverlay:circle];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay];
    circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    return circleView;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

// update location.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation !=nil) {
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:newLocation];
        [self sendLocation:geoPoint];
        [self.locationManager stopUpdatingLocation];
    }
}


/*- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;
    
    MKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(2.0, 2.0); //Zoom distance
    region = [self.mapview regionThatFits:region];
    [self.mapview setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)theMapView didUpdateToUserLocation:(MKUserLocation *)location
{
    [self zoomToUserLocation:location];
}
*/

//Inventory
  //Create buttons = number of package files
- (id)init{
    
    self = [super init];
    
    if(self){
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        self.pkButtons = temp;
       // [temp release];
        
    }
    
    return self;
    
}
- (void)someMethod:(id)sender{
    //Do something when the button was pressed;
}

/*- (void)dealloc{
    [self.pkButtons release];
    [super dealloc];
}*/


@end
