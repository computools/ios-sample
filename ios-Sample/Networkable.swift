//
//  Networkable.swift
//  MyCar2
//
//  Created by Roman Litoshko on 9/7/18.
//  Copyright © 2018 Armen. All rights reserved.
//

import Foundation
import Moya

protocol Networkable {
    var provider:MoyaProvider<MyCarAPI> {get}
    func login(username:String, password: String, complition: @escaping (AuthData?)->())
    func register(firstName:String, email:String, password: String, complition: @escaping (AuthData?)->())
    func googleLogin(firstName:String, email:String, googleID:String, lastName: String, complition: @escaping (AuthData?)->())
    func facebookLogin(complition: @escaping (AuthData?) -> ())
    func refreshFBSToken(oldToken: String, newToken: String,_ complition: @escaping (Bool?) -> ())
    func sendLog(logType: LogType)
}
