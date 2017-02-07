//
//  ViewController.m
//  DZ27-28TextFields
//
//  Created by Vasilii on 04.02.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@property(assign, nonatomic) int currentNumberOfField;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   for (UITextField *field in self.mainTextField) {
     field.delegate = self;
   }

    
    [[self.mainTextField objectAtIndex:0] becomeFirstResponder];//фокус на первом поле и сразу появляетск клавиатура
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setStandartLabels:(UITextField*) textField withConter:(int) counter {//метод ставит лейблы по умолчанию, если в соответсвующий textfield ничего не написано, т.е. длина текста равна 0
    
    if ([textField.text length] == 0) {
        switch (counter) {
            case 0:
                [[self.mainLabels objectAtIndex:0] setText:@"Name"];
                break;
            case 1:
                [[self.mainLabels objectAtIndex:1] setText:@"Lastname"];
                break;
            case 2:
                [[self.mainLabels objectAtIndex:2] setText:@"Login"];
                break;
            case 3:
                [[self.mainLabels objectAtIndex:3] setText:@"Pasword"];
                break;
            case 4:
                [[self.mainLabels objectAtIndex:4] setText:@"Age"];
                break;
            case 5:
                [[self.mainLabels objectAtIndex:5] setText:@"Phone"];
                break;
            case 6:
                [[self.mainLabels objectAtIndex:6] setText:@"E-mail"];
                break;
                
            default:
                break;
        }
    }
}

# pragma mark - UITextFieldDelegate
/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField {//вызывается как только курсор ставится в textField, метод меняет активное поле по нажатию кнопки return
    
    if ([textField isEqual:[self.mainLabels objectAtIndex:self.currentNumberOfField]] && self.currentNumberOfField != 6) {//если поле меньше 6-го
        self.currentNumberOfField++;//переходим к следующему
        
        [[self.mainTextField objectAtIndex:self.currentNumberOfField] becomeFirstResponder];//становиться первым ответчиком (объект на котором фокус), он сейчас активет
    } else {
        [[self.mainTextField objectAtIndex:self.currentNumberOfField] resignFirstResponder];//клавиатура уезжает
    }
    
    return YES;
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.mainTextField.lastObject]) {
        [textField resignFirstResponder];
    }else{
        //[[self.mainTextField objectAtIndex:self.currentNumberOfField] resignFirstResponder];//клавиатура уезжает
        [[self.mainTextField objectAtIndex:[self.mainTextField indexOfObject:textField] + 1] becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField { // метод запрещает редактирование
    self.currentNumberOfField = (int)[self.mainTextField indexOfObject:textField]; // индекс поля в массиве по которому кликнули
    for (int i = 0; i < [self.mainTextField count]; i++) {
        if ([[[self.mainTextField objectAtIndex:i]text] length] == 0) {
            
            [self setStandartLabels:[self.mainTextField objectAtIndex:i] withConter:i];
        }
 
    }
 return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {//метод вызывается при нажатии clear button
    textField.text = @"";
    [self setStandartLabels:textField withConter:self.currentNumberOfField];
    //так же выставляет умолчание
    return NO;
}

//проверяю на ошибку
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {//вызывается перед тем как мы добавляем символ
    
    
    if ([textField isEqual:[self.mainTextField objectAtIndex:5]]) {
        int i = (int)[self.mainTextField indexOfObject:textField];
        
        NSString* checkSring = [textField.text stringByAppendingString:string];
        if ([string length] != 1) {
            checkSring = [checkSring substringToIndex:[checkSring length] -1];
        }
        NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];//все отличное от цифр чтобы не поподало в набор
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
        
        if ([components count] > 1) {
            return NO;
        }
        NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];//создаем строку
        
        //+XX (XXX) XXX-XXXX
        
        NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];//компоненты при разделении
        
        newString = [validComponents componentsJoinedByString:@""];//соеденяем пустым символом
        
        // XXXXXXXXXXXX
        NSMutableString* resultString = [NSMutableString string];
        
        static const int localNumberMaxLength = 7;//создаем константу для общей длины
        static const int areaCodeMaxLength = 3;
        static const int countryCodeMaxLength = 3;
        // Делаем локальный номер (ХХХ-ХХХХ)
        NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);//для номера
        
        if (localNumberLength > 0) {
            
            NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
            
            [resultString appendString:number];//добавляем в наш результат
            
            if ([resultString length] > 3) {//если больше 3 цифр ставим разделитель
                [resultString insertString:@"-" atIndex:3];
            }
            
        }
        //делаем номер региона (ХХХ)
        if ([newString length] > localNumberMaxLength) {//для месного номера
            
            NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
            
            NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
            
            NSString* area = [newString substringWithRange:areaRange];
            
            area = [NSString stringWithFormat:@"(%@) ", area];//добавляем скобки
            
            [resultString insertString:area atIndex:0];
        }
        //Делаем номер страны (+ХХХ)
        if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {//для кода страны
            
            NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
            
            NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
            
            NSString* countryCode = [newString substringWithRange:countryCodeRange];
            
            countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
            
            [resultString insertString:countryCode atIndex:0];
        }
        if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
            return NO;
        }
        textField.text = resultString;
        
        [[self.mainTextField objectAtIndex:i] setText:resultString];
    
    return NO;
}

    
    else if ([textField isEqual:[self.mainTextField objectAtIndex:6]]) {
    
        int i = (int)[self.mainTextField indexOfObject:textField];
        
        NSString* checkSring = [textField.text stringByAppendingString:string];
        if ([string length] != 1) {
            checkSring = [checkSring substringToIndex:[checkSring length] -1];
        }
        NSCharacterSet* aSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];//набор с символом @
        NSCharacterSet* illegatSet = [NSCharacterSet characterSetWithCharactersInString:@" !#$%^&*()+={}[]№:;?/|~`"];
        NSArray* atCoomponents = [checkSring componentsSeparatedByCharactersInSet:aSet];
        NSArray* illegatComponents = [ checkSring componentsSeparatedByCharactersInSet:illegatSet];
        NSLog(@"illegatCompontns - %@", illegatSet);
        if ([atCoomponents count] > 2 || [illegatComponents count] > 1) {//собака вводится только один раз
            
            return NO;
        }
        [[self.mainLabels objectAtIndex:i] setText:checkSring];
        
        return [checkSring length] <= 19;
    } else {
        int i = (int)[self.mainTextField indexOfObject:textField];
        
        NSString* checkSring = [textField.text stringByAppendingString:string];
        
        if ([string length] != 1) {// условие удаление символа
            checkSring = [checkSring substringToIndex:[checkSring length] - 1];
        }
        [[self.mainLabels objectAtIndex:i] setText:checkSring];
        
        return YES;
    }

}

@end
