//
//  MBEPickerController.m
//  MBEPickerController
//
//  Created by Mark Evans on 9/6/14.
//  Copyright (c) 2014 3Advance, LLC. All rights reserved.
//

#import "MBEPickerController.h"

@interface MBEPickerController ()
{
    NSDate *dateSelection;
    NSString *selection;
    BOOL isTime;
    int pos;
    IBOutlet UIButton *tintButton;
    UIView *bgView;
}
@end

@implementation MBEPickerController

- (id)init
{
    MBEPickerController* picker = [self initWithNibName:@"MBEPickerController" bundle:nil];
    
//    // Account for iOS 8 & Under
//    if ([UIDevice currentDevice].systemVersion.floatValue < 8)
//        vc.modalPresentationStyle = UIModalPresentationCurrentContext;
//    else
//        picker.modalPresentationStyle = UIModalPresentationCustom;
//    
//    return picker;
    
    
    return picker;
}


- (void)showInViewController:(UIViewController*)vc
{
    [vc.view endEditing:YES];
    //vc = ((UIWindow*)[[UIApplication sharedApplication].windows lastObject]).rootViewController;
    
    // Account for iOS 8 & Under
    if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
//        for (UIViewController *v in self.navigationController.viewControllers) {
//            v.modalPresentationStyle = UIModalPresentationCurrentContext;
//        }
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    else
        self.modalPresentationStyle = UIModalPresentationCustom;
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    bgView = [[UIView alloc] initWithFrame:screenRect];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.0;
    bgView.userInteractionEnabled = NO;
    
    [vc.view addSubview:bgView];
    
    [UIView animateWithDuration:0.3 animations:^() {
        bgView.alpha = 0.5;
    } completion:^(BOOL finished){}];
    
    
    [vc presentViewController:self animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_pickerTypeState) {
        case PickerTypeText:
            _pickerView.hidden = NO;
            _datePickerView.hidden = YES;
            break;
            
        case PickerTypeDate:
            _pickerView.hidden = YES;
            _datePickerView.hidden = NO;
            isTime = NO;
            _datePickerView.datePickerMode = UIDatePickerModeDate;
            break;
            
        case PickerTypeTime:
            _pickerView.hidden = YES;
            _datePickerView.hidden = NO;
            isTime = YES;
            _datePickerView.datePickerMode = UIDatePickerModeTime;
            break;
            
        case PickerTypeDateTime:
            _pickerView.hidden = YES;
            _datePickerView.hidden = NO;
            isTime = YES;
            _datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            break;
            
        default:
            break;
    }
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([UIDevice currentDevice].systemVersion.floatValue <= 7.1) {
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        CGRect toRect = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = toRect;
        [UIView animateWithDuration:0.4 animations:^() {self.view.alpha = 1; self.view.frame = rect;}
                         completion:^(BOOL finished){}];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIView animateWithDuration:0.3 animations:^() {
        bgView.alpha = 0.0;
    } completion:^(BOOL finished){}];
    
//    tintButton.backgroundColor = [UIColor clearColor];
//    tintButton.alpha = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)setDateSelection:(id)sender {
    
    UIDatePicker *picker = (UIDatePicker*)sender;
    if (picker != nil) {
        dateSelection = picker.date;
    }
    
}

#pragma mark - PickerView Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_pickerOptions != nil) {
        if (_pickerOptions.count > 0) {
            return _pickerOptions.count;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickerOptions != nil) {
        if (_pickerOptions.count > 0) {
            return _pickerOptions[row];
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_pickerOptions != nil) {
        if (_pickerOptions.count > 0) {
            selection = _pickerOptions[row];
            pos = (int)row;
        }
    }
}

#pragma mark - UI Methods

- (void)setupUI {
    
    pos = 0;
    
    if (_selectDate != nil) {
        if (_datePickerView != nil) {
            [_datePickerView setDate:_selectDate];
        }
    }
    
    if (_datePickerView != nil) {
        dateSelection = _datePickerView.date;
        [_datePickerView addTarget:self action:@selector(setDateSelection:) forControlEvents:UIControlEventValueChanged];
    }
    
    if (_pickerOptions != nil) {
        if (_pickerOptions.count > 0) {
            selection = _pickerOptions[0];
        }
    }
    
    if (_pickerTitle != nil) {
        if (_pickerTitle.length > 0) {
            _titleContainer.hidden = NO;
            _titleLabel.text = _pickerTitle;
        }
    }
    
    if (_selectOption != nil) {
        if(_selectOption.length > 0) {
            if (_pickerOptions != nil) {
                if (_pickerOptions.count > 0) {
                    for (NSString *s in _pickerOptions) {
                        if ([_selectOption isEqualToString:s]) {
                            if (_pickerView != nil)
                                selection = _pickerOptions[pos];
                            [_pickerView selectRow:pos inComponent:0 animated:YES];
                            break;
                        }
                        pos++;
                    }
                }
            }
        }
    }
    
    _selectButton.layer.cornerRadius = _cancelButton.layer.cornerRadius = _pickerContainer.layer.cornerRadius = _titleContainer.layer.cornerRadius = 10.0;
    
}

#pragma mark - IBAction Methods

- (IBAction)dismissPickerView {
    if (!self.isBeingDismissed || !self.isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:^{
            selection = nil;
            dateSelection = nil;
            NSLog(@"selection: %@", selection);
            NSLog(@"dateSelection: %@", dateSelection);
        }];
    }
}

- (IBAction)select:(id)sender {
    if (!self.isBeingDismissed || !self.isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (_pickerTypeState == PickerTypeText) {
                NSLog(@"selection: %@", selection);
                dispatch_async(dispatch_get_main_queue(), ^{
                    _optionSelected(selection);
                });
            } else {
                NSLog(@"dateSelection: %@", dateSelection);
                dispatch_async(dispatch_get_main_queue(), ^{
                    _dateSelected(dateSelection);
                });
            }
        }];
    }
}

- (IBAction)cancel:(id)sender {
    if (!self.isBeingDismissed || !self.isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:^{
            selection = nil;
            dateSelection = nil;
            NSLog(@"selection: %@", selection);
            NSLog(@"dateSelection: %@", dateSelection);
        }];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

@end
