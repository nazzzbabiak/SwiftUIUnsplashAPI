//
//  Photo.swift
//  UsplashJSONSwiftUI
//
//  Created by Nazar Babyak on 12.04.2022.
//

import Foundation


struct Photo: Identifiable , Decodable , Hashable {
    var id: String
    var urls: [String : String]
}
