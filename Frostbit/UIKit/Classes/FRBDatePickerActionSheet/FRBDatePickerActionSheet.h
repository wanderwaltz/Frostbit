//
//  FRBDatePickerActionSheet.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "FRBUIKit.h"


#pragma mark -
#pragma mark Typedefs

typedef void (^FRBDatePickerSheetAction)(NSDate *date);


#pragma mark -
#pragma mark FRBDatePickerActionSheet interface

@interface FRBDatePickerActionSheet : UIActionSheet
@property (readonly, nonatomic) UIDatePicker *datePicker;
@property (copy,     nonatomic) FRBDatePickerSheetAction action;

- (id) initWithTitle: (NSString *) title
                date: (NSDate   *) date
              action: (FRBDatePickerSheetAction) action;

@end
