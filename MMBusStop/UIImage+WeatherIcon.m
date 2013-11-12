//
//  UIImage+WeatherIcon.m
//  MMBusStop
//
//  Created by Kyle Mai on 10/9/13.
//  Copyright (c) 2013 Kyle Mai. All rights reserved.
//

#import "UIImage+WeatherIcon.h"

@implementation UIImage (WeatherIcon)

+ (UIImage *)sunnyWeatherIcon
{
    return [UIImage imageNamed:@"sunny100"];
}

+ (UIImage *)rainyWeatherIcon
{
    return [UIImage imageNamed:@"rainy100"];
}

+ (UIImage *)cloudyWeatherIcon
{
    return [UIImage imageNamed:@"cloudy100"];
}

+ (UIImage *)windyWeatherIcon
{
    return [UIImage imageNamed:@"windy100"];
}


@end
