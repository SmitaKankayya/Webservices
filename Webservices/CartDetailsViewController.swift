//
//  CartDetailsViewController.swift
//  Webservices
//
//  Created by Smita Kankayya on 28/12/23.
//

import UIKit

class CartDetailsViewController: UIViewController {
    
    @IBOutlet weak var cartProductTableView: UITableView!
    var products : [Products] = []
    var productTableViewCell : ProductTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCartProductTV()
        registerXIBWithCartProductTV()
    }
    
    func  initializeCartProductTV(){
        cartProductTableView.dataSource = self
        cartProductTableView.delegate = self
        
    }
    
    func registerXIBWithCartProductTV(){
        let uiNib = UINib(nibName:"ProductTableViewCell", bundle: nil)
        self.cartProductTableView.register(uiNib, forCellReuseIdentifier: "ProductTableViewCell")
    }
}

//MARK: UITableViewDataSource
extension CartDetailsViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        productTableViewCell = self.cartProductTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell
        productTableViewCell?.productId.text = String("productId: \(products[indexPath.row].productId)")
        productTableViewCell?.productQuantity.text = String("quantity: \(products[indexPath.row].quantity)")
        return productTableViewCell!
    }
}

//MARK: UITableViewDelegate
extension CartDetailsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
}
