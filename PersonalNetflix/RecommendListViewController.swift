//
//  RecommendListViewController.swift
//  PersonalNetflix
//
//  Created by 김동환 on 2021/05/30.
//

import UIKit

class RecommendListViewController: UIViewController {
    
    @IBOutlet weak var recommendTitleLabel: UILabel!
    
    let viewModel = RecommendListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func updateUI(){
        self.recommendTitleLabel.text = viewModel.recommendType.title
    }
    
}

extension RecommendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as? RecommendCell else {return UICollectionViewCell()}
        
        let movie = viewModel.movieAtIndex(indexPath.item)
        
        cell.updateCell(movie: movie)
        
        return cell
    }
    
}

extension RecommendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}

class RecommendListViewModel {
    
    enum RecommendKind {
        case my
        case hot
        case award
        
        var title: String {
            switch self {
            case .award: return "아카데미 호평 영화"
            case .hot: return "취향저격 HOT 콘텐츠"
            case .my: return "내가 찜한 콘텐츠"
            }
        }
    }
    
    private (set) var recommendType: RecommendKind = .my
    private var movies = [DummyMovie]()
    
    
    var numberOfItem: Int {
        return movies.count
    }
    
    func setTypeTitle(type: RecommendKind) {
        self.recommendType = type
    }
    
    func movieAtIndex(_ index: Int) -> DummyMovie {
        return movies[index]
    }
    
    func fetchMovies(){
        movies = MovieFetcher.fetch(type: recommendType)
    }
}

class MovieFetcher{
    static func fetch(type: RecommendListViewModel.RecommendKind) -> [DummyMovie]{
        switch type {
        case .award:
            let movies = (1..<10).map{DummyMovie(movieImage: UIImage(named: "img_movie_\($0)")!)}
            return movies
        case .hot:
            let movies = (10..<19).map{DummyMovie(movieImage: UIImage(named: "img_movie_\($0)")!)}
            return movies
        case .my:
            let movies = (1..<10).map{DummyMovie(movieImage: UIImage(named: "img_movie_\($0)")!)}
            return movies
        }
    }
}

class RecommendCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    
    func updateCell(movie: DummyMovie){
        self.movieImageView.image = movie.movieImage
    }
    
}

struct DummyMovie {
    let movieImage: UIImage
}
