//
//  Home.swift
//  UsplashJSONSwiftUI
//
//  Created by Nazar Babyak on 12.04.2022.
//

import SwiftUI
import Kingfisher

struct Home: View {
    
    @State private var expand: Bool = false
    @State private var search: String = ""
    @ObservedObject var RandomImages = getData()
    @State private var page = 1
    @State private var isSearching: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if !self.expand {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Unsplash")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        
                        //                    RoundedRectangle(cornerRadius: 2)
                        //                        .frame(width: 200, height: 1)
                        
                        Text("Чудові і безплатні фото")
                            .font(.system(size: 15, weight: .light, design: .monospaced))
                    }
                }
                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            self.expand = true
                        }
                    }
                
                if self.expand {
                    TextField("Search...", text: $search)
                    
                    if self.search != "" {
                        Button(action: {
                            
                            self.RandomImages.Images.removeAll()
                            
                            self.isSearching = true
                            
                            self.page = 1 
                            
                            self.SearchData()
                            
                        }, label: {
                            Text("Пошук")
                                .font(.system(size: 20, weight: .light, design: .monospaced))
                                .foregroundColor(.black)
                        })
                    }
                    
                    Button(action: {
                        withAnimation(.spring()){
                            self.expand = false
                        }
                        
                        self.search = ""
                        
                        if self.isSearching {
                            self.isSearching = false
                            self.RandomImages.Images.removeAll()
                            self.RandomImages.updateDate()
                        }
                        
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                    })
                }
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            
            if self.RandomImages.Images.isEmpty {
                
                Spacer()
                
                if self.RandomImages.noResults {
                    Text("За вашим запитом не знайдено зображень")
                } else {
                    Indicator()
                }
                
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(self.RandomImages.Images, id: \.self) { i in
                            
                            VStack(spacing: 10) {
                                ForEach(i) { j in
                                    
                                    KingFisherImageView(url: j.urls["regular"]!)
                                  //  RoundedRectangle(cornerRadius: 10)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2 , height: 300)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                                        .contextMenu {
                                            ContextMenuSetting()
                                        }
                                }
                            }
                        }
                        
                        if !self.RandomImages.Images.isEmpty {
                            
                            if self.isSearching && self.search != "" {
                                
                                HStack {
                                    
                                    Text("Page \(self.page)")
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        self.RandomImages.Images.removeAll()
                                        self.page += 1
                                        self.SearchData()
                                        
                                    }, label: {
                                        HStack {
                                            Text("Наступна")
                                                .font(.system(size: 15, weight: .light, design: .monospaced))
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 15, weight: .light, design: .monospaced))
                                        }
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(10)
                                    })
                                }
                                .padding(25)
                                
                            } else {
                                HStack {
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        self.RandomImages.Images.removeAll()
                                        self.RandomImages.updateDate()
                                        
                                    }, label: {
                                        HStack {
                                            Text("Наступна")
                                                .font(.system(size: 15, weight: .light, design: .monospaced))
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 15, weight: .light, design: .monospaced))
                                        }
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(15)
                                    })
                                }
                                .padding(25)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }.background(LinearGradient(colors: [Color(.systemBlue).opacity(0.3), Color(.systemOrange).opacity(0.2)], startPoint: .topTrailing, endPoint: .bottomLeading).edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.top)
        
    }
    //    @ViewBuilder
    func SearchData() {
        let key = "QQG-wa_pjAd-iwaxRYFI3ZHLSGrhvVYpn18kYo_Ytlk"
        let query = self.search.replacingOccurrences(of: " ", with: "%20")
        let url = "https://api.unsplash.com/search/photos/?page=\(self.page)&query=\(query)&client_id=\(key)"
        
        self.RandomImages.SearchData(url: url)
    }
    
    @ViewBuilder
    func KingFisherImageView(url: String) -> KFImage {
        KFImage(URL(string: url))
    }
    
    
    @ViewBuilder
    func ContextMenuSetting() -> some View {
        Button(action: {
            
        }, label: {
            HStack {
                Text("Зберегти")
                Image(systemName: "folder")
            }
        })
        Button(action: {
            
        }, label: {
            HStack {
                Text("Надіслати")
                Image(systemName: "paperplane")
            }
        })
        Button(action: {
            
        }, label: {
            HStack {
                Text("Вподобати")
                Image(systemName: "heart")
            }
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


