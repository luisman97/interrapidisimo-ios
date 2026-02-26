//
//  LoginRequestDTO.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let mac: String
    let applicationName: String
    let password: String
    let path: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case mac = "Mac"
        case applicationName = "NomAplicacion"
        case password = "Password"
        case path = "Path"
        case username = "Usuario"
    }

    init(
        encodedUsername: String,
        encodedPassword: String
    ) {
        self.mac = ""
        self.applicationName = "Controller APP"
        self.password = encodedPassword
        self.path = ""
        self.username = encodedUsername
    }
}
