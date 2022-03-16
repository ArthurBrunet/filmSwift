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


extension UIImageView {
    
    func dl(from urlString: String){
        guard let url = URL(string: urlString) else {return}
        contentMode = .scaleAspectFill
        // on va aller charger l'img, like API
        URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else { return }
                    DispatchQueue.main.async() {
                        self.image = image
                    }
                }.resume()
    }
}

class CollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    // var tabTv : [Tv] = [];
    var res: Result?;
    
    var filteredTv: [Tv] = []
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("toto")
        filteredTv = searchText.isEmpty ? filteredTv : filteredTv.filter { (tv: Tv) -> Bool in
            return tv.name!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResult();
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
                                  self.filteredTv.append(Tv(id: result.id, backdrop_path: result.backdrop_path, first_air_date: result.first_air_date , name: result.name, popularity: result.popularity, poster_path: result.poster_path, vote_average: result.vote_average, vote_count: result.vote_count))
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
        return self.filteredTv.count
    }

    // peupler les cellules de tables
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as! MyCollectionViewCell
        cell.name?.text = filteredTv[indexPath.row].name
        cell.image?.dl(from: "https://image.tmdb.org/t/p/w500"+filteredTv[indexPath.row].backdrop_path!)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewDetail : ViewDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "movieDetail")
        viewDetail.tv = filteredTv[indexPath.row]
        present(viewDetail, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "test", for: indexPath as IndexPath)
        return headerView
    }
}
