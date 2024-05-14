//
//  Article.swift
//  NewsApp
//
//  Created by Eren Aşkın on 13.05.2024.
//

import Foundation

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}
