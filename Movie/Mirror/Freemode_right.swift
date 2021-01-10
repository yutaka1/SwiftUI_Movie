//
//  Freemode_right.swift
//  Syosabi
//
//  Created by SHIRAHATA YUTAKA on 2020/12/11.
//

import SwiftUI

struct Freemode_right: View {
    @ObservedObject private var getmovie = GetMovie()
    var body: some View {
        let uiwidth = UIScreen.main.bounds.size.width
        
        Spacer()
        ZStack(alignment: .bottom){
            //preview用のlayerを作成
            CALayerView(caLayer: getmovie.previewLayer)
            //描画
            if getmovie.takingmovie == true{
                VStack{
                    HStack{
                        //リセット
                        Button(action: {
                            getmovie.stopMovie()
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.white)
                        }
                        //.frame(width: 100, height: 100, alignment: .center)
                        .padding(.top, 85.0)
                        Spacer()
                    }
                    
                    Spacer().frame(height: 197)

                    HStack{
                        Spacer()
                        if(getmovie.image != nil){
                            Image(uiImage: getmovie.image!)
                                .resizable()
                                //.frame(width: 200, height: 200, alignment: .center)
                                .frame(width: uiwidth, height: 200, alignment: .center)

                                .scaledToFill()
                                .aspectRatio(contentMode: .fit)
                                //.luminanceToAlpha()
                                .opacity(0.3)
                        }
                    }
                    .padding(.top, 50.0)
                    
                    Spacer()

                }
            }
            else{
                //撮影用のボタンを実装
                Button(action:{
                    //撮影開始フラグをONにする
                    print("start movie")
                    getmovie.startMovie()
                }){
                    //撮影ボタンに実装
                    Image(systemName: "camera.circle.fill")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 80, height: 80,
                        alignment: .center)
                }
                .padding(.bottom, -10.0)
            }
           
            
            
        }.onAppear {//viewが出てきたときの実行アクション
            self.getmovie.startSession()
        }.onDisappear{//viewが閉じるときの実行アクション
            self.getmovie.endSession()
        }
        .edgesIgnoringSafeArea(.all)
    
        Spacer()
    }
}

struct Freemode_right_Previews: PreviewProvider {
    static var previews: some View {
        Freemode_right()
    }
}
