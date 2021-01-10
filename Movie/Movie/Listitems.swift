//
//  Listitems.swift
//  Movie
//
//  Created by SHIRAHATA YUTAKA on 2020/12/08.
//
import SwiftUI
import Foundation

struct Listitems: Identifiable {
    var id: Int
    let name: String
    var filename: AnyView? = nil
}

let selectlist: [Listitems] = [
    Listitems(id: 0, name: "動画", filename: AnyView(Mirror())),
]
