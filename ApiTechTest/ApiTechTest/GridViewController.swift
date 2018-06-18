//
//  GridViewController.swift
//  ApiTechTest
//
//  Created by abid rana on 18/06/2018.
//  Copyright © 2018 Abid. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GridCell"

class GridViewController: UICollectionViewController {

    let urlSession = URLSession(configuration: .default)
    
    var productsArray = [GridProductModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        getGridProductsFromServer()
        
    }

    func getGridProductsFromServer()
    {
        if var urlComponents = URLComponents(string: ClientApi.searchUrl) {
            
            urlComponents.query = ClientApi.shared.getQueryProduct(productType: "dishwasher", productsPerPage: 20)
            
            let dataTask = urlSession.dataTask(with: urlComponents.url!) { data, response, error in
                
                if let errorReturn = error {
                    
                    print("url error: \(errorReturn.localizedDescription)")
                    
                }
                else if data != nil {
                    // no error
                    
                    if let resp = response as? HTTPURLResponse {
                        
                        if resp.statusCode == 200 {
                            
                            
                            let jsonDic = try? JSONSerialization.jsonObject(with: data!) as? [String:Any]
                            
                            if let productsDict = jsonDic!!["products"] as? [Any] {
                                
                                for product in productsDict {
                                    
                                    if let productDict = product as? [String:Any] {
                                        
                                        var image:UIImage?
                                        var productId:String?
                                        var title:String?
                                        var price:String?
                                        
                                        productId = productDict["productId"] as? String
                                        
                                        title = productDict["title"] as? String
                                       
                                        if let priceDic = productDict["price"] as? [String:String] {
                                            
                                            price = priceDic["now"]
                                            
                                        }
                                        
                                        if let imageUrl = productDict["image"] as? String {
                                            
                                            print("https:\(imageUrl)")
                                            
                                            if let data = try? Data(contentsOf: URL(string: "https:\(imageUrl)")!) {
                                                
                                                image = UIImage(data: data)
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.productsArray.append(GridProductModel(productId: productId!, title: title!, price: price!, imageUrl: image))
                                            
                                            self.collectionView?.reloadData()
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productsArray.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GridViewCell
    
        let product = self.productsArray[indexPath.row]
        
        // Configure the cell
        cell?.imageView.image = product.image
        cell?.titleLabel.text = product.title
        cell?.costLabel.text = "£\(product.price)"
        
        return cell!
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard =  UIStoryboard(name: "Main", bundle: nil)
        
        let productDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController
        
        self.navigationController?.pushViewController(productDetailViewController!, animated: true)
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    

}

class GridProductModel {
    
    var productId:String
    
    var title:String
    
    var image:UIImage?
    
    var price:String
    
    init(productId:String, title:String, price:String, imageUrl:UIImage?) {
        
        self.productId = productId
        self.title = title
        self.price = price
        self.image = imageUrl
    }
    
}

