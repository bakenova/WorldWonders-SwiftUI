//
//  ContentView.swift
//  WorldWondersSwiftUI
//
//  Created by Arailym on 22.04.2022.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct WorldWonder: Identifiable {
    var id = UUID()
    var name = ""
    var region = ""
    var location = ""
    var flag = ""
    var picture = ""
    
    init(json: JSON) {
        if let temp = json["name"].string {
            name = temp
        }
        if let temp = json["region"].string {
            region = temp
        }
        if let temp = json["location"].string {
            location = temp
        }
        if let temp = json["flag"].string {
            flag = temp
        }
        if let temp = json["picture"].string {
            picture = temp
        }
    }
}

struct WonderRow: View {
    var wonderItem: WorldWonder
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: wonderItem.picture))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100.0, height: 100.0)
                .clipped()
                .cornerRadius(6.0)
            VStack(alignment: .leading, spacing: 4){
                Text(wonderItem.name)
                Text(wonderItem.region)
                HStack{
                    
                    WebImage(url: URL(string: wonderItem.flag))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30.0, height: 20.0)
                    Text(wonderItem.location)
                    
                }
            }
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var wondersList = GetWonders()
    
    var body: some View {
        NavigationView {
            List (wondersList.wondersArray){ wonderItem in
                WonderRow(wonderItem: wonderItem)
            }
            /*.refreshable {
                self.wondersList.updateData()
            }*/
            .navigationTitle("World Wonders")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
