//
//  TV.swift
//  film
//
//  Created by user214956 on 3/16/22.
//

import Foundation

struct Tv: Decodable {
    var id: Int?;
    var backdrop_path: String?;
    var first_air_date: String?;
    var name: String?;
    var popularity: Double?;
    var poster_path: String?;
    var vote_average: Double?;
    var vote_count: Int?;
}
