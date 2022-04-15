//
//  Indicator.swift
//  UsplashJSONSwiftUI
//
//  Created by Nazar Babyak on 12.04.2022.
//

import SwiftUI

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView , context: Context) {
        
    }
}
