//
//  ViewDetailController.swift
//  film
//
//  Created by Dev Trop-plus on 15/03/2022.
//

import SwiftUI

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

class ViewDetailController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var backgroundPath: UIImageView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var summary: UITextView!
    var tv : Tv?
    var tvDetail: TvDetail?;
    
    func fetchDetail() {
        print("fetch detail")
        let apikey = "d3816181c54e220d8bc669bdc4503396"
        let language = "fr-FR"
        let baseUrl = "https://api.themoviedb.org/3/";
        let urlStr = baseUrl + "tv/" + String(tv!.id!) + "?api_key="+apikey+"&language=" + language;
        let url = URL(string: urlStr )!
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
                              self.tvDetail = try! JSONDecoder().decode(TvDetail.self, from: data)
                              self.name.text = self.tvDetail?.original_name!
                              self.backgroundPath.dl(from: String("https://image.tmdb.org/t/p/w500") +  self.tvDetail!.backdrop_path!)
                              self.imageLogo.dl(from: String("https://image.tmdb.org/t/p/w500") + self.tvDetail!.poster_path!)
                              self.summary.text = self.tvDetail?.overview
                          }
                      }else{
                        print("no data")
                        return
                      }

                    }).resume()
    }
    
    // quand la vue apparaît, après sa création
    override func viewDidLoad() {
        super.viewDidLoad();
        fetchDetail();
        
        
    }
}
