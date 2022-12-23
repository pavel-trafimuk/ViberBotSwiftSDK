//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 23/12/2022.
//

import Foundation
import Vapor

public struct DatabaseSetup {
    let app: Application
    
    // TODO: maybe not correct order
    public func prepare() throws {
        app.databases.use(.sqlite(.file("viberBot.sqlite")), as: .sqlite)
        app.migrations.add(CreateSubscriber())
        try app.autoMigrate().wait()
    }
}

extension Application {
    public var viberDatabase: DatabaseSetup {
        .init(app: self)
    }
}
