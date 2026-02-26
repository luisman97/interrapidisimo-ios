//
//  LocalityDTO.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

struct LocalityDTO: Decodable {
    let localityId: String
    let cityAbbreviation: String
    let fullName: String

    enum CodingKeys: String, CodingKey {
        case localityId = "IdLocalidad"
        case cityAbbreviation = "AbreviacionCiudad"
        case fullName = "NombreCompleto"
    }
}
