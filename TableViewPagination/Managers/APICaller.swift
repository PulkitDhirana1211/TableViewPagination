//
//  APICaller.swift
//  TableViewPagination
//
//  Created by Pulkit Dhirana on 24/11/23.
//

import Foundation

class APICaller {
    
    public var isPaginating = false
    static let shared = APICaller()
    private init() {}
    func fetchData(pagination: Bool = false,pageNumber: Int = 1, completion: @escaping (Result<[PostModel],Error>) -> Void) {
        
        if pagination {
            isPaginating = true
        }
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos?_page=\(pageNumber)&_limit=10") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: {[weak self] data , _ , error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode([PostModel].self, from: data)
                completion(.success(results))
                if pagination {
                    self?.isPaginating = false
                }
            } catch {
                print("Unable to get data")
            }
        })
        task.resume()
        
    }
}
