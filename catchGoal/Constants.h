//
//  Constants.h
//  PingAndCall
//
//  Created by Олег Панфёров on 12/22/14.
//  Copyright (c) 2014 Олег Панфёров. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CURRENCY_SYMBOL [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define IS_IPHONE6PLUS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

extern NSString *const kExampleConstant;

@interface Constants : NSObject

@end
