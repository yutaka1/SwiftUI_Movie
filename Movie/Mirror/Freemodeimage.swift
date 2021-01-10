//
//  Freemodeimage.swift
//  Movie
//
//  Created by SHIRAHATA YUTAKA on 2020/12/14.
//

import SwiftUI

struct animationimage: UIViewRepresentable {
    @ObservedObject var getmovie: GetMovie
    var rect: CGRect!
    
    func makeUIView(context: Self.Context) -> some UIView {
        let imageView:UIImageView = UIImageView(frame: rect)
        let myView = UIView(frame: rect)
        // view に追加する
        imageView.animationImages = getmovie.recimages
        imageView.frame = rect
        imageView.animationDuration = Double(Double(getmovie.recimages.count)/Double(getmovie.framerate))
        imageView.animationRepeatCount = 1
        imageView.translatesAutoresizingMaskIntoConstraints = true
        
        myView.addSubview(imageView)
        imageView.startAnimating()
        myView.autoresizesSubviews = true
        myView.autoresizingMask = [.flexibleWidth]

        return myView
    }
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<animationimage>) {
        DispatchQueue.main.async {
            getmovie.count += 1
            if Int(Date().timeIntervalSince(getmovie.Startrectime)) >= 5{
                getmovie.isanimation = false
            }
        }
    }
}

struct Freemodeimage: View {
    @ObservedObject var getmovie: GetMovie
    var body: some View {
        ZStack{
            GeometryReader { bodyView in

                if getmovie.ischange == true{
                    Image(uiImage: getmovie.image!)
                        .resizable()
                        .frame(width: bodyView.size.width, height:
                                bodyView.size.height)
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .opacity(0.7)
                }
                

                Group{
                    if (getmovie.isviewimage1 == true) && (getmovie.ischange1 == true) {
                        Image(uiImage: getmovie.capimage1!)
                            .resizable()
                            .frame(width: bodyView.size.width, height:
                                    bodyView.size.height)
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    if (getmovie.isviewimage1 == true) && (getmovie.isviewimage2 == true) && (getmovie.ischange2 == true) {
                        Image(uiImage: getmovie.capimage2!)
                            .resizable()
                            .frame(width: bodyView.size.width, height:
                                    bodyView.size.height)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .scaledToFill()
                .opacity(0.3)
                if getmovie.isanimation == true{
                    animationimage(getmovie: getmovie, rect: bodyView.frame(in: .local))
                }

            }
        }
            
    }
}
