//
//  APICaller.swift
//  TestHH
//
//  Created by Mac on 12.09.2021.
//

import Foundation

class APICaller {
    // MARK: - Public Properties
    static let shared = APICaller()
    var isPaginating = false
    var page = 0
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - Public Methods
    func fetchData(pagination: Bool = false,
                   completion: @escaping (Result<Vacancie, Error>) -> ()) {
        if pagination {
            isPaginating = true
        }
        if var urlComponents = URLComponents(string: "https://api.hh.ru/vacancies") {
            urlComponents.query = "page=\(page)&per_page=20"
            guard let url = urlComponents.url else { return }
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            
            session.dataTask(with: request) { data, _, error in
                guard let data = data else { return }
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(Vacancie.self, from: data)
                    completion(.success(result))
                    if pagination {
                        self.isPaginating = false
                    }
                } catch let error {
                    print(error)
                }
                if let error = error {
                    print(error)
                }
            }.resume()
        }
    }
}
