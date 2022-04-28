//
//  NewsData.swift
//  News
//
//  Created by sameena on 24/04/22.
//  Copyright © 2022 sameena. All rights reserved.
//

import Foundation

struct NewsData: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String
    let urlToImage: String
}
