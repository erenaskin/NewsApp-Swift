//
//  ViewController.swift
//  NewsApp
//
//  Created by Eren Aşkın on 12.05.2024.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    private var searchVC = UISearchController(searchResultsController: nil)
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchTopStories()
        createSearchBar()
        
    }
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private func fetchTopStories(){
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No description.", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}



extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.row]
        let detailsViewController = DetailsViewController()
        detailsViewController.article = selectedArticle
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let newsItem = viewModels[indexPath.row]
        let addToFavorites = UIContextualAction(style: .normal, title: "Favorites") { _, _, completionHandler in
            let favoritesVC = FavoritesViewController()
            favoritesVC.favoriteNews.append(newsItem)
            tableView.reloadData()
            completionHandler(true)
        }
        addToFavorites.backgroundColor = .orange
        let swipe = UISwipeActionsConfiguration(actions: [addToFavorites])
        return swipe
    }
    
}
extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text ,!text.isEmpty else{
            return
        }
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No description.", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

