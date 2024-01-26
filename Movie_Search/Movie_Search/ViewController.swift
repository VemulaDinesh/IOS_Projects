//
//  ViewController.swift
//  Movie_Search
//
//  Created by Vemula Dinesh on 18/01/24.
//



import UIKit
import Darwin
class ViewController: UIViewController {

    override func viewDidLoad()  {
        super.viewDidLoad()

        // Example usage
        let apiKey = "2c30e4db"
        let searchText = "Game of Thrones"

        fetchDataFromAPI(apiKey: apiKey, searchText: searchText)
       sleep(5)
        for item in APIResponse.searchResult?.Search ?? [] {
            print("Title: \(item.title), Year: \(item.year)")
        }
    }

    func fetchDataFromAPI(apiKey: String, searchText: String) {
        // Parse the URL
        guard let apiUrl = parseURL(apiKey: apiKey, searchText: searchText) else {
            print("Error creating URL")
            return
        }

        // Create URLSession
        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: apiUrl) { (data, response, error) in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if data is available
            guard let data = data else {
                print("No data received")
                return
            }

            // Parse the data using JSONDecoder
            do {
                let decoder = JSONDecoder()
                let searchResult = try decoder.decode(SearchResult.self, from: data)
                 print(apiUrl)
                // Assign the result to the static property
                APIResponse.searchResult = searchResult
                //print(searchResult)
                // Now you can access APIResponse.searchResult throughout your project

                 //Example: print the total results
//                print("Total Results: \(APIResponse.searchResult?.totalResults)")

                // Example: loop through search items
//                for item in APIResponse.searchResult?.Search ?? [] {
//                    print("Title: \(item.Title), Year: \(item.Year)")
//                }

            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        // Resume the task
        task.resume()
    }

    func parseURL(apiKey: String, searchText: String) -> URL? {
        // API URL string
        let urlString = "https://www.omdbapi.com/"
        
        // Create URL components
        var urlComponents = URLComponents(string: urlString)
        
        // Add query items
        let apiKeyQueryItem = URLQueryItem(name: "apikey", value: apiKey)
        let searchQueryItem = URLQueryItem(name: "s", value: searchText)
        
        // Set the query items
        urlComponents?.queryItems = [apiKeyQueryItem, searchQueryItem]
        
        // Create the final URL
        if let url = urlComponents?.url {
            print(url)
            return url
        } else {
            return nil
            
        }
    }
}

 

    // Example usage
    




