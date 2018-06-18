//
//  DetailTableViewController.swift
//  ApiTechTest
//
//  Created by abid rana on 18/06/2018.
//  Copyright © 2018 Abid. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var navTitle:String?
    var image:UIImage?
    var price:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = navTitle
        
        imageView.image = image
        
        priceLabel.text = "£\(price!)"
        self.navigationController?.navigationBar.topItem?.title = " "
    }


}
