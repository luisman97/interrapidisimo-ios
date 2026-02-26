//
//  LocalityDTOTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
import Foundation
@testable import Interrapidisimo_iOS

@Suite("LocalityDTO")
@MainActor
struct LocalityDTOTests {

    private let validJSON = """
    {
        "IdLocalidad": "001",
        "AbreviacionCiudad": "BOG",
        "NombreCompleto": "Bogotá D.C."
    }
    """

    // MARK: Decoding – required fields

    @Test func decode_parsesLocalityId() async throws {
        let dto = try decode(validJSON)
        #expect(dto.localityId == "001")
    }

    @Test func decode_parsesCityAbbreviation() async throws {
        let dto = try decode(validJSON)
        #expect(dto.cityAbbreviation == "BOG")
    }

    @Test func decode_parsesFullName() async throws {
        let dto = try decode(validJSON)
        #expect(dto.fullName == "Bogotá D.C.")
    }

    // MARK: Decoding – error cases

    @Test func decode_throwsError_whenLocalityIdMissing() async {
        let json = """
        { "AbreviacionCiudad": "BOG", "NombreCompleto": "Bogotá D.C." }
        """
        #expect(throws: (any Error).self) {
            try decode(json)
        }
    }

    @Test func decode_throwsError_whenCityAbbreviationMissing() async {
        let json = """
        { "IdLocalidad": "001", "NombreCompleto": "Bogotá D.C." }
        """
        #expect(throws: (any Error).self) {
            try decode(json)
        }
    }

    @Test func decode_throwsError_whenFullNameMissing() async {
        let json = """
        { "IdLocalidad": "001", "AbreviacionCiudad": "BOG" }
        """
        #expect(throws: (any Error).self) {
            try decode(json)
        }
    }

    // MARK: Decoding – array

    @Test func decode_parsesArrayOfLocalities() async throws {
        let json = """
        [
            { "IdLocalidad": "001", "AbreviacionCiudad": "BOG", "NombreCompleto": "Bogotá D.C." },
            { "IdLocalidad": "002", "AbreviacionCiudad": "MED", "NombreCompleto": "Medellín" },
            { "IdLocalidad": "003", "AbreviacionCiudad": "CAL", "NombreCompleto": "Cali" }
        ]
        """
        let dtos = try JSONDecoder().decode([LocalityDTO].self, from: Data(json.utf8))
        #expect(dtos.count == 3)
        #expect(dtos[0].cityAbbreviation == "BOG")
        #expect(dtos[1].localityId == "002")
        #expect(dtos[2].fullName == "Cali")
    }

    // MARK: Mapper – toDomain

    @Test func toDomain_mapsAllFieldsFromDTO() async throws {
        let dto = try decode(validJSON)
        let domain = dto.toDomain

        #expect(domain.localityId == dto.localityId)
        #expect(domain.cityAbbreviation == dto.cityAbbreviation)
        #expect(domain.fullName == dto.fullName)
    }

    @Test func toDomain_preservesSpecialCharacters() async throws {
        let json = """
        { "IdLocalidad": "099", "AbreviacionCiudad": "CTG", "NombreCompleto": "Cartagena de Indias" }
        """
        let domain = try decode(json).toDomain
        #expect(domain.fullName == "Cartagena de Indias")
    }

    // MARK: Helper

    private func decode(_ json: String) throws -> LocalityDTO {
        try JSONDecoder().decode(LocalityDTO.self, from: Data(json.utf8))
    }
}
