//
//  NetworkManager.swift
//  MyCar2
//
//  Created by Roman Litoshko on 9/6/18.
//  Copyright © 2018 Armen. All rights reserved.
//

import Foundation
import Moya
import FBSDKLoginKit
import SwiftyJSON

enum APIEnvironment {
    case production
    case qa
    case staging
}

struct NetworkManager: Networkable {
    var provider = MoyaProvider<MyCarAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    static let environment: APIEnvironment = .staging
    private let decoder = JSONDecoder()
    
    //    MARK: - Auth Methods
    func login(username: String, password: String, complition: @escaping (AuthData?) -> ()) {
        provider.request(.login(username: username, password: password)) { (result) in

            switch result {
            case let .success(response):
                
                do {
                 
                  let model = try self.decoder.decode(DataResponse.self, from: response.data)
                    complition(model.data)
                    print("Auth Model -> \(model)")
                } catch (let error) {
                    print("Can't parse JSON with error \(error.localizedDescription)")
                }
                
                print(response)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func register(firstName: String, email: String, password: String, complition: @escaping (AuthData?) -> ()) {
        provider.request(.register(firstname: firstName, password: password, email: email)) { (result) in
            switch result {
            case let .success(response):
                
                do {
                    let json = try? JSON(data: response.data).dictionaryValue
                    let model = try self.decoder.decode(DataResponse.self, from: response.data)
                    complition(model.data)
                    print("Auth Model -> \(model.data)")
                } catch (let error) {
                    print("Can't parse JSON with error \(error.localizedDescription)")
                }
                
                print(response)
            case let .failure(error):
                print(error)
            }
        }
    }
//    MARK: - Google and FB Login
    func googleLogin(firstName: String, email: String, googleID: String, lastName: String, complition: @escaping (AuthData?) -> ()) {
        provider.request(.googleLogin(firstname: firstName, lastname: lastName, googleID: googleID, email: email)) { (result) in
            
            switch result {
            case let .success(response):
                
                do {
                    let model = try self.decoder.decode(DataResponse.self, from: response.data)
                    complition(model.data)
                } catch (let error) {
                    print("Can't parse JSON with error \(error.localizedDescription)")
                }
                
                print(response)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    func facebookLogin(complition: @escaping (AuthData?) -> ())  {
        self.getFBUserData { (data) in
            complition(data)
        }
        
    }
    
    func refreshFBSToken(oldToken: String, newToken: String, _ complition: @escaping (Bool?) -> ()) {
        self.provider.request(.refreshDeviceToken(oldToken: oldToken, newToken: newToken)) { (response) in
            switch response {
            case .success( _):
                complition(true)
            case .failure( _) :
                complition(false)
            }
        }
    }
    
    func sendLog(logType: LogType) {
        self.provider.request(.logData(logType: logType)) { (result) in
            switch result {
            case .success( _):
                print("Log Data Success")
            case .failure( _):
                print("Log Data Failure")
            }
        }
    }
    
    //    MARK: - Private
    
    fileprivate func getFBUserData(complition: @escaping (AuthData?) -> ()) {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    let fullName = dict["name"] as! String
                    let fullNameArr = fullName.components(separatedBy: " ")
                    let name    = fullNameArr[0]
                    let surname = fullNameArr[1]
                    let id = dict["id"] as! String
                    let email = dict["email"] as! String
                    
                    self.provider.request(.facebookLogin(firstName:name , lastName: surname, facebookID: Int(id)!, email: email), completion: { (result) in
                        switch result {
                        case let .success(response):
                            
                            do {
                                let model = try self.decoder.decode(DataResponse.self, from: response.data)
                                complition(model.data)
                                print("")
                            } catch (let error) {
                                print("Can't parse JSON with error \(error.localizedDescription)")
                            }
                            
                            print(response)
                        case let .failure(error):
                            print(error)
                        }
                    })
                }
            })
        }
    }
    
    

}
