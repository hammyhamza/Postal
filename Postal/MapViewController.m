
//
//  MapViewController.m
//  PostalSearch
//
//  Created by Thought Chimp on 08/06/16.
//  Copyright © 2016 HamzaAnsari. All rights reserved.
//

#import "MapViewController.h"
#import "MapPin.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize postDictionary;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CLLocationCoordinate2D center;
  center.latitude = [[postDictionary valueForKey:@"lat"] floatValue];
  center.longitude = [[postDictionary valueForKey:@"lng"] floatValue];;
  
  
  MapPin *pin = [[MapPin alloc] init];
  pin.title = [postDictionary valueForKey:@"placeName"];
  pin.subtitle = [postDictionary valueForKey:@"adminName2"];
  [mapView addAnnotation:pin];
  pin.coordinate = center;
  
  MKCoordinateSpan zoom;
  zoom.latitudeDelta = .01f; //the zoom level in degrees
  zoom.longitudeDelta = .01f;//the zoom level in degrees
  
  //the region the map will be showing
  MKCoordinateRegion myRegion;
  myRegion.center = center;
  myRegion.span = zoom;
  
  //set the map location/region
  [mapView setRegion:myRegion animated:YES];
  
  mapView.mapType = MKMapTypeStandard;//standard map(not satellite)
  
  
  // Do any additional setup after loading the view.
}
@end
