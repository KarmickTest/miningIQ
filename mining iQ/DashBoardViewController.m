//
//  DashBoardViewController.m
//  mining iQ
//
//  Created by Anirban on 06/02/17.
//  Copyright © 2017 Anirban. All rights reserved.
//

#import "DashBoardViewController.h"
#import "dashBoardCell.h"
#import "NewProjectsViewController.h"
#import "MyRemindersViewController.h"
#import "ProjectSearchViewController.h"
#import "NewsFeedViewController.h"
#import "MenuView.h"
#import "Global_Header.h"

#define FULLHEIGHT [UIScreen mainScreen].bounds.size.height
#define FULLWIDTH  [UIScreen mainScreen].bounds.size.width
#define MENUHEADERHEIGHT 64.0f
#define ANIMATION_DURATION	0.3f


@interface DashBoardViewController ()<UITableViewDelegate, UITableViewDataSource,MenuViewDelegate>{

    NSArray *nameArr;
    NSArray *imgArr;
     MenuView *objMenuView;
}

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    self.menu = [[VKSideMenu alloc] initWithSize:220.0f andDirection:VKSideMenuDirectionFromLeft];
//    self.menu.dataSource = self;
//    self.menu.delegate   = self;
//    [self.menu addSwipeGestureRecognition:self.view];
    
    
    nameArr = [NSArray arrayWithObjects:@"Total Phases",@"New Projects",@"Recently Updated",@"Project Search",@"My Reminders",@"News Feed",nil];
    imgArr = [NSArray arrayWithObjects:@"totalPhase",@"newproject",@"recentlyUpdate",@"projectSearch",@"myRimdrs", @"newsfeed",nil];
    objMenuView = [[MenuView alloc] initWithFrame:CGRectMake(-FULLWIDTH, 0, FULLWIDTH, FULLHEIGHT+MENUHEADERHEIGHT)];
    objMenuView.DelegateMenu = self;
    objMenuView.isMenuopen = FALSE;
    [self.view addSubview:objMenuView];
    objMenuView.menuWidth = FULLWIDTH;
    
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [objMenuView setUserInteractionEnabled:YES];
    [objMenuView addGestureRecognizer:pangesture];
}
- (IBAction)openMenu:(id)sender {
    [self drawerMenuOpenClose];
   
}
-(void)TaponcellWithIndex:(NSInteger)Index WithTitle:(NSString *)Title{
    if (Index==0) {
        //[objMenuView removeFromSuperview];
    }
    else if (Index==1){
        [objMenuView removeFromSuperview];
       
    }
    else if (Index==2){
        [objMenuView removeFromSuperview];
          }
    else if (Index==3){
        [objMenuView removeFromSuperview];
     
    }
    else if (Index==4){
        [objMenuView removeFromSuperview];
       
        
    }
    else if (Index==5){
        [objMenuView removeFromSuperview];
     
        
    }
    else if (Index==6){
        [objMenuView removeFromSuperview];
        
        
    }
    else if (Index==7){
        [objMenuView removeFromSuperview];
       
    }
    else if (Index==8){
        [objMenuView removeFromSuperview];
     
           }
    else{
        [self drawerMenuOpenClose];
    }
    
}
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        objMenuView.objMenuViewFrame = objMenuView.frame;
        objMenuView.menuWasOpenAtPanBegin = objMenuView.isMenuopen;
        
    }
    CGPoint translation = [panRecognizer translationInView:panRecognizer.view];
    CGRect frame = objMenuView.objMenuViewFrame;
    CGFloat contentViewMinX = [self contentViewMinX];
    if (objMenuView.slideDirection == NVSlideMenuControllerSlideFromRightToLeft21)
    {
        frame.origin.x += translation.x;
        
        if (frame.origin.x < contentViewMinX)
            frame.origin.x = contentViewMinX;
        else if (frame.origin.x > 0)
            frame.origin.x = 0;
    }
    else
    {
        frame.origin.x += translation.x;
        if (frame.origin.x < contentViewMinX)
            frame.origin.x = contentViewMinX;
        else if (frame.origin.x > 0)
            frame.origin.x = 0;
    }
    
    panRecognizer.view.frame = frame;
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint velocity = [panRecognizer velocityInView:panRecognizer.view];
        CGFloat distance = 0;
        NSTimeInterval animationDuration = 0;
        
        BOOL close = NO;
        if (objMenuView.slideDirection == NVSlideMenuControllerSlideFromRightToLeft21)
            close = (velocity.x < 0);
        else
            close = (velocity.x > 0);
        
        if (close) // Close
        {
            // Compute animation duration
            
            distance = frame.origin.x;
            animationDuration = fabs(distance / velocity.x);
            if (animationDuration > ANIMATION_DURATION)
                animationDuration = ANIMATION_DURATION;
            
            frame.origin.x = contentViewMinX;
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                objMenuView.frame = frame;
            } completion:^(BOOL finished) {
                if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                    [self setNeedsStatusBarAppearanceUpdate];
                objMenuView.isMenuopen=NO;
                
                
                
            }];
        }
        else // Open
        {
            distance = fabs(contentViewMinX - frame.origin.x);
            animationDuration = fabs(distance / velocity.x);
            if (animationDuration > ANIMATION_DURATION)
                animationDuration = ANIMATION_DURATION;
            
            frame.origin.x = 0;
            
            
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                objMenuView.frame = frame;
            } completion:^(BOOL finished)
             {
                 objMenuView.isMenuopen=YES;
             }];
        }
        
        objMenuView.objMenuViewFrame = frame;
    }
    
}


