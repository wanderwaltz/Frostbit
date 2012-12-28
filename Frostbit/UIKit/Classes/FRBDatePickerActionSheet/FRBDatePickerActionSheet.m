//
//  FRBDatePickerActionSheet.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBDatePickerActionSheet.h"


#pragma mark -
#pragma mark FRBDatePickerActionSheet private

@interface FRBDatePickerActionSheet()<UIActionSheetDelegate>
@end


#pragma mark -
#pragma mark FRBDatePickerActionSheet implementation

@implementation FRBDatePickerActionSheet


#pragma mark -
#pragma mark initialization methods

- (id) initWithTitle: (NSString *) title
                date: (NSDate   *) date
              action: (FRBDatePickerSheetAction) action
{
    self = [super initWithTitle: title
                       delegate: self
              cancelButtonTitle: nil
         destructiveButtonTitle: nil
              otherButtonTitles: nil];
    
    if (self != nil)
    {
        self.action = action;
        [self createPickerViewWithDate: date];
    }
    return self;
}


#pragma mark -
#pragma mark private

- (void) createPickerViewWithDate: (NSDate *) date
{
    if (date == nil) date = [NSDate date];
    
    _datePicker                = [[UIDatePicker alloc] init];
    _datePicker.date           = date;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self addSubview: _datePicker];
}


#pragma mark -
#pragma mark UIActionSheet methods

- (void) showInView: (UIView *) view
{
    [super showInView: view];
    self.frame = CGRectMake(0.0, 117.0, 320.0, 483.0);
}


#pragma mark -
#pragma mark UIView methods

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    static const NSUInteger kSelectButtonIndex = 1;
    static const NSUInteger kCancelButtonIndex = 2;
    
    _datePicker.frame = CGRectMake(0.0, 40.0, 320.0, 216.0);
    
    NSArray *subviews = [self subviews];
    
    if (subviews.count > 0)
    {
        [subviews[kSelectButtonIndex]
         setFrame: CGRectMake(20.0, 266.0, 280.0, 46.0)];
    }
    
    
    if (subviews.count > 1)
    {
        [subviews[kCancelButtonIndex]
         setFrame: CGRectMake(20.0, 317.0, 280.0, 46.0)];
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate

      - (void) actionSheet: (UIActionSheet *) actionSheet
willDismissWithButtonIndex: (NSInteger)       buttonIndex
{
    if (_action)
    {
        NSDate *selectedDate = nil;
        
        if (buttonIndex != actionSheet.cancelButtonIndex)
            selectedDate = _datePicker.date;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _action(selectedDate);
        });
    }
}


@end
