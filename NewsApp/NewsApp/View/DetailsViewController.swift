//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by Eren Aşkın on 12.05.2024.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {
    
    var article: Article?
    var articleURL: URL?
    var isFavorite = false
    var articles: [Article] = []
    var newsItem: NewsTableViewCellViewModel?
    
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let newsSubtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(newsImageView)
        view.addSubview(newsTitleLabel)
        view.addSubview(newsSubtitleLabel)
        
        setupButton()
        setupShareButton()
        setupFavoriteButton()
        updateUI()
        configureView()
        
    }
    func updateUI(){
        if let article = article {
            newsTitleLabel.text = article.title
            newsSubtitleLabel.text = article.description
            if let imageUrlString = article.urlToImage,
               let imageUrl = URL(string: imageUrlString) {
                URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.newsImageView.image = image
                        }
                    }
                }.resume()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let imageWidth: CGFloat = 350
        let imageHeight: CGFloat = 350
        let imageX = (view.bounds.width - imageWidth) / 2
        let imageY = (view.bounds.height - imageHeight) / 2 - 150
        newsImageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)

        let titleLabelWidth = view.bounds.width - 40
        let titleLabelHeight: CGFloat = 100
        let titleLabelX: CGFloat = 20
        let titleLabelY = newsImageView.frame.maxY + 20
        newsTitleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelWidth, height: titleLabelHeight)

        let subtitleLabelWidth = view.bounds.width - 40
        let subtitleLabelHeight: CGFloat = 100
        let subtitleLabelX: CGFloat = 20
        let subtitleLabelY = newsTitleLabel.frame.maxY + 20
        newsSubtitleLabel.frame = CGRect(x: subtitleLabelX, y: subtitleLabelY, width: subtitleLabelWidth, height: subtitleLabelHeight)
        
    }



    
    func setupButton() {
        
        let button = UIButton(type: .system)
        button.setTitle("Haberin Kaynağına Git", for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(openSafari), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: newsSubtitleLabel.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func openSafari() {
        if let urlString = article?.url, let url = URL(string: urlString) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    private func setupShareButton() {
        let shareButton = UIButton(type: .system)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .orange
        shareButton.addTarget(self, action: #selector(shareArticle), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: newsSubtitleLabel.bottomAnchor, constant: 20),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

    }

    @objc func shareArticle() {
        if let urlString = article?.url, let url = URL(string: urlString) {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }

    func setupFavoriteButton() {
        let favoriteButton = UIButton(type: .system)
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.tintColor = .orange
        view.addSubview(favoriteButton)
        
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: newsSubtitleLabel.bottomAnchor, constant: 25),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    



    @objc func addToFavorites() {
        if let article = self.article {
            FavoritesManager.shared.addFavorite(article: article)
        }
    }

    private func configureView() {
            guard let newsItem = newsItem else { return }
            newsTitleLabel.text = newsItem.title
            newsSubtitleLabel.text = newsItem.subtitle
            if let imageURL = newsItem.imageURL {
                if let data = try? Data(contentsOf: imageURL) {
                    newsImageView.image = UIImage(data: data)
                }
            }
        }
    }
