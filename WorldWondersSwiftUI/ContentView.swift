//
//  ContentView.swift
//  WorldWondersSwiftUI
//
//  Created by Arailym on 22.04.2022.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

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
            .navigationTitle("World Wonders")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
