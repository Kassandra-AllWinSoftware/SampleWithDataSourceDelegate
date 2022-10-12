//
//  ListFetch.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//

import Foundation

class APIListSimpson {
    
    static let shared = APIListSimpson()
    
    func listFetchList(completion: @escaping ([SimpsonList]) -> ()) {
        let urlString = URL(string: "https://api.sampleapis.com/simpsons/characters")!
        URLSession.shared.dataTask(with: urlString) { (data,_,Error) in
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
        .resume()
    }
}

