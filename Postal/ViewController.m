//
//  ViewController.m
//  PostalSearch
//
//  Created by Thought Chimp on 08/06/16.
//  Copyright © 2016 HamzaAnsari. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  locationManager = [[CLLocationManager alloc] init];
  resultTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
  [self getCurrentLocation];
  [self addHideKeyboardToTextField];
  loaderView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)addHideKeyboardToTextField{
  
  UIButton *keyboardButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
  [keyboardButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
  [keyboardButton setImage:[UIImage imageNamed:@"hide"] forState: UIControlStateNormal];
  keyboardButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
  UIView *line = [[UIView alloc]initWithFrame: CGRectMake(0, 0, keyboardButton.frame.size.width,  0.5)];
  line.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
  [keyboardButton addSubview:line];
  
  textField.inputAccessoryView = keyboardButton;
}

- (void)getCurrentLocation{
  // Ask for Authorisation from the User.
  [locationManager requestWhenInUseAuthorization];
  
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [searchResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  cell.textLabel.text = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"adminName2"];
  cell.detailTextLabel.text = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"placeName"];
  
  return cell;
}


- (IBAction)hideKeyboard:(id)sender {
  [textField resignFirstResponder];
}

- (IBAction)searchTapped:(id)sender {
  [self getJSONWithPlace:sender nearMe:NO];
}

- (IBAction)nearMeTapped:(id)sender {
  [locationManager startUpdatingLocation];
}

- (IBAction)getJSONWithPlace:(id)sender nearMe:(BOOL)searchNear{
  loaderView.hidden = NO;
  [textField resignFirstResponder];
  
  NSURL *url;
  
  if (searchNear){
    if (myLocation != nil){
      NSString *urlString = [NSString stringWithFormat:@"http://api.geonames.org/findNearbyPostalCodesJSON?lat=%f&lng=%f&username=hammyhamza", myLocation.coordinate.latitude, myLocation.coordinate.longitude];
      url = [NSURL URLWithString:urlString];
    }else{
      [self showErrorAlert];
    }
    
  }else{
    if ([textField.text integerValue]){
      NSString *urlString = [NSString stringWithFormat:@"http://api.geonames.org/postalCodeSearchJSON?postalcode=%ld&maxRows=10&username=hammyhamza",[textField.text integerValue]];
      url = [NSURL URLWithString: urlString];
    }else{
      NSString *urlString = [NSString stringWithFormat:@"http://api.geonames.org/postalCodeSearchJSON?placename=%@&maxRows=10&username=hammyhamza",textField.text];
      url = [NSURL URLWithString:urlString];
    }
    textField.text = nil;
    
  }
  // Create a download task.
  NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                           completionHandler:^(NSData *data,
                                                                               NSURLResponse *response,
                                                                               NSError *error)
                                {
                                  if (!error)
                                  {
                                    NSError *JSONError = nil;
                                    
                                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:&JSONError];
                                    if (JSONError)
                                    {
                                      NSLog(@"Serialization error: %@", JSONError.localizedDescription);
                                    }
                                    else
                                    {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                        searchResult = [dictionary objectForKey:@"postalCodes"];
                                        [resultTableView reloadData];
                                        loaderView.hidden = YES;
                                      });
                                    }
                                  }
                                  else
                                  {
                                    NSLog(@"Error: %@", error.localizedDescription);
                                  }
                                }];
  
  // Start the task.
  [task resume];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"didFailWithError: %@", error);
  [self showErrorAlert];
}

-(void)showErrorAlert{
  UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle: UIAlertControllerStyleAlert];
  
  UIAlertAction *cancelAction = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *action)
                                 {
                                   NSLog(@"Cancel action");
                                 }];
  
  UIAlertAction *okAction = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                               NSLog(@"OK action");
                             }];
  
  [errorAlert addAction:cancelAction];
  [errorAlert addAction:okAction];
  
  [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
  [locationManager stopUpdatingLocation];
  NSLog(@"didUpdateToLocation: %@", newLocation);
  CLLocation *currentLocation = newLocation;
  
  if (currentLocation != nil) {
    myLocation = currentLocation;
    [self getJSONWithPlace:nil nearMe:YES];
    // currentLocation.coordinate.longitude];
    //currentLocation.coordinate.latitude];
  }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([segue.identifier isEqualToString:@"showMap"]){
    MapViewController *map = (MapViewController *)[segue destinationViewController];
    map.postDictionary = [searchResult objectAtIndex:resultTableView.indexPathForSelectedRow.row];
  }
}

@end
