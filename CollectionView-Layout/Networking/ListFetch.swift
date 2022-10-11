//
//  ListFetch.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//

import Foundation

class APIListSimpson {
    
    static let shared = APIListSimpson()
    
    func ListFetchList(completion: @escaping ([SimpsonList]) -> ()) {
        let urlString = "https://api.sampleapis.com/simpsons/characters"
        let url = URL (string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data,_,Error) in
            guard let data = data else {
                print("Failure")
                return
            }
            guard let principalList = try? JSONDecoder().decode([SimpsonList].self, from: data) else {
                print("No decode")
                return
            }
            completion (principalList)
        }
        task.resume()
    }
}

