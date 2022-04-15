//
//  Data.swift
//  UsplashJSONSwiftUI
//
//  Created by Nazar Babyak on 12.04.2022.
//

import Foundation

class getData: ObservableObject {
    
    @Published var Images: [[Photo]] = []
    @Published var noResults: Bool = false
    
    init() {
        updateDate()
    }
    
    func updateDate() {
        
        self.noResults = false
        
        let key = "QQG-wa_pjAd-iwaxRYFI3ZHLSGrhvVYpn18kYo_Ytlk"
        let url = "https://api.unsplash.com/photos/random/?count=1000&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
         
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
             
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            do {
                let json = try JSONDecoder().decode([Photo].self, from: data!)
                
                for i in stride(from: 0, to: json.count, by: 3) {
                    
                    var ArrayData: [Photo] = []
                    
                    for j in i..<i+2 {
                        
                        if j < json.count {
                            ArrayData.append(json[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.Images.append(ArrayData)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    func SearchData(url: String) {
        
        let session = URLSession(configuration: .default)
         
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
             
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            do {
                let json = try JSONDecoder().decode(SearchPhoto.self, from: data!)
                
                if json.results.isEmpty {
                    
                    self.noResults = true
                    
                } else {
                    
                    self.noResults = false
                    
                }
                for i in stride(from: 0, to: json.results.count, by: 3) {
                    
                    var ArrayData: [Photo] = []
                    
                    for j in i..<i+2 {
                        
                        if j < json.results.count {
                            ArrayData.append(json.results[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.Images.append(ArrayData)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
}
