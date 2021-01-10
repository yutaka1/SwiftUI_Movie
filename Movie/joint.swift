//
//  joint.swift
//  Syosabi
//
//  Created by SHIRAHATA YUTAKA on 2020/12/08.
//

import SwiftUI

struct joint: View {
    @ObservedObject private var getmovie = GetMovie()
    var body: some View{
        VStack{
            //撮影画像がない場合
                Spacer()
            
                ZStack(alignment: .bottom){
                    //preview用のlayerを作成
                    CALayerView(caLayer: getmovie.previewLayer)
                
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
                                .padding(.top, 85.0)
                                Spacer()
                            }
                            
                            Spacer()
                            Spacer()
                            Spacer()

                            HStack{
                                Spacer()
                                if(getmovie.image != nil){
                                    Image(uiImage: getmovie.image!)
                                        .resizable()
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                            .padding(.top, 130.0)
                            
                            Spacer()
 
                        }
                        
                        
                        
                        
                    }
                }.onAppear {//viewが出てきたときの実行アクション
                    self.getmovie.startSession()
                }.onDisappear{//viewが閉じるときの実行アクション
                    self.getmovie.endSession()
                }
        
                Spacer()
                //画像が撮影されたとき
            }
       
            .edgesIgnoringSafeArea(.all)
    }
}

struct joint_Previews: PreviewProvider {
    static var previews: some View {
        joint()
    }
}
