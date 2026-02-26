//
//  LoginViewState.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

enum LoginViewState: Equatable {
    case idle
    case loading
    case failed(String)
    case success
}
