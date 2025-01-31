//
//  ViewController.m
//  mining iQ
//
//  Created by Anirban on 03/02/17.
//  Copyright © 2017 Anirban. All rights reserved.
//

#import "ViewController.h"
#import "DashBoardViewController.h"
#import "Singelton.h"
#import "DefineHeader.pch"
#import <CoreData/CoreData.h>
#import "Reachability.h"

@interface ViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    BOOL showPwdBool;
    UIView *backgroundView, *spinnerView;
    UIActivityIndicatorView *spinner;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    spinnerView = [[UIView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2 - 40, ([UIScreen mainScreen].bounds.size.height)/2 - 40, 80, 80)];
    spinnerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.9];
    spinnerView.layer.cornerRadius = 8.0f;
    spinnerView.clipsToBounds = YES;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame = CGRectMake(round((spinnerView.frame.size.width - 25) / 2), round((spinnerView.frame.size.height - 25) / 2), 25, 25);
    spinner.color = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    
    [spinner startAnimating];
    
    [spinnerView addSubview:spinner];
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    [backgroundView addSubview:spinnerView];
    
    [self.view addSubview:backgroundView];
    backgroundView.hidden = YES;
    
    showPwdBool = true;
    
    [self.userNameTxt setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.userNameTxt.leftView = paddingView;
    self.userNameTxt.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTxt.delegate=self;
    
    [self.passwordTxt setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.passwordTxt.leftView = paddingView1;
    self.passwordTxt.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTxt.delegate=self;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.passwordTxt.rightView = paddingView2;
    self.passwordTxt.rightViewMode = UITextFieldViewModeAlways;
    
    self.loginBtn = [self roundRadious:self.loginBtn radius:2];
    self.registerBtn = [self roundRadious:self.registerBtn radius:2];
    self.forgotPwdBtn = [self roundRadious:self.forgotPwdBtn radius:2];
    
    self.userNameTxt = [self roundRadiousTxt:self.userNameTxt radius:2];
    self.passwordTxt = [self roundRadiousTxt:self.passwordTxt radius:2];
    
    
    //loading all projetlist start
    NSMutableArray* temArray = [[NSMutableArray alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProjectListWithType"];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    temArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    _arr_ProjectDetails = [temArray mutableCopy];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%lu",(unsigned long)_arr_ProjectDetails.count ] forKey:@"limit"];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
//    if(_arr_ProjectDetails.count == 0){
//        [self getAllProjects];
//    }
    
    
}
-(UIButton *)roundRadious:(UIButton *)button radius:(NSInteger)radius
{
    button.layer.cornerRadius = 2.0f;
    button.clipsToBounds = YES;
    
    return button;
}

- (IBAction)showPwdAction:(id)sender {
    
    if (showPwdBool == true)
    {
        [self.showPwdBtn setImage:[UIImage imageNamed:@"Invisible-25"] forState:UIControlStateNormal];
        self.passwordTxt.secureTextEntry = NO;
        showPwdBool = false;
    }
    else if (showPwdBool == false)
    {
        [self.showPwdBtn setImage:[UIImage imageNamed:@"Visible-25"] forState:UIControlStateNormal];
        self.passwordTxt.secureTextEntry = YES;
        showPwdBool = true;
    }
}


-(UITextField *)roundRadiousTxt:(UITextField *)textField radius:(NSInteger)radius
{
    textField.layer.cornerRadius = 2.0f;
    textField.clipsToBounds = YES;
    return textField;
}

- (IBAction)goToDashboard:(id)sender {
    
    if ([self Emailtest:self.userNameTxt.text] == true)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter a valid email id." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([self TarminateWhiteSpace:self.passwordTxt.text].length <= 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Password must be of six charecters." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        self.loginBtn.userInteractionEnabled = NO;
        [self sendLoginDataInPost];
        [self startTimedTask];
    }
    
    
//    DashBoardViewController *dashBoard=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DashBoardViewController"];
//    [self.navigationController pushViewController:dashBoard animated:YES];
}


- (void)startTimedTask
{
    NSTimer *SecondTimer = [NSTimer scheduledTimerWithTimeInterval:7200.0 target:self selector:@selector(performBackgroundTask) userInfo:nil repeats:YES];
}

- (void)performBackgroundTask
{
    
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
        {
            //connection unavailable
        }
        else
        {
            //connection available
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Do background work
                
                //loading all projetlist start
                NSMutableArray* temArray = [[NSMutableArray alloc] init];
                NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProjectListWithType"];
                [fetchRequest setReturnsObjectsAsFaults:NO];
                temArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                _arr_ProjectDetails = [temArray mutableCopy];
                
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%lu",(unsigned long)_arr_ProjectDetails.count ] forKey:@"limit"];
                [self getAllProjects];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Update UI
                    
                    
                });
            });

        }
    
   }




