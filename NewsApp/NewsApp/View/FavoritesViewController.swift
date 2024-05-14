//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by Eren Aşkın on 13.05.2024.
//

import UIKit

class FavoritesViewController: UIViewController {
    var favoriteNews: [NewsTableViewCellViewModel] = []
    var articles: [Article] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteArticleTableViewCell.self, forCellReuseIdentifier: "FavoriteArticleTableViewCell")
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func deleteFavorite(at indexPath: IndexPath) {
            FavoritesManager.shared.favoriteArticles.remove(at: indexPath.row)
            tableView.reloadData()
        }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesManager.shared.favoriteArticles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteArticleTableViewCell", for: indexPath) as! FavoriteArticleTableViewCell
            let article = FavoritesManager.shared.favoriteArticles[indexPath.row]

            cell.newsTitleLabel.text = article.title
            cell.newsSubtitleLabel.text = article.description
            if let imageUrlString = article.urlToImage,
               let imageUrl = URL(string: imageUrlString) {
                URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.newsImageView.image = image
                        }
                    }
                }.resume()
            }
            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let article = FavoritesManager.shared.favoriteArticles[indexPath.row]
            let detailsVC = DetailsViewController()
            detailsVC.article = article
            navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
                self?.deleteFavorite(at: indexPath)
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    
}

