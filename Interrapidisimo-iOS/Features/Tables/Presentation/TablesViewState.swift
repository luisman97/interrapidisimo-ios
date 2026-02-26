//
//  TablesViewState.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

enum TablesViewState {
    case loading
    case loaded([TableSchema])
    case failed(String)
}
