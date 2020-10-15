//
//  ContentView.swift
//  GridSearchSwiftUI2
//
//  Created by Irsyad Ashari on 15/10/20.
//

import SwiftUI

struct RSS: Decodable{
    
    let feed: Feed
    
}

struct Feed: Decodable{
    
    let results: [Result]
        
}

struct Result: Decodable, Hashable{
    
    let name, copyright, artworkUrl100, releaseDate: String
    
}


class GridViewModel: ObservableObject{
    
    @Published var results = [Result]() // here is the publisher to detect changes inside the variable
    
    init(){
        
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/id/apple-music/coming-soon/all/50/explicit.json")else {return}
      
        
        URLSession.shared.dataTask(with: url){(data, resp, err) in
            do{
                guard let data = data else{return}
                let rss = try JSONDecoder().decode(RSS.self, from: data)
                print(rss)
                
                self.results = rss.feed.results
                
            } catch{
                print(err as Any)
            }
        }.resume()
        
    }
    
}

import KingfisherSwiftUI

struct ContentView: View {
    
    @ObservedObject var vm = GridViewModel() // it's being observed everytime changes in being published
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16, alignment: .top),
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 16, alignment: .top),
                ], alignment: .leading , spacing: 16, content:{ // spacing vertical
                    
                    ForEach(vm.results, id: \.self){ app in
                        
                        MovieCell(app: app)
                       
                    }
                    
                }).padding(.horizontal, 12)
            }.navigationTitle("Irsyad's Movie's List")
        
        }
    }
}

struct MovieCell: View{
    
    let app: Result
    
    var body: some View{
        VStack(alignment: .leading, spacing: 4){
            
            KFImage(URL(string: app.artworkUrl100))
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
            
            Text(app.name)
                .font(.system(size: 14, weight:.semibold))
                .padding(.top, 4)
            Text("Released Dates : \(app.releaseDate)")
                .font(.system(size: 12, weight:.regular))
            Text(app.copyright)
                .font(.system(size: 15, weight:.regular))
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} // ONLY 111 lines !!!
