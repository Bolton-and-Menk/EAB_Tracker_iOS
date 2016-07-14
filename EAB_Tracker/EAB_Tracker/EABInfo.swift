//
//  EABInfo.swift
//  EAB_Tracker
//
//  Created by Caleb Mackey on 5/11/16.
//  Copyright © 2016 Caleb Mackey. All rights reserved.
//
import UIKit


class EABInfo: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [String] = [NSLocalizedString("beetle_info", comment:""), NSLocalizedString("larvae_info", comment:""), NSLocalizedString("bark_info", comment:""),NSLocalizedString("beetle_info", comment:""),NSLocalizedString("exit_hole", comment:""), NSLocalizedString("s_gallary", comment:"")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.tableData[indexPath.row]
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
