//
//  FRBDatePickerPopover.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark FRBDatePickerPopoverDelegate protocol

@class FRBDatePickerPopover;

@protocol FRBDatePickerPopoverDateDelegate <NSObject>
@optional

- (void) FRBDatePickerPopover: (FRBDatePickerPopover *) popover
                didSelectDate: (NSDate *) date;

@end


#pragma mark -
#pragma mark FRBDatePickerPopover interface

@interface FRBDatePickerPopover : UIPopoverController

@property (weak, nonatomic) id<FRBDatePickerPopoverDateDelegate> dateDelegate;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate   *date;

@property (assign, nonatomic) UIDatePickerMode datePickerMode;


@end
