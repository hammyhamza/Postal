//
//  MapViewController.h
//  PostalSearch
//
//  Created by Thought Chimp on 08/06/16.
//  Copyright © 2016 HamzaAnsari. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController{
  NSDictionary *postDictionary;
  
  __weak IBOutlet MKMapView *mapView;
}

@property (strong,nonatomic) NSDictionary *postDictionary;

@end
