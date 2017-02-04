//
//  ViewController.h
//  DZ27-28TextFields
//
//  Created by Vasilii on 04.02.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//@property(weak, nonatomic) IBOutlet UITextField* firstNameField;
//@property(weak, nonatomic) IBOutlet UITextField* lastNameField;
@property(weak, nonatomic) IBOutletCollection(UITextField) NSArray *mainTextField;
@property(weak, nonatomic) IBOutletCollection(UILabel) NSArray *mainLabels;


@end

