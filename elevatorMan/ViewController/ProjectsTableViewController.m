//
//  ProjectsTableViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "ProjectsTableViewController.h"

#import "BuildingsViewController.h"
#import "UIView+CornerRadius.h"

#pragma mark - ProjectsCell

@interface ProjectsCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIView *backColorView;
@property (nonatomic, retain) IBOutlet UILabel *projectTtle;

@end


@implementation ProjectsCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [_backColorView clipCornerWithTopLeft:5 andTopRight:5 andBottomLeft:0 andBottomRight:0];
}

//根据index.row的值%3来设置背景图片、背景颜色和文字颜色
- (void)setCellContent:(NSInteger)index
{
    switch (index % 3)
    {
        case 0:
        {

            self.projectTtle.textColor = UIColorFromRGB(0xfffbd075);
            self.backColorView.backgroundColor = UIColorFromRGB(0xfffbd075);
            [self.backgroundImageView setImage:[UIImage imageNamed:@"icon_project_1.png"]];
            break;

        }

        case 1:
        {
            self.projectTtle.textColor = UIColorFromRGB(0xff99cdff);;
            self.backColorView.backgroundColor = UIColorFromRGB(0xff99cdff);
            [self.backgroundImageView setImage:[UIImage imageNamed:@"icon_project_2.png"]];
            break;

        }
        case 2:
        {
            self.projectTtle.textColor = UIColorFromRGB(0xffcacd96);;
            self.backColorView.backgroundColor = UIColorFromRGB(0xffcacd96);
            [self.backgroundImageView setImage:[UIImage imageNamed:@"icon_project_3.png"]];
            break;

        }


        default:
            break;
    }


}


@end


#pragma mark - ProjectsTableViewController

@interface ProjectsTableViewController ()


@property (nonatomic, strong) NSArray *ProjectList;


@end

@implementation ProjectsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"项目"];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getProjectsList];
}

- (void)initView
{
    self.tableView.backgroundColor = RGB(@"#F1F1F1");
}

- (void)getProjectsList
{

    __weak ProjectsTableViewController *weakSelf = self;
    //请求
    [[HttpClient sharedClient] post:@"getElevatorList" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                weakSelf.ProjectList = [responseObject objectForKey:@"body"];
                                [weakSelf.tableView reloadData];
                            }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.ProjectList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectsCell" forIndexPath:indexPath];

    cell.projectTtle.text = [[self.ProjectList objectAtIndex:indexPath.row] objectForKey:@"name"];

    [cell setCellContent:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"buildingsViewController"];
    controller.buildingArray = [[self.ProjectList objectAtIndex:indexPath.row] objectForKey:@"buildingList"];
    controller.projectName = [[self.ProjectList objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
