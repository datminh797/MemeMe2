//
//  MemeModel.swift
//  MemeMe
//
//  Created by minhdat on 20/08/2022.
//

import Foundation
import UIKit

struct MemeModel {
    var topTextField: String?
    var botTextField: String?
    var image: UIImage?
    var memedImage: UIImage?
}

class MemeService {
    static let object = MemeService()
    var memes: [MemeModel] = []
}



