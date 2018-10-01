//
//  PopVC.swift
//  Treez
//
//  Created by Weston Gibler on 9/30/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import UIKit

class PopVC: UIViewController {

    @IBOutlet weak var popImageView: UIImageView!
    
    var passedImage: UIImage!
    
    func initData(forImage image: UIImage) {
        self.passedImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
