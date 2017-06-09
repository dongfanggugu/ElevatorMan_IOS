//
//  ProjectsTableViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "ProjectsTableViewController.h"

#import "BuildingsViewController.h"
#import "HttpClient.h"

#pragma mark - ProjectsCell

@interface ProjectsCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIView *backColorView;
@property (nonatomic, retain) IBOutlet UILabel *projectTtle;

@end


@implementation ProjectsCell


//根据index.row的值%3来设置背景图片、背景颜色和文字颜色
- (void)setCellContent:(NSInteger)index {
    switch (index % 3) {
        case 0: {

            self.projectTtle.textColor = UIColorFromRGB(0xfffbd075);
            self.backColorView.backgroundColor = UIColorFromRGB(0xfffbd075);
            [self.backgroundImageView setImage:[UIImage imageNamed:@"icon_project_1.png"]];
            break;

        }

        case 1: {
            self.projectTtle.textColor = UIColorFromRGB(0xff99cdff);;
            self.backColorView.backgroundColor = UIColorFromRGB(0xff99cdff);
            [self.backgroundImageView setImage:[UIImage imageNamed:@"icon_project_2.png"]];
            break;

        }
        case 2: {
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"项目"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getProjectsList];
}


- (void)getProjectsList {

    __weak ProjectsTableViewController *weakSelf = self;
    //请求
    [[HttpClient sharedClient] post:@"getElevatorList" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                weakSelf.ProjectList = [responseObject objectForKey:@"body"];
                                [weakSelf.tableView reloadData];
                            }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.ProjectList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectsCell" forIndexPath:indexPath];

    // Configure the cell...

    cell.projectTtle.text = [[self.ProjectList objectAtIndex:indexPath.row] objectForKey:@"name"];

    [cell setCellContent:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BuildingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"buildingsViewController"];
    controller.buildingArray = [[self.ProjectList objectAtIndex:indexPath.row] objectForKey:@"buildingList"];
    controller.projectName = [[self.ProjectList objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
