//
//  ApiTechTestTests.swift
//  ApiTechTestTests
//
//  Created by abid rana on 18/06/2018.
//  Copyright © 2018 Abid. All rights reserved.
//

import XCTest
@testable import ApiTechTest

class ApiTechTestTests: XCTestCase {
    
    let urlSession = URLSession(configuration: .default)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServerShouldRespondWithDataAndStatusCode200()
    {
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download data from server")
        
        print("ClientApi.searchUrl \(ClientApi.searchUrl)")
        
        if var urlComponents = URLComponents(string: ClientApi.searchUrl) {//
            
            urlComponents.query = "q=dishwasher&key=\(ClientApi.apiKey)&pageSize=20"
            
            let dataTask = urlSession.dataTask(with: urlComponents.url!) { data, response, error in
                
                if let errorReturn = error {
                    
                    print("url error: \(errorReturn.localizedDescription)")
                    
                }
                else if data != nil {
                    // no error
                    
                    if let resp = response as? HTTPURLResponse {
                        
                        if resp.statusCode == 200 {
                            
                            // Make sure we downloaded some data.
                            XCTAssertNotNil(data, "No data was downloaded.")
                            
                            // Fulfill the expectation to indicate that the background task has finished successfully.
                            expectation.fulfill()
                        }
                    }
                }
            }
            dataTask.resume()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    func testApiClientShouldConstructCorrectQueryGivenProductTypeAndProductsPerPage()
    {
        // Given
        let productType = "dishwasher"
        let productsPerPage = 20
        
        // Where
        let queryString = ClientApi.shared.getQueryProduct(productType:productType, productsPerPage:productsPerPage)
        
        // Then
        XCTAssertEqual(queryString , "q=dishwasher&key=\(ClientApi.apiKey)&pageSize=20")
    }
    
    func testServerShouldReturnListOfProductsGivenProductsPerPage()
    {
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download products from server")
        
        if var urlComponents = URLComponents(string: ClientApi.searchUrl) {//
            
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
                            
                                // Make sure we downloaded some data.
                                XCTAssertTrue(productsDict.count > 0 , "No products in response")
                                
                                // Fulfill the expectation to indicate that the background task has finished successfully.
                                expectation.fulfill()
                                
                            }
                            
                        }
                    }
                }
            }
            dataTask.resume()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testServerShouldRespondWithProductDetailsGivenProductId()
    {
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download product details from server")
        
        let productId = "3215462"
        
        let url = URL(string: ClientApi.baseUrl+ClientApi.shared.getQueryProductDetails(productId: productId))
            
            //urlComponents.query = ClientApi.shared.getQueryProductDetails(productId: productId)
            
            print("\(ClientApi.baseUrl)\(ClientApi.shared.getQueryProductDetails(productId: productId))")
            
            let dataTask = urlSession.dataTask(with: url!) { data, response, error in
                
                if let errorReturn = error {
                    
                    print("url error: \(errorReturn.localizedDescription)")
                    
                }
                else if data != nil {
                    // no error
                    
                    if let resp = response as? HTTPURLResponse {
                        
                        if resp.statusCode == 200 {
                            
                            let jsonDic = try? JSONSerialization.jsonObject(with: data!) as? [String:Any]
                            
                            if let product = jsonDic!!["productId"] as? String {
                                
                                // Make sure we downloaded some data.
                                XCTAssertEqual(product , productId)
                                
                                // Fulfill the expectation to indicate that the background task has finished successfully.
                                expectation.fulfill()
                                
                            }
                            
                        }
                    }
                }
            }
            dataTask.resume()
        
            // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
            wait(for: [expectation], timeout: 10.0)
        
    }
    
}
