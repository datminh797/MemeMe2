//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by minhdat on 20/08/2022.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.image = meme?.memedImage
    }
    var meme: MemeModel?

    @IBOutlet weak var image: UIImageView!
  
}
