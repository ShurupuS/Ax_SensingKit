//
//  SKLocationSensing.m
//  SensingKit
//
//  Copyright (c) 2014. Queen Mary University of London
//  Kleomenis Katevas, k.katevas@qmul.ac.uk
//
//  This file is part of SensingKit-iOS library.
//  For more information, please visit http://www.sensingkit.org
//
//  SensingKit-iOS is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  SensingKit-iOS is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with SensingKit-iOS.  If not, see <http://www.gnu.org/licenses/>.
//

#import "SKLocationSensing.h"

@interface SKLocationSensing ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SKLocationSensing

- (instancetype)init
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;  // kCLLocationAccuracyBestForNavigation??
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        [self requestAlwaysAuthorization];
    }
    return self;
}

- (BOOL)isLocationSensingAvailable
{
    return [CLLocationManager locationServicesEnabled];
}

- (BOOL)isHeadingSensingAvailable {
    return [CLLocationManager headingAvailable];
}

#pragma mark start / stop sensing

- (void)startLocationSensing
{
    if ([self isLocationSensingAvailable])
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopLocationSensing
{
    if ([self isLocationSensingAvailable])
    {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)startHeadingSensing {
    if ([self isHeadingSensingAvailable]) {
        [self.locationManager startUpdatingHeading];
    }
}

- (void)stopHeadingSensing {
    if ([self isHeadingSensingAvailable]) {
        [self.locationManager stopUpdatingHeading];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        [self.delegate locationUpdateReceived:location];
    }
}

- (void)locationManager:(nonnull CLLocationManager *)manager didUpdateHeading:(nonnull CLHeading *)newHeading {
    [self.delegate headingUpdateRecieved:newHeading];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    if(!manager.heading) return YES; // Got nothing, We can assume we got to calibrate.
    else if(manager.heading.headingAccuracy < 0 ) return YES; // 0 means invalid heading, need to calibrate
    else if(manager.heading.headingAccuracy > 5 ) return YES; // 5 degrees is a small value correct for my needs, too.
    else return NO; // All is good. Compass is precise enough.
}

-(void)requestAlwaysAuthorization {
    if ([self.locationManager.class authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
}

@end
