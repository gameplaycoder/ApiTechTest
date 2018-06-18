//
//  ClientApi.swift
//  ApiTechTest
//
//  Created by abid rana on 18/06/2018.
//  Copyright © 2018 Abid. All rights reserved.
//

import Foundation


final class ClientApi {

    static let apiKey = "Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
    static let baseUrl = "https://api.johnlewis.com/v1/products/"
    
    static let searchUrl = baseUrl+"search"
    
    private init()
    {
        
    }
    
    func getQueryProduct(productType:String, productsPerPage:Int) ->String
    {
         return "q=\(productType)&key=\(ClientApi.apiKey)&pageSize=\(productsPerPage)"
    }
    
    class var shared:ClientApi {
        
        struct SingletonWrapper {
            
            static let singleton = ClientApi()
            
        }
        return SingletonWrapper.singleton;
    }
    
}


