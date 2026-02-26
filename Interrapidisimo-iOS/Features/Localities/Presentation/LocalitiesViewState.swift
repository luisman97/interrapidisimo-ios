//
//  LocalitiesViewState.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

enum LocalitiesViewState {
    case loading
    case loaded([Locality])
    case failed(String)
}
