//
//  MapPin.h
//  PostalSearch
//
//  Created by Thought Chimp on 08/06/16.
//  Copyright © 2016 HamzaAnsari. All rights reserved.
//

#import <MapKit/MKAnnotation.h>

@interface MapPin : NSObject <MKAnnotation> {
  
  CLLocationCoordinate2D coordinate;
  NSString *title;
  NSString *subtitle;
  
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
