//
//  ViewController.swift
//  film
//
//  Created by Dev Trop-plus on 15/03/2022.
//

import UIKit

struct Result : Decodable {
    var page: Int?;
    var results: [Tv]?;
    var total_pages: Int?;
    var total_results: Int?;
}

class CollectionViewController: UICollectionViewController {
    
    var tabTv : [Tv] = [];
    var res: Result?;
    
    var filteredTv: [Tv] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredTv = tabTv.filter { (tv: Tv) -> Bool in
        return tv.name.lowercased().contains(searchText.lowercased())
      }
      collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResult();
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search movies"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
    }
    
    func fetchResult() {
        let apikey = "d3816181c54e220d8bc669bdc4503396"
        let language = "fr-FR"
        let baseUrl = "https://api.themoviedb.org/3/";
        let url = URL(string: baseUrl + "tv/popular" + "?api_key="+apikey+"&language=" + language)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                debugPrint("Error with fetching post: \(error)")
                return
            }else {
                debugPrint("No error")
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                      else {
                        // \{id}
                        debugPrint("Error with the response, unexpected status code: \(String(describing: response) )")
                        debugPrint("Error with the response, unexpected status code:" + response.debugDescription)
                        return
                      }
                    // analyse des données
                      if let data = data{
                          DispatchQueue.main.async() {
                              self.res = try! JSONDecoder().decode(Result.self, from: data)
                              for result in self.res!.results! {
                                  self.tabTv.append(Tv(id: result.id, backdrop_path: result.backdrop_path, first_air_date: result.first_air_date , name: result.name, popularity: result.popularity, poster_path: result.poster_path, vote_average: result.vote_average, vote_count: result.vote_count))
                              }
                              self.collectionView.reloadData();
                          }
                      }else{
                        print("no data")
                        return
                      }

                    }).resume()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // obligatoire à redéfinir
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabTv.count
    }

    // peupler les cellules de tables
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as! MyCollectionViewCell
        cell.name?.text = tabTv[indexPath.row].name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewDetail : ViewDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "movieDetail")
        viewDetail.tv = tabTv[indexPath.row]
        present(viewDetail, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("toto");
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "test", for: indexPath as IndexPath)
        return headerView
    }
}

extension CollectionViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
}
