//
//  ViewController.swift
//  News
//
//  Created by sameena on 24/04/22.
//  Copyright © 2022 sameena. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController{
    
    var newsManager = NewsManager()
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsManager.delegate = self
        newsManager.performRequest()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        cell.title.text = article.title
        cell.subTitle.text = article.description
        
        // Converting url string to image
        if let url = URL(string: article.urlToImage) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        cell.newsImageView.image = UIImage(data: safeData)
                    }
                }
            }
            task.resume()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - NewsManagerDelegate

extension NewsViewController: NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: NewsData) {
        DispatchQueue.main.async {
            self.articles = news.articles
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
