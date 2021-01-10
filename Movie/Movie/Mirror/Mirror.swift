//
//  Mirror.swift
//  Movie
//
//  Created by SHIRAHATA YUTAKA on 2020/12/08.
//

import SwiftUI

struct Mirror: View {
  //@ObservedObject private var avFoundationVM = AVFoundationVM()
  //  @State var screen: CGSize!
    var body: some View{
        GeometryReader { bodyView in
            HStack{
                Spacer()
                VStack{
                    let height6 = CGFloat(bodyView.size.height/10)
                    let height4 = CGFloat(bodyView.size.height/12)
                        
                    Spacer().frame(height: height4)
                    NavigationLink(destination: Freemode()){
                        Text("Movie")
                            .frame(width: 180, height: height6,
                                   alignment: .center)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                    }
                  
                   
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct Mirror_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Mirror()
        }
    }
}

