//
//  SubView.swift
//  Syosabi
//
//  Created by SHIRAHATA YUTAKA on 2020/12/08.
//
/*
import SwiftUI

struct SubView: View {
        var selectlist: Listitems
        @ObservedObject private var avFoundationVM = AVFoundationVM()
        var body: some View{
            if selectlist.id == 1{
                VStack{
                    //撮影画像がない場合
                    if avFoundationVM.image == nil{
                        Spacer()
                        
                        ZStack(alignment: .bottom){
                            //preview用のlayerを作成
                            CALayerView(caLayer: avFoundationVM.previewLayer)
                            
                            //撮影用のボタンを実装
                            Button(action:{
                                //撮影開始フラグをONにする
                                self.avFoundationVM.takePhoto()
                            }){
                                //撮影ボタンに実装
                                Image(systemName: "camera.circle.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 80, height: 80,
                                        alignment: .center)
                            }
                            .padding(.bottom, -10.0)
                        }.onAppear {//viewが出てきたときの実行アクション
                            self.avFoundationVM.startSession()
                        }.onDisappear{//viewが閉じるときの実行アクション
                            self.avFoundationVM.endSession()
                        }
                    
                        Spacer()
                        //画像が撮影されたとき
                    } else{
                        ZStack(alignment: .topLeading){
                            //撮影画像の表示
                            VStack{
                                Spacer()
                                
                                Image(uiImage: avFoundationVM.image!)
                                    .resizable()
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fit)
                            
                                Spacer()
                            }
                            //撮影画像を削除する
                            Button(action: {
                                self.avFoundationVM.image = nil
                            }){
                                Image(systemName: "xmark.circle.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray)
                            }
                            .frame(width: 80, height: 80, alignment: .center)
                            .padding(.top, 70.0)
                                
                        }
                    }
                }
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            else if selectlist.id == 0{
                Text(selectlist.name)
            }
            else if selectlist.id == 2{
                Text(selectlist.name)
            }
            else if selectlist.id == 3{
                Text(selectlist.name)
            }
            else if selectlist.id == 4{
                Text(selectlist.name)
            }
            else{
                Text("Error")
            }
        }
}

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        SubView(selectlist: Listitems(id: 0, name: ""))
    }
}
*/
