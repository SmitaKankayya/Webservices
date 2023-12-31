//
//  Cart.swift
//  Webservices
//
//  Created by Smita Kankayya on 28/12/23.
//

import Foundation

struct Cart{
    var id : Int
    var date : String
    var products : [Products]
   
}

struct Products{
    var productId : Int
    var quantity : Int
}






