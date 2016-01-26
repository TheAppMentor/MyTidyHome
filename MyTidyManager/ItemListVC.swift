//
//  ItemListVC.swift
//  TidyHome
//
//  Created by Prashanth Moorthy on 20/01/16.
//  Copyright © 2016 Prashanth Moorthy. All rights reserved.
//

import UIKit
import BubbleTransition

class ItemListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var theTableView: UITableView!
    //let ItemList = ["Item 1","Item 2","Item 3","Item 4","Item 5","Item 6","Item 7","Item 8","Item 9"]
    var ItemList = []
    
    let theDateFormatter = NSDateFormatter()
    
    let thePurpleColor = UIColor(red: (186.0/255.0), green: (119.0/255.0), blue: (255.0/255.0), alpha: 1.0)
    
    @IBOutlet weak var addItem: UIButton!
    let transition = BubbleTransition()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = addItem.center
        transition.bubbleColor = thePurpleColor
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = addItem.center
        transition.bubbleColor = thePurpleColor
        return transition
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.backBarButtonItem?.setBackButtonBackgroundImage(UIImage(named: "back"), forState: .Normal, barMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationBar.frame.size.height = view.frame.height/10

        // Register for Data has changed notificaiton.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadTableview"), name: "DataHasChanged", object: nil)
        
        
        
        theDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        // THis is to remove the empty cells at the bottom of the tableview
        theTableView.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    
    func reloadTableview(){
        self.theTableView.reloadData()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        theTableView.separatorStyle = .SingleLine
        theTableView.separatorColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1)
        theTableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 20)
    
        print("View Did Appear Got Called")
    }
    

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ItemCatalog.sharedInstance.allItems().count
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)

        // Configure the cell...
        
        let theItem = ItemCatalog.sharedInstance.allItems()[indexPath.row]

            if let theStatusImage = cell.viewWithTag(11) as? UIImageView{
                let theImageName = theItem.itemStatus ? "greenDone" : "overDue"
                theStatusImage.image = UIImage(named: theImageName)
            }
            
            if let theItemTitle = cell.viewWithTag(22) as? UILabel{
                theItemTitle.text = theItem.name
            }
            
            if let theItemDueDate = cell.viewWithTag(33) as? UILabel{
                theItemDueDate.text = theDateFormatter.stringFromDate(theItem.nextCleaningDueDate!)
            }
        
        
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height/8
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