-(void)sendLoginDataInPost
{
    [self.userNameTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
    
    backgroundView.hidden = NO;
    
    NSString *postUrlString=[NSString stringWithFormat:@"email=%@&password=%@&deviceType=%@&deviceId=%@",self.userNameTxt.text,self.passwordTxt.text,@"iOS",[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"]];
    
    NSLog(@"url is : %@",postUrlString);
    
    NSString *strLoginApi=[NSString stringWithFormat:@"%@%@",App_Domain_Url,Login];
    
    [[Singelton getInstance] jsonParseWithPostMethod:^(NSDictionary* testResult){
        
        backgroundView.hidden = YES;
        self.loginBtn.userInteractionEnabled = YES;
        
        if ([[testResult valueForKey:@"success"] boolValue] == 1)
        {
            
            
          //  NSLog(@"*******%lu", (unsigned long)self.arr_ProjectDetails.count);
            [[NSUserDefaults standardUserDefaults] setValue:[[testResult valueForKey:@"details"] valueForKey:@"total_projects"] forKey:@"total_projects"];
            
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
            dispatch_async(queue, ^{
            
                // Perform async operation
                // Call your method/function here
                // Example:
                // NSString *result = [anObject calculateSomething];
                
                
            //    [self getAllProjects];
                if(_arr_ProjectDetails.count == 0){
                    [self getAllProjects];
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // Update UI
                    // Example:
                    // self.myLabel.text = result;
                    
                    [[Singelton getInstance] saveDefaults:testResult];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[[testResult valueForKey:@"details"] valueForKey:@"user_id"] forKey:@"user_id"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    DashBoardViewController *dashBoard=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DashBoardViewController"];
                    
                    CATransition* transition = [CATransition animation];
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                    transition.duration = 0.7f;
                    transition.type =  @"rippleEffect";
                    [self.navigationController.view.layer removeAllAnimations];
                    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                    
                    [self.navigationController pushViewController:dashBoard animated:YES];
                    
                    
                    
                    //loading all projetlist start
                    NSMutableArray* temArray = [[NSMutableArray alloc] init];
                    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProjectListWithType"];
                    [fetchRequest setReturnsObjectsAsFaults:NO];
                    temArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                    _arr_ProjectDetails = [temArray mutableCopy];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%lu",(unsigned long)_arr_ProjectDetails.count ] forKey:@"limit"];
                    
                    
                });
            });
            
            
        }
        else if ([[testResult valueForKey:@"success"] boolValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong... please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        
    } andString:strLoginApi andParam:postUrlString];
}
-(void)getAllProjects
{
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"limit"]);
    
    spinnerView.hidden = NO;
  //  NSString *userId=@"2311";
    NSString *userId= [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    NSString *postUrlString=[NSString stringWithFormat:@"userid=%@&limit_start=%@&num_records=200&datetime=%@&localtimezone=%@",userId,[[NSUserDefaults standardUserDefaults] valueForKey:@"limit"],@"",@"",nil];
    
    NSLog(@"url is : %@",postUrlString);
    // getallProjects
    
    NSString *strLoginApi=[NSString stringWithFormat:@"%@%@",App_Domain_Url,getAllProjectListWithType];
    
    [[Singelton getInstance] jsonParseWithPostMethod:^(NSDictionary* testResult){
        
        
        if ([[testResult valueForKey:@"success"] boolValue] == 1)
        {
            spinnerView.hidden = YES;
            
           // if(_arr_ProjectDetails.count == 0)
            if([[testResult valueForKey:@"details"] count] > 0){
                
               // _arr_ProjectDetails=[[testResult valueForKey:@"details"] mutableCopy];
                NSMutableArray *newArr_projectDetails=[[NSMutableArray alloc]init];
                newArr_projectDetails=[[testResult valueForKey:@"details"] mutableCopy];
                [self saveDataInCoreData:newArr_projectDetails];
                
               // [self saveDataInCoreData:_arr_ProjectDetails];
            }
            
            
        }
        else if ([[testResult valueForKey:@"success"] boolValue] == 0)
        {
            spinnerView.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong... please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        
    } andString:strLoginApi andParam:postUrlString];
}

- (void)saveDataInCoreData:(NSMutableArray *)arrayOfData {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object  ProjectDetails
    
    NSError *error1;
    
    
    NSLog(@"****%lu",(unsigned long)arrayOfData.count);
    
    for(int i=0; i<arrayOfData.count; i++){
        
        
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectListWithType" inManagedObjectContext:context];
        
        
        
        [newDevice setValue:NULL_TO_NIL([[arrayOfData objectAtIndex:i] objectForKey:@"created"]) forKey:@"created"];
        
        
        
        [newDevice setValue:NULL_TO_NIL([[arrayOfData objectAtIndex:i] objectForKey:@"modified"]) forKey:@"modified"];
        
         [newDevice setValue:NULL_TO_NIL([[arrayOfData objectAtIndex:i] objectForKey:@"newproject"]) forKey:@"newproject"];
        
         [newDevice setValue:NULL_TO_NIL([[arrayOfData objectAtIndex:i] objectForKey:@"others"]) forKey:@"others"];
        
        
        
        [newDevice setValue:NULL_TO_NIL([[arrayOfData objectAtIndex:i] objectForKey:@"projectid"]) forKey:@"projectid"];
        
        [newDevice setValue:NULL_TO_NIL([[arrayOfData objectAtIndex:i] objectForKey:@"projectname"]) forKey:@"projectname"];
        
        [newDevice setValue:NULL_TO_NIL([[arrayOfData objectAtIndex:i] objectForKey:@"projectofinterest"]) forKey:@"projectofinterest"];
        
        
        
        [newDevice setValue:NULL_TO_NIL([[arrayOfData objectAtIndex:i] objectForKey:@"recentlyupdatedproject"]) forKey:@"recentlyupdatedproject"];
        
        
        
        // ======
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[[arrayOfData objectAtIndex:i] objectForKey:@"projectscope"]
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error1];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        
        
        
        [newDevice setValue:jsonString forKey:@"projectscope"];
        
        // ===========================
        
        NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:[[arrayOfData objectAtIndex:i] objectForKey:@"commentary"]
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error1];
        NSString *jsonString1 = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];

        

        [newDevice setValue:jsonString1 forKey:@"commentary"];
        
        // =====================
        
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:[[arrayOfData objectAtIndex:i] objectForKey:@"reminders"]
                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                              error:&error1];
        NSString *jsonString2 = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        

        

        [newDevice setValue:jsonString2 forKey:@"reminders"];
        
        // ============ =====
        
        NSData *jsonData3 = [NSJSONSerialization dataWithJSONObject:[[arrayOfData objectAtIndex:i] objectForKey:@"mineowners"]
                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                              error:&error1];
        NSString *jsonString3 = [[NSString alloc] initWithData:jsonData3 encoding:NSUTF8StringEncoding];

        

        [newDevice setValue:jsonString3 forKey:@"mineowners"];
        
        // ============ = =================

        NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:[[arrayOfData objectAtIndex:i] objectForKey:@"projectsuppliers"]
                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                              error:&error1];
        NSString *jsonString4 = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
        
        [newDevice setValue:jsonString4 forKey:@"projectsuppliers"];
        
        // ========================================
        
        NSData *jsonData5 = [NSJSONSerialization dataWithJSONObject:[[arrayOfData objectAtIndex:i] objectForKey:@"projectsuppliers"]
                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                              error:&error1];
        NSString *jsonString5 = [[NSString alloc] initWithData:jsonData5 encoding:NSUTF8StringEncoding];
        
        
        [newDevice setValue:jsonString5 forKey:@"projectengineers"];
        
        // =============================== =======
    }
    
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}

-(NSString *)TarminateWhiteSpace:(NSString *)Str
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [Str stringByTrimmingCharactersInSet:whitespace];
    return trimmed;
}


-(BOOL)Emailtest:(NSString *)Email
{
    NSString *emailRegex = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    NSRange aRange;
    
    if([emailTest evaluateWithObject:Email]) {
        
        aRange = [Email rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [Email length])];
        
        NSInteger indexOfDot = aRange.location;
        
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        
        if(aRange.location != NSNotFound) {
            
            NSString *topLevelDomain = [Email substringFromIndex:indexOfDot];
            
            topLevelDomain = [topLevelDomain lowercaseString];
            
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            
            NSSet *TLD;
            
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                
                return false;
                
            }
            
            /*else {
             
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             
             }*/
            
        }
    }
    return true;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)tapHighlight:(UIButton *)sender {
    
    if (sender.tag == 1)
    {
        [sender setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:11.0f/255.0f green:145.0f/255.0f blue:68.0f/255.0f alpha:1]] forState:UIControlStateHighlighted];
    }
    else if (sender.tag == 2)
    {
        [sender setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.0f/255.0f green:145.0f/255.0f blue:239.0f/255.0f alpha:1]] forState:UIControlStateHighlighted];
    }
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
