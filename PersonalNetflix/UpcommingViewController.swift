//
//  UpcommingViewController.swift
//  PersonalNetflix
//
//  Created by 김동환 on 2021/06/03.
//

import UIKit

class UpcommingViewController: UIViewController {
    
    var hotRecommendViewController: RecommendListViewController!
    var awardRecommendViewController: RecommendListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "award" {
            guard let vc = segue.destination as? RecommendListViewController else {return}
            awardRecommendViewController = vc
            awardRecommendViewController.viewModel.setTypeTitle(type: .award)
            awardRecommendViewController.viewModel.fetchMovies()
        } else if segue.identifier == "hot" {
            guard let vc = segue.destination as? RecommendListViewController else {return}
            hotRecommendViewController = vc
            hotRecommendViewController.viewModel.setTypeTitle(type: .hot)
            hotRecommendViewController.viewModel.fetchMovies()
        }
    }
}


