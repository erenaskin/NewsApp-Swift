//
//  FavoriteArticleTableViewCell.swift
//  NewsApp
//
//  Created by Eren Aşkın on 14.05.2024.
//

import UIKit

class FavoriteArticleTableViewCell: UITableViewCell {

    let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()

    let newsSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .gray
        return label
    }()

    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsSubtitleLabel)
        contentView.addSubview(newsImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWidth: CGFloat = 100
        newsImageView.frame = CGRect(x: 10, y: 10, width: imageWidth, height: contentView.frame.size.height - 20)
        
        newsTitleLabel.frame = CGRect(x: newsImageView.frame.maxX + 10,
                                      y: 10,
                                      width: contentView.frame.size.width - newsImageView.frame.size.width - 30,
                                      height: 40)
        
        newsSubtitleLabel.frame = CGRect(x: newsImageView.frame.maxX + 10,
                                         y: newsTitleLabel.frame.maxY + 5,
                                         width: contentView.frame.size.width - newsImageView.frame.size.width - 30,
                                         height: 40)
    }
}

