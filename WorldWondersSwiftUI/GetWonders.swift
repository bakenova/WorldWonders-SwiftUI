//
//  GetWonders.swift
//  WorldWondersSwiftUI
//
//  Created by Арайлым Бакенова on 16.12.2022.
//

import Foundation
import SwiftyJSON

class GetWonders: ObservableObject {
    @Published var wondersArray = [WorldWonder]()
    
    init() {
        updateData()
    }
    
    func updateData(){
        let urlString = "https://demo3886709.mockable.io/getWonders"
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url!) { (data, _, error) in
            if  error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            let json = try! JSON(data: data!)
            if let resultArray = json.array {
                self.wondersArray.removeAll()
                
                for item in resultArray {
                    let wonder = WorldWonder(json: item)
                    
                    DispatchQueue.main.async {
                        self.wondersArray.append(wonder)
                    }
                }
            }
        }.resume()
    }
}
