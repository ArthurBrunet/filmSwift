//
//  TVDetail.swift
//  film
//
//  Created by user214956 on 3/16/22.
//

import Foundation

struct TvDetail: Decodable {
    var original_name: String?;
    var vote_average: Double?;
    var poster_path: String?;
    var backdrop_path: String?;
    var first_air_date: String?;
    var popularity: Double?;
    var genres: [Genre?];
    var overview: String?;
    var number_of_episodes: Int?;
    var number_of_seasons: Int?;
}
