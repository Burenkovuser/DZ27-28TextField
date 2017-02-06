//
//  ViewController.h
//  DZ27-28TextFields
//
//  Created by Vasilii on 04.02.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property(strong, nonatomic) IBOutletCollection(UITextField) NSArray *mainTextField;//со строногом работает
@property(strong, nonatomic) IBOutletCollection(UILabel) NSArray *mainLabels;


@end

