//
//  RecentlyUpdatedViewController.m
//  mining iQ
//
//  Created by Admin on 10/02/17.
//  Copyright © 2017 Anirban. All rights reserved.
//

#import "RecentlyUpdatedViewController.h"
#import "Singelton.h"
#import "DefineHeader.pch"
#import <CoreData/CoreData.h>
#import "ProjectDetailViewController.h"

@interface RecentlyUpdatedViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *start;
    NSString *limit;
    UIView *spinnerView;
    UIActivityIndicatorView *spinner;
    NSMutableArray *newRecentlyUpdateAry;
    
}


@end

@implementation RecentlyUpdatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    start = @"0";
    limit = @"20";
    
    newRecentlyUpdateAry = [[NSMutableArray alloc] init];
    
    spinnerView = [[UIView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2 - 40, ([UIScreen mainScreen].bounds.size.height)/2 - 40, 80, 80)];
    spinnerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.9];
    spinnerView.layer.cornerRadius = 8.0f;
    spinnerView.clipsToBounds = YES;
    
    /////////// for loader view
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame = CGRectMake(round((spinnerView.frame.size.width - 25) / 2), round((spinnerView.frame.size.height - 25) / 2), 25, 25);
    spinner.color = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    [spinner startAnimating];
    [spinnerView addSubview:spinner];
    
    
    
    
    
    [self.view addSubview:spinnerView];
    spinnerView.hidden = YES;
    
    
    //loading all projetlist start
    NSMutableArray* temArray = [[NSMutableArray alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProjectListWithType"];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    temArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    arr_ProjectDetails = [temArray mutableCopy];

    for (NSDictionary *dic in arr_ProjectDetails)
    {
        if ([[dic valueForKey:@"recentlyupdatedproject"] boolValue]==1)
        {
            [newRecentlyUpdateAry addObject:dic];
           // NSLog(@"%@",[[newRecentlyUpdateAry objectAtIndex:0]valueForKey:@"projectname"]);
            
        }
    }
    
    if (newRecentlyUpdateAry.count == 0) {
         spinnerView.hidden = NO;
        UILabel *lbl_message=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, spinnerView.frame.origin.y+spinnerView.frame.size.height+5, 200, 21)];
        lbl_message.text=@"Fetching data....";
        lbl_message.textAlignment=NSTextAlignmentCenter;
        lbl_message.textColor=[UIColor blackColor];
       // lbl_message.backgroundColor=[UIColor redColor];
        [self.view addSubview:lbl_message];

    }

    
}
-(void)viewDidAppear:(BOOL)animated
{
    
      //  [self.recentlyUpdateTbl reloadData];
    
  //  [self getAllReminderListing:start limitVal:limit];
    
}
-(void)getAllReminderListing:(NSString *)startVal limitVal:(NSString *)limitVal{
    
    
    spinnerView.hidden = NO;
    NSString *userId= @"244";
    // NSString *userId= [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
    NSString *postUrlString=[NSString stringWithFormat:@"limit_start=%@&num_records=%@",startVal,limitVal];
    NSString *strLoginApi=[NSString stringWithFormat:@"%@%@",App_Domain_Url,recentlyUpdatedProjects];
    
    [[Singelton getInstance] jsonParseWithPostMethod:^(NSDictionary* testResult){
        
        NSLog(@"testResult..%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]);
        
        
        if ([[testResult valueForKey:@"success"] boolValue] == 1)
        {
            spinnerView.hidden = YES;
            newRecentlyUpdateAry = [[testResult objectForKey:@"details"] mutableCopy];
            if(newRecentlyUpdateAry.count < [limit intValue]){
                
                self.viewMrBtn.hidden = YES;
                
            }
            int tempStart = [start intValue] + 19;
            int tempLimit = [limit intValue] + 20;
            
            
            start = [NSString stringWithFormat:@"%d",tempStart];
            limit = [NSString stringWithFormat:@"%d",tempLimit];
            //
            [self.recentlyUpdateTbl reloadData];
            NSLog(@"url is : %lu",(unsigned long)newRecentlyUpdateAry.count);
            
        }
        else if ([[testResult valueForKey:@"success"] boolValue] == 0)
        {
            spinnerView.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong... please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } andString:strLoginApi andParam:postUrlString];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = (RecentlyUpdatedCell *)[tableView dequeueReusableCellWithIdentifier:@"RecentlyUpdatedCell"];
    
    if (indexPath.row % 2 == 0)
    {
        cell.cellBackView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.cellBackView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
    }
    NSLog(@"........%@",[[newRecentlyUpdateAry objectAtIndex:indexPath.row] valueForKey:@"projectname"]);
    
    
//    cell.projectNameLbl = [[newRecentlyUpdateAry objectAtIndex:indexPath.row] objectForKey:@"projectname"];
//    cell.dateLbl = [[newRecentlyUpdateAry objectAtIndex:indexPath.row] objectForKey:@"datemodified"];
    
    cell.projectNameLbl.text = [[newRecentlyUpdateAry objectAtIndex:indexPath.row] valueForKey:@"projectname"];
    cell.dateLbl.text = [[newRecentlyUpdateAry objectAtIndex:indexPath.row] valueForKey:@"modified"];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return newRecentlyUpdateAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 80)];
//    UIButton *viewMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 110, 35, 100, 35)];
//
//    return  footerView;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ProjectDetailViewController *projdetVC= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProjectDetailViewController"];
    //projdetVC.strID_Carry = [[newRecentlyUpdateAry objectAtIndex:indexPath.row] objectForKey:@"id"];
    projdetVC.dic_Carry=[newRecentlyUpdateAry objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:projdetVC animated:YES];
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



@end