- (CGFloat)contentViewMinX
{
    CGFloat minX = 0;
    
    if ([objMenuView isContentViewHidden])
    {
        if (objMenuView.slideDirection == NVSlideMenuControllerSlideFromRightToLeft21)
            minX = CGRectGetWidth(self.view.bounds);
        else
            minX = -CGRectGetWidth(self.view.bounds);
    }
    else
    {
        if (objMenuView.slideDirection == NVSlideMenuControllerSlideFromRightToLeft21)
            minX = -objMenuView.menuWidth;
        else
            minX = objMenuView.menuWidth;
    }
    
    return minX;
}


- (void)drawerMenuOpenClose{
    CGRect framescreen=objMenuView.frame;
    if (objMenuView.isMenuopen)
    {
        framescreen.origin.x=-(FULLWIDTH);
    }
    else
    {
        framescreen.origin.x=0;
    }
    
    [UIView animateWithDuration:.2f animations:^{
        [objMenuView setFrame:framescreen];
    }
                     completion:^(BOOL finish)
     {
         if (objMenuView.isMenuopen)
         {
             objMenuView.isMenuopen=FALSE;
         }
         else
         {
             objMenuView.isMenuopen=TRUE;
         }
     }];
    
}


# pragma mark tableview Delegates and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    dashBoardCell *cell =[tableView dequeueReusableCellWithIdentifier:@"dashBoardCell"];
    cell.titleLbl.text = [nameArr objectAtIndex:indexPath.row];
    cell.imgView.image = [UIImage imageNamed:[imgArr objectAtIndex:indexPath.row]];
    
    cell.backView.layer.cornerRadius = 1.0f;
    cell.backView.clipsToBounds = YES;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",(long)indexPath.row);
    
    if(indexPath.row == 1){
        
        NewProjectsViewController *dashBoard=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewProjectsViewController"];
        [self.navigationController pushViewController:dashBoard animated:YES];
        
    }
    
    else if (indexPath.row == 2){
        
        RecentlyUpdatedViewController *RemindersView=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecentlyUpdatedViewController"];
        [self.navigationController pushViewController:RemindersView animated:YES];
        
        
    }

    else if (indexPath.row == 3){
        
        ProjectSearchViewController *RemindersView=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProjectSearchViewController"];
        [self.navigationController pushViewController:RemindersView animated:YES];
        
        
    }
    else if (indexPath.row == 4){
        
        MyRemindersViewController *RemindersView=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyRemindersViewController"];
        [self.navigationController pushViewController:RemindersView animated:YES];
        
        
    }
    else if (indexPath.row == 5){
        
        NewsFeedViewController *RemindersView=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsFeedViewController"];
        [self.navigationController pushViewController:RemindersView animated:YES];
        
        
    }
    else if (indexPath.row == 0){
        
        ProjectPhaseViewController *RemindersView=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProjectPhaseViewController"];
        [self.navigationController pushViewController:RemindersView animated:YES];
        
        
    }


    
    
    
}







//# pragma mark slideMenu Delegates and Datasource
//
//
//
//-(NSInteger)numberOfSectionsInSideMenu:(VKSideMenu *)sideMenu
//{
//    return 1;
//}
//
//-(NSInteger)sideMenu:(VKSideMenu *)sideMenu numberOfRowsInSection:(NSInteger)section
//{
//    return 4;
//}
//
//-(VKSideMenuItem *)sideMenu:(VKSideMenu *)sideMenu itemForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    VKSideMenuItem *item = [VKSideMenuItem new];
//    
//    switch (indexPath.row)
//    {
//        case 0:
//            item.title = @"Profile";
//            item.icon  = [UIImage imageNamed:@"ic_option_1"];
//            break;
//            
//        case 1:
//            item.title = @"Messages";
//            item.icon  = [UIImage imageNamed:@"ic_option_2"];
//            break;
//            
//        case 2:
//            item.title = @"Cart";
//            item.icon  = [UIImage imageNamed:@"ic_option_3"];
//            break;
//            
//        case 3:
//            item.title = @"Settings";
//            item.icon  = [UIImage imageNamed:@"ic_option_4"];
//            break;
//            
//        default:
//            break;
//    }
//    
//    return item;
//}
//-(void)sideMenu:(VKSideMenu *)sideMenu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"SideMenu didSelectRow: %@", indexPath);
//}
//
//-(void)sideMenuDidShow:(VKSideMenu *)sideMenu
//{
//    NSString *menu = @"";
//    
//    if (sideMenu == self.menu)
//        menu = @"LEFT";
//    else if (sideMenu == self.menu)
//        menu = @"TOP";
//    else if (sideMenu == self.menu)
//        menu = @"RIGHT";
//    else if (sideMenu == self.menu)
//        menu = @"RIGHT";
//    
//    NSLog(@"%@ VKSideMenue did show", menu);
//}
//
//-(void)sideMenuDidHide:(VKSideMenu *)sideMenu
//{
//    NSString *menu = @"";
//    
//    if (sideMenu == self.menu)
//        menu = @"LEFT";
//    else if (sideMenu == self.menu)
//        menu = @"TOP";
//    else if (sideMenu == self.menu)
//        menu = @"RIGHT";
//    else if (sideMenu == self.menu)
//        menu = @"RIGHT";
//    
//    NSLog(@"%@ VKSideMenue did hide", menu);
//}
//
//-(NSString *)sideMenu:(VKSideMenu *)sideMenu titleForHeaderInSection:(NSInteger)section
//{
//    if (sideMenu == self.menu)
//        return nil;
//    
//    switch (section)
//    {
//        case 0:
//            return @"Profile";
//            break;
//            
//        case 1:
//            return @"Actions";
//            break;
//            
//        default:
//            return nil;
//            break;
//    }
//}
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

@end