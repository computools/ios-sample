//
//  UserModel.swift
//  MyCar2
//
//  Created by Roman Litoshko on 9/10/18.
//  Copyright © 2018 Armen. All rights reserved.
//

import Foundation

struct User: Codable {
    let status: String?
    let role: Int?
    let firstName, lastName: String?
    let googleID: String?
    let facebookID: String?
    let email: String?
    let lat, lng, password, id: String?
    let resetPassword, phone, remoteAddr: String?
    let region, fbID, vkID: String?
    
    enum CodingKeys: String, CodingKey {
        case status, role
        case firstName = "first_name"
        case lastName = "last_name"
        case googleID = "google_id"
        case facebookID = "facebook_id"
        case email, lat, lng, password, id
        case resetPassword = "reset_password"
        case phone
        case remoteAddr = "remote_addr"
        case region
        case fbID = "fb_id"
        case vkID = "vk_id"
    }
}

struct FBUserModel {
    let id: Int
    let email: String?
    let name: String
}
