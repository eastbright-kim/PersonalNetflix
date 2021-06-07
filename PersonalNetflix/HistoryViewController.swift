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
    var histories: [SearchHistory] = []
    let db = Database.database().reference().child("searchHistory")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.observeSingleEvent(of: .value) { snapshot in
        
            guard let value = snapshot.value as? [String : Any] else {return}
            
          
            guard let data = try? JSONSerialization.data(withJSONObject: Array(value.values), options: []) else {return}
            
            do{
                let histories = try JSONDecoder().decode([SearchHistory].self, from: data)
                
                let sortedHistory = histories.sorted { term1, term2 in
                    term1.timestamp > term2.timestamp
                }
                self.histories = sortedHistory
                
                self.tableView.reloadData()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(self.histories.count)
        return self.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryCell else {return UITableViewCell()}
        
        let movie = self.histories[indexPath.row]
        
        cell.searchLabel.text = movie.term
        return cell
    }
}



class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var searchLabel: UILabel!
    
}

struct SearchHistory: Codable {
    
    let term: String
    let timestamp: TimeInterval
    
}
