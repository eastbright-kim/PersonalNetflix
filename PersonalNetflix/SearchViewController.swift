//
//  SearchViewController.swift
//  PersonalNetflix
//
//  Created by 김동환 on 2021/05/31.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {return UICollectionViewCell()}
        
        let movie = self.movies[indexPath.item]
        cell.updateUI(movie: movie)
        return cell
    }
}


extension SearchViewController: UICollectionViewDelegate {
    //클릭하면 뷰컨트롤러 띄움
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        let width = (view.bounds.width - margin * 2 - itemSpacing * 2) / 3
        let height = width * 10 / 7
        
        return CGSize(width: width, height: height)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard self.searchBar.text?.isEmpty == false,
              let searchTerm = self.searchBar.text else {return}
        
        SearchAPI.searchMovie(searchTerm: searchTerm) { movies in
            self.movies = movies
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
}


class MovieCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    
    func updateUI(movie: Movie){
        self.posterImageView.kf.setImage(with: URL(string: movie.movieThumbNail))
    }
}

class SearchAPI {
    
    static func searchMovie(searchTerm: String, completion: @escaping ([Movie]) -> Void){
        print(searchTerm)
        let session = URLSession(configuration: .default)
        var urlComponnent = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: searchTerm)
        
        urlComponnent.queryItems?.append(mediaQuery)
        urlComponnent.queryItems?.append(entityQuery)
        urlComponnent.queryItems?.append(termQuery)
        
        let urlRequest = urlComponnent.url!
       
        print(urlRequest)
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {completion([])
                return
            }
            
            guard let movieData = data else { completion([])
                return
            }
            //안됐던 부분
            
            let movies = SearchAPI.parseMovie(data: movieData)
            completion(movies)
        }
        
        dataTask.resume()
    }
    
    static func parseMovie(data: Data) -> [Movie]{
        
        let decoder = JSONDecoder()
        
        do{
            let response = try decoder.decode(Response.self, from: data)
           print(response)
            let movies = response.movies
            print(movies)
            return movies
        } catch let error {
            print("here \(error.localizedDescription)")
            return []
        }
    }
}

//struct Movie: Codable {
//    let title: String
//    let director: String
//    let previewURL: String
//    let movieThumbNail: String
//
//    enum Codingkeys: String, CodingKey {
//        case title = "trackName"
//        case director = "artistName"
//        case previewURL = "previewUrl"
//        case movieThumbNail = "artworkUrl100"
//    }
//}

//struct Movie: Codable {
//    let title: String
//    let director: String
//    let thumbnailPath: String
//    let previewURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case title = "trackName"
//        case director = "artistName"
//        case thumbnailPath = "artworkUrl100"
//        case previewURL = "previewUrl"
//    }
//}

struct Response: Codable {
    let resultCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
}

struct Movie: Codable {
    let title: String
    let director: String
    let previewURL: String
    let movieThumbNail: String

    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case director = "artistName"
        case previewURL = "previewUrl"
        case movieThumbNail = "artworkUrl100"

    }
}
//struct Movie: Codable {
//    let title: String
//    let director: String
//    let previewURL: String
//    let movieThumbNail: String
//
//    enum Codingkeys: String, CodingKey {
//        case title = "trackName"
//        case director = "artistName"
//        case previewURL = "previewUrl"
//        case movieThumbNail = "artworkUrl100"
//    }
//}
