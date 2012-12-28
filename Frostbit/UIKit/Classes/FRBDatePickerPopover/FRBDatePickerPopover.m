//
//  FRBDatePickerPopover.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBDatePickerPopover.h"


#pragma mark -
#pragma mark FRBDatePickerPopover private

@interface FRBDatePickerPopover()
{
    UIViewController *_contentViewController;
    UIDatePicker     *_datePicker;
}

@end


#pragma mark -
#pragma mark FRBDatePickerPopover implementation

@implementation FRBDatePickerPopover

#pragma mark -
#pragma mark properties

- (void) setTitle: (NSString *) title
{
    _contentViewController.navigationItem.title = title;
}


- (NSString *) title
{
    return _contentViewController.navigationItem.title;
}


- (void) setDate:(NSDate *)date
{
    _datePicker.date = date;
}


- (NSDate *) date
{
    return _datePicker.date;
}


- (void) setDatePickerMode: (UIDatePickerMode) datePickerMode
{
    _datePicker.datePickerMode = datePickerMode;
}


- (UIDatePickerMode) datePickerMode
{
    return _datePicker.datePickerMode;
}


#pragma mark -
#pragma mark initialization methods

- (id) init
{
    UIViewController *contentViewController = [UIViewController new];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController: contentViewController];

    self = [super initWithContentViewController: navigationController];
    
    if (self != nil)
    {
        _contentViewController = contentViewController;
        
        _datePicker                = [UIDatePicker new];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        [_datePicker addTarget: self
                        action: @selector(datePickerValueChanged:)
              forControlEvents: UIControlEventValueChanged];
        
        [contentViewController.view addSubview: _datePicker];
        contentViewController.contentSizeForViewInPopover = _datePicker.bounds.size;
    }
    return self;
}


#pragma mark -
#pragma mark actions

- (void) datePickerValueChanged: (id) sender
{
    if ([_dateDelegate respondsToSelector: @selector(FRBDatePickerPopover:didSelectDate:)])
    {
        [_dateDelegate FRBDatePickerPopover: self
                              didSelectDate: _datePicker.date];
    }
}


@end
