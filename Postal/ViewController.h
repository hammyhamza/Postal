//
//  ViewController.h
//  PostalSearch
//
//  Created by Hamza Ansari on 08/06/16.
//  Copyright © 2016 HamzaAnsari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>{
  CLLocationManager *locationManager;
  CLLocation *myLocation;
  NSArray *searchResult;
  
  __weak IBOutlet UITableView *resultTableView;
  __weak IBOutlet UITextField *textField;
  __weak IBOutlet UIView *loaderView;
}

@end

