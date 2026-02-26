//
//  LoginResponseDTO.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

struct LoginResponseDTO: Decodable, Sendable {
    let username: String
    let documentId: String?
    let firstName: String?
    let firstSurname: String?
    let secondSurname: String?
    let jobTitle: String?
    let resultCode: Int
    let localityId: String?
    let localityName: String?
    let roleName: String?
    let roleId: String?
    let jwtToken: String?

    enum CodingKeys: String, CodingKey {
        case username = "Usuario"
        case documentId = "Identificacion"
        case firstName = "Nombre"
        case firstSurname = "Apellido1"
        case secondSurname = "Apellido2"
        case jobTitle = "Cargo"
        case resultCode = "MensajeResultado"
        case localityId = "IdLocalidad"
        case localityName = "NombreLocalidad"
        case roleName = "NomRol"
        case roleId = "IdRol"
        case jwtToken = "TokenJWT"
    }
}
