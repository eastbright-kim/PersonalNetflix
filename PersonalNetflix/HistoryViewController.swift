//
//  HistoryViewController.swift
//  PersonalNetflix
//
//  Created by 김동환 on 2021/06/06.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let db = Database.database().reference().child("searchHistory")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.observeSingleEvent(of: .value) { snapshot in
            print("검색 목록 \(snapshot.value)")
        }
        
    }
    

}

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var searchLabel: UILabel!
    
    
}
