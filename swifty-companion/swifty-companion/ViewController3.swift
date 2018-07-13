//
//  ViewController3.swift
//  swifty-companion
//
//  Created by Remy SIBIET on 19/02/2018.
//  Copyright © 2018 Remy SIBIET. All rights reserved.
//

import UIKit

class ViewController3: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Skills"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idData.skills.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillsCell") as? TableViewCellSkills
        cell?.skillsLabel.text = idData.skills[indexPath.row].0
        cell?.result.text = idData.skills[indexPath.row].1
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
