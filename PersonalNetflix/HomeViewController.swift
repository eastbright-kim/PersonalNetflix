//
//  HomeViewController.swift
//  PersonalNetflix
//
//  Created by 김동환 on 2021/05/29.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    var awardRecommendationVC: RecommendListViewController!
    var hotRecommendationVC: RecommendListViewController!
    var myRecommendationVC: RecommendListViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "award" {
            guard let vc = segue.destination as? RecommendListViewController else {return}
            awardRecommendationVC = vc
            awardRecommendationVC.viewModel.setTypeTitle(type: .award)
            awardRecommendationVC.viewModel.fetchMovies()
        } else if segue.identifier == "hot" {
            guard let vc = segue.destination as? RecommendListViewController else {return}
            hotRecommendationVC = vc
            hotRecommendationVC.viewModel.setTypeTitle(type: .hot)
            hotRecommendationVC.viewModel.fetchMovies()
        } else if segue.identifier == "my" {
            guard let vc = segue.destination as? RecommendListViewController else {return}
            myRecommendationVC = vc
            myRecommendationVC.viewModel.setTypeTitle(type: .my)
            myRecommendationVC.viewModel.fetchMovies()
        }
    }
}

