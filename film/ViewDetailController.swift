//
//  ViewDetailController.swift
//  film
//
//  Created by Dev Trop-plus on 15/03/2022.
//

import SwiftUI
import AVKit
import AVFoundation

struct resultVideo: Decodable {
    var id: Int?;
    var results: [tvVideo]?;
}

class ViewDetailController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var backgroundPath: UIImageView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var nbSaison: UILabel!
    @IBOutlet weak var nbEpisode: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    
    @IBAction func playVideo(_ sender: UIButton) {
        self.trailerButton.pulsate()
        fetchURLVideo()
    }
    
    var tv : Tv?
    var tvDetail: TvDetail?;
    var resultVideoAPI: resultVideo?;
    
    func fetchURLVideo() {
        print("fetch detail")
        let apikey = "d3816181c54e220d8bc669bdc4503396"
        let baseUrl = "https://api.themoviedb.org/3/";
        let urlStr = baseUrl + "tv/" + String(tv!.id!) + "/videos" + "?api_key="+apikey;
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
                              self.resultVideoAPI = try! JSONDecoder().decode(resultVideo.self, from: data)
                              for element in self.resultVideoAPI!.results! {
                                
                                  if(element.site! == "YouTube" && element.type!  == "Trailer") {
                                      let urlVideo : String = String("https://youtu.be/") + element.key!
                                      guard let url = URL(string: urlVideo) else {return}
                                      if UIApplication.shared.canOpenURL(url) {
                                         UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                      }
                                  }
                              }
                          }
                      }else{
                        print("no data")
                        return
                      }

                    }).resume()
    }
 
    
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
                              self.note.text = String(format: "%.1f", self.tvDetail?.vote_average ?? "Inconnue")
                              self.date.text = self.tvDetail?.first_air_date
                              self.nbSaison.text = "Saisons : " +             String(format: "%O", self.tvDetail?.number_of_seasons ?? "0")
                              self.nbEpisode.text = "Episodes : " + String(format: "%O", self.tvDetail?.number_of_episodes ?? "0")
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
        summary.isEditable = false;
    }
}
