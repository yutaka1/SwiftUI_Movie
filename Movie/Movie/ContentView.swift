//
//  ContentView.swift
//  Movie
//
//  Created by SHIRAHATA YUTAKA on 2020/12/07.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        NavigationView {
            List(selectlist){
                selectlist in
                NavigationLink(destination: selectlist.filename){
                        Text(selectlist.name)
                }
            }
            .navigationTitle("Movie")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

