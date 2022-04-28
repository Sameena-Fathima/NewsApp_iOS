//
//  NewsManager.swift
//  News
//
//  Created by sameena on 24/04/22.
//  Copyright © 2022 sameena. All rights reserved.
//

import Foundation

protocol NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: NewsData)
    func didFailWithError(error: Error)
}

struct NewsManager {
    
    let newsURL =  "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=55c23c9f979d46e5bade55a65afca43b"
    
    var delegate: NewsManagerDelegate?
    
    // Function to fetch data from the API
    func performRequest() {
        
        // Create a URL
        if let url = URL(string: newsURL) {
            
            // Create a URLSession
            let session = URLSession(configuration: .default)
            
            // Assign a task to the session
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let news = self.parseJSON(newsData: safeData) {
                        self.delegate?.updateNews(self, news: news)
                    }
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    
    // Function to return decoded JSON data
    func parseJSON(newsData: Data) -> NewsData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsData.self, from: newsData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
