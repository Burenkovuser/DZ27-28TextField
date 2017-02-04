//
//  ViewController.m
//  DZ27-28TextFields
//
//  Created by Vasilii on 04.02.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(assign, nonatomic) int currentNumberOfField;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[self.mainTextField objectAtIndex:0] becomeFirstResponder];//фокус на первом поле и сразу появляетск клавиатура
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {//вызывается как только курсор ставится в textField, метод меняет активное поле по нажатию кнопки return
    
    if ([textField isEqual:[self.mainLabels objectAtIndex:self.currentNumberOfField]] && self.currentNumberOfField !=6) {//если поле меньше 6-го
        self.currentNumberOfField++;//переходим к следующему
        
        [[self.mainTextField objectAtIndex:self.currentNumberOfField] becomeFirstResponder];//становиться первым ответчиком (объект на котором фокус), он сейчас активет
    } else {
        [[self.mainTextField objectAtIndex:self.currentNumberOfField] resignFirstResponder];//клавиатура уезжает
    }
    
    return YES;
}

@end
