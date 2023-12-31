//
//  ViewController.swift
//  Webservices
//
//  Created by Smita Kankayya on 28/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cartCollectionView: UICollectionView!
    
    var cart : [Cart] = []
    private let cartCollectionViewCellIdentifier = "CartCollectionViewCell"
    var cartDetailsViewController : CartDetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXIBWithTableView()
        initializeTableView()
        nestedJsonSerialization()
    }
    
    func registerXIBWithTableView(){
        let uiNib = UINib(nibName: cartCollectionViewCellIdentifier, bundle: nil)
        self.cartCollectionView.register(uiNib, forCellWithReuseIdentifier: cartCollectionViewCellIdentifier)
    }
    
    func initializeTableView(){
        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
    }
    
    func nestedJsonSerialization(){
        let urlString = URL(string: "https://fakestoreapi.com/carts")
        var urlRequest = URLRequest(url: urlString!)
        urlRequest.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
            let jsonResponse = try! JSONSerialization.jsonObject(with: data!) as! [[String : Any]]
            
            for eachCartResponse in jsonResponse{
                let cartDictionary = eachCartResponse
                let cartId = cartDictionary["id"] as! Int
                let cartDate = cartDictionary["date"] as! String
                let cartProducts = cartDictionary["products"] as! [[String : Any]]
                var prObject: [Products]? = []
                for productResponse in cartProducts {
                    let cartProductId = productResponse["productId"] as! Int
                    let cartProductQuantity = productResponse["quantity"] as! Int
                    prObject?.append(Products(productId: cartProductId , quantity: cartProductQuantity))
                }
                self.cart.append(Cart(id: cartId, date: cartDate, products: prObject ?? []))
            }
            DispatchQueue.main.async {
                self.cartCollectionView.reloadData()
            }
        }
        dataTask.resume()
    }
}

//MARK : UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cartCollectionViewCell = self.cartCollectionView.dequeueReusableCell(withReuseIdentifier: cartCollectionViewCellIdentifier, for: indexPath) as! CartCollectionViewCell
        cartCollectionViewCell.cartIdLabel.text = String(cart[indexPath.row].id)
        cartCollectionViewCell.cartDateLabel.text = String(cart[indexPath.row].date)
        return cartCollectionViewCell
    }
}

//MARK : UICollectionViewDelegate
extension ViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cartDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "CartDetailsViewController") as? CartDetailsViewController
        cartDetailsViewController?.products = cart[indexPath.row].products
        navigationController?.pushViewController(cartDetailsViewController!, animated: true)
        
    }
}

//MARK : UICollectionViewDelegateFlowLayout
extension ViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
}
