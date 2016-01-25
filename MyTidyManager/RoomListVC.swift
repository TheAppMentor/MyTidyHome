//
//  RoomListVC.swift
//  MyTidyManager
//
//  Created by Prashanth Moorthy on 26/01/16.
//  Copyright © 2016 Prashanth Moorthy. All rights reserved.
//

import UIKit

class RoomListVC: UIViewController {

    @IBOutlet weak var theTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func dismissScreen(sender: UIButton) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("Now I am dismissing the Screen")
        }
    }

    @IBAction func AddNewRoom(sender: UIButton) {
        print("Now I will add a new Room")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
