//
//  NewsTableViewCellViewModel.swift
//  NewsApp
//
//  Created by Eren Aşkın on 13.05.2024.
//

import Foundation

class NewsTableViewCellViewModel{
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, subtitle: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}
