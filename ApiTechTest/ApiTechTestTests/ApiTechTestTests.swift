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
        
        if var urlComponents = URLComponents(string: ClientApi.baseUrl) {//
            
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
    
    func testServerShouldReturnListOfProductsGivenProductsPerPage()
    {
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download products from server")
        
        if var urlComponents = URLComponents(string: ClientApi.baseUrl) {//
            
            urlComponents.query = "q=dishwasher&key=\(ClientApi.apiKey)&pageSize=20"
            
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
    
    
}
