//
//  LocalityDTO+Mapping.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

extension LocalityDTO {
    var toDomain: Locality {
        Locality(
            localityId: localityId,
            cityAbbreviation: cityAbbreviation,
            fullName: fullName
        )
    }
}
