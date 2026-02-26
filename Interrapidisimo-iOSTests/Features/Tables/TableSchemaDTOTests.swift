//
//  TableSchemaDTOTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
import Foundation
@testable import Interrapidisimo_iOS

@Suite("TableSchemaDTO")
@MainActor
struct TableSchemaDTOTests {

    // Full valid JSON with all optional fields null
    private let fullJSON = """
    {
        "NombreTabla": "TBL_CLIENTES",
        "Pk": "ID_CLIENTE",
        "QueryCreacion": "CREATE TABLE TBL_CLIENTES (ID_CLIENTE INT PRIMARY KEY)",
        "BatchSize": 500,
        "Filtro": "ACTIVO = 1",
        "Error": null,
        "NumeroCampos": 10,
        "MetodoApp": null,
        "FechaActualizacionSincro": "2026-01-15"
    }
    """

    // MARK: Decoding – required fields

    @Test func decode_parsesTableName() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.tableName == "TBL_CLIENTES")
    }

    @Test func decode_parsesPk() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.pk == "ID_CLIENTE")
    }

    @Test func decode_parsesCreationQuery() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.creationQuery.hasPrefix("CREATE TABLE"))
    }

    @Test func decode_parsesBatchSize() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.batchSize == 500)
    }

    @Test func decode_parsesFilter() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.filter == "ACTIVO = 1")
    }

    @Test func decode_parsesFieldCount() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.fieldCount == 10)
    }

    @Test func decode_parsesLastSyncDate() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.lastSyncDate == "2026-01-15")
    }

    // MARK: Decoding – optional fields absent

    @Test func decode_parsesErrorAsNil_whenAbsent() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.error == nil)
    }

    @Test func decode_parsesAppMethodAsNil_whenAbsent() async throws {
        let dto = try decode(fullJSON)
        #expect(dto.appMethod == nil)
    }

    // MARK: Decoding – optional fields present

    @Test func decode_parsesError_whenPresent() async throws {
        let json = """
        {
            "NombreTabla": "TBL_X", "Pk": "ID", "QueryCreacion": "CREATE TABLE TBL_X (ID INT)",
            "BatchSize": 100, "Filtro": "", "Error": "Connection timeout",
            "NumeroCampos": 1, "MetodoApp": null, "FechaActualizacionSincro": "2026-02-01"
        }
        """
        let dto = try decode(json)
        #expect(dto.error == "Connection timeout")
    }

    @Test func decode_parsesAppMethod_whenPresent() async throws {
        let json = """
        {
            "NombreTabla": "TBL_Y", "Pk": "ID", "QueryCreacion": "CREATE TABLE TBL_Y (ID INT)",
            "BatchSize": 50, "Filtro": "", "Error": null,
            "NumeroCampos": 2, "MetodoApp": "GetPedidos", "FechaActualizacionSincro": "2026-02-01"
        }
        """
        let dto = try decode(json)
        #expect(dto.appMethod == "GetPedidos")
    }

    // MARK: Decoding – error cases

    @Test func decode_throwsError_whenRequiredFieldMissing() {
        let json = #"{ "NombreTabla": "TBL_X" }"#
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(TableSchemaDTO.self, from: Data(json.utf8))
        }
    }

    @Test func decode_throwsError_whenBatchSizeIsWrongType() {
        let json = """
        {
            "NombreTabla": "TBL_X", "Pk": "ID", "QueryCreacion": "...",
            "BatchSize": "not-a-number", "Filtro": "", "Error": null,
            "NumeroCampos": 1, "MetodoApp": null, "FechaActualizacionSincro": "2026-01-01"
        }
        """
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(TableSchemaDTO.self, from: Data(json.utf8))
        }
    }

    // MARK: Decoding – array

    @Test func decode_parsesArrayOfDTOs() throws {
        let json = """
        [
            {
                "NombreTabla": "TBL_A", "Pk": "ID_A",
                "QueryCreacion": "CREATE TABLE TBL_A (ID_A INT)",
                "BatchSize": 100, "Filtro": "", "Error": null,
                "NumeroCampos": 1, "MetodoApp": null, "FechaActualizacionSincro": "2026-01-01"
            },
            {
                "NombreTabla": "TBL_B", "Pk": "ID_B",
                "QueryCreacion": "CREATE TABLE TBL_B (ID_B INT)",
                "BatchSize": 200, "Filtro": "ESTADO = 1", "Error": null,
                "NumeroCampos": 3, "MetodoApp": "GetB", "FechaActualizacionSincro": "2026-01-02"
            }
        ]
        """
        let dtos = try JSONDecoder().decode([TableSchemaDTO].self, from: Data(json.utf8))
        #expect(dtos.count == 2)
        #expect(dtos[0].tableName == "TBL_A")
        #expect(dtos[1].tableName == "TBL_B")
        #expect(dtos[1].appMethod == "GetB")
    }

    // MARK: Mapper – toDomain

    @Test func toDomain_mapsAllFieldsFromDTO() async throws {
        let dto = try decode(fullJSON)
        let domain = dto.toDomain

        #expect(domain.tableName == dto.tableName)
        #expect(domain.pk == dto.pk)
        #expect(domain.creationQuery == dto.creationQuery)
        #expect(domain.batchSize == dto.batchSize)
        #expect(domain.filter == dto.filter)
        #expect(domain.error == dto.error)
        #expect(domain.fieldCount == dto.fieldCount)
        #expect(domain.appMethod == dto.appMethod)
        #expect(domain.lastSyncDate == dto.lastSyncDate)
    }

    @Test func toDomain_propagatesNilOptionals() async throws {
        let dto = try decode(fullJSON)
        let domain = dto.toDomain
        #expect(domain.error == nil)
        #expect(domain.appMethod == nil)
    }

    // MARK: Helper

    private func decode(_ json: String) throws -> TableSchemaDTO {
        try JSONDecoder().decode(TableSchemaDTO.self, from: Data(json.utf8))
    }
}
