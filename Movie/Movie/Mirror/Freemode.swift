//
//  freemode.swift
//  Movie
//
//  Created by SHIRAHATA YUTAKA on 2020/12/11.
//

import SwiftUI
import Combine


struct Freemode: View {
    @ObservedObject var getmovie = GetMovie()
    @State var image_name = "bone"
    @State var isviewdisable = false
    var body: some View{

        VStack{
        GeometryReader { bodyView in
            Spacer()
            ZStack(alignment: .bottom){
                //preview用のlayerを作成
                CALayerView(caLayer: getmovie.previewLayer)
                //描画
                if getmovie.takingmovie == true{

                    if(getmovie.image != nil){
                        //背景
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                        
                        //イメージの描画
                            VStack{
                                Spacer().frame(height: bodyView.size.height*0.19)
                                HStack(alignment: .top, spacing: 1.5){
                                    
                                    Group{
                                        //子viewにframeカメラ情報を渡す
                                        Freemodeimage(getmovie: getmovie)
                                        Freemodeimage(getmovie: getmovie)
                                        Freemodeimage(getmovie: getmovie)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 3.0){
                                        if getmovie.isrecordmovie{
                                            Text("録画:"+Int(Date().timeIntervalSince(getmovie.Startrectime)).description)
                                                .foregroundColor(Color.white)
                                        }
                                        if getmovie.isanimation {
                                            Text("再生:"+Int(Date().timeIntervalSince(getmovie.Startrectime)).description)
                                                .foregroundColor(Color.white)
                                        }
                                   
                                        Image(image_name)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                        
                                        Spacer().frame(height: bodyView.size.height*0.03)
                                            
                                        //Capture ボタン
                                            Button(action: {
                                            if (getmovie.isviewimage1 == false) && (getmovie.isviewimage2 == false){
                                                getmovie.captureimage1()
                                                image_name = "bone_image1"
                                            }
                                            else if (getmovie.isviewimage1 == true) && (getmovie.isviewimage2 == false){
                                                getmovie.captureimage2()
                                                image_name = "captureall"
                                            }
                                            else if (getmovie.isviewimage1 == true) && (getmovie.isviewimage2 == true){
                                                if getmovie.repeatflug == false{
                                                    getmovie.captureimage1()
                                                    getmovie.repeatflug = true
                                                    image_name = "capture_image1"
                                                }
                                                else{
                                                    getmovie.captureimage2()
                                                    getmovie.repeatflug = false
                                                    image_name = "capture_image2"
                                                }
                                            }
                                        }){
                                            Text("静止画")
                                                .foregroundColor(Color.red)
                                                .background((getmovie.isanimation ||  getmovie.isrecordmovie || isviewdisable) ? Color.black : Color.white)
                                                .fixedSize()
                                        }
                                        .disabled(getmovie.isanimation)
                                        .disabled(getmovie.isrecordmovie)
                                        .disabled(isviewdisable)

                                            
                                        //Changeボタン
                                        Button(action: {
                                            if(getmovie.isviewimage2 == true){
                                                //初期状態ー＞プレビューのみ
                                                if (getmovie.ischange == true) && (getmovie.ischange1 == true) && (getmovie.ischange2 == true){
                                                    getmovie.ischange1 = false
                                                    getmovie.ischange2 = false
                                                    getmovie.iscapture = true
                                                    isviewdisable = false
                                                    image_name = "bone"
                                                }
                                                //->1枚目
                                                else if (getmovie.ischange == true) && (getmovie.ischange1 == false) && (getmovie.ischange2 == false){
                                                    getmovie.ischange = false
                                                    getmovie.ischange1 = true
                                                    getmovie.ischange2 = false
                                                    getmovie.iscapture = true
                                                    isviewdisable = true
                                                    image_name = "capture1"
                                                }
                                                //->2枚目
                                                else if (getmovie.ischange == false) && (getmovie.ischange1 == true) && (getmovie.ischange2 == false){
                                                    getmovie.ischange = false
                                                    getmovie.ischange1 = false
                                                    getmovie.ischange2 = true
                                                    getmovie.iscapture = true
                                                    isviewdisable = true
                                                    image_name = "capture2"
                                                }

                                                else{
                                                    getmovie.ischange = true
                                                    getmovie.ischange1 = true
                                                    getmovie.ischange2 = true
                                                    getmovie.iscapture = false
                                                    isviewdisable = false
                                                    image_name = "captureall"
                                                }
                                            }
                                            //2枚目が無いとき
                                            else{
                                                //初期状態ー＞プレビューのみ
                                                if (getmovie.ischange == true) && (getmovie.ischange1 == true){
                                                    getmovie.ischange1 = false
                                                    getmovie.iscapture = true
                                                    isviewdisable = false
                                                    image_name = "bone"
                                                }
                                                //->1枚目
                                                else if (getmovie.ischange == true) && (getmovie.ischange1 == false){
                                                    getmovie.ischange = false
                                                    getmovie.ischange1 = true
                                                    getmovie.ischange2 = false
                                                    getmovie.iscapture = true
                                                    isviewdisable = true
                                                    image_name = "capture1"
                                                }
                                                else{
                                                    getmovie.ischange = true
                                                    getmovie.ischange1 = true
                                                    getmovie.iscapture = false
                                                    isviewdisable = false
                                                    image_name = "bone_image1"
                                                }
                                            }
                                            

                                        }){
                                            Text("表示切替")
                                                .foregroundColor(Color.red)
                                                .background((getmovie.isrecordmovie || getmovie.isanimation || !getmovie.isviewimage1) ? Color.black : Color.white)
                                                .fixedSize()
                                        }
                                        .disabled(getmovie.isanimation)
                                        .disabled(getmovie.isrecordmovie)
                                        .disabled(!getmovie.isviewimage1)


                                        
                                        //Recordボタン
                                        Button(action: {
                                            getmovie.recordmovie()
                                        }){
                                            Text("録画")
                                                .foregroundColor(Color.red)
                                                .background((getmovie.isanimation || isviewdisable ) ? Color.black : Color.white)
                                                .fixedSize()
                                        }
                                        .disabled(getmovie.isanimation)
                                        .disabled(isviewdisable)
                                       
                                        
                                        //再生ボタン
                                        Button(action: {
                                            getmovie.count = 0
                                            getmovie.isanimation = true
                                            getmovie.Startrectime = Date().addingTimeInterval(0)
                                        }){
                                            Text("再生")
                                                .foregroundColor(Color.red)
                                                .background((getmovie.isrecordmovie || getmovie.isanimation || isviewdisable || !getmovie.isfinishmovie) ? Color.black : Color.white)
                                                .fixedSize()
                                        }
                                        .disabled(getmovie.isrecordmovie)
                                        .disabled(getmovie.isanimation)
                                        .disabled(isviewdisable)
                                        .disabled(!getmovie.isfinishmovie)
                                        
                                        //Clearボタン
                                        Button(action: {
                                            getmovie.clearall()
                                            getmovie.isanimation = false
                                            image_name = "bone"
                                        }){
                                            Text("リセット")
                                                .foregroundColor(Color.red)
                                                .background(Color.white)
                                                .fixedSize()
                                        }
                                            
                                    }
                                }
                            }
                            .edgesIgnoringSafeArea(.all)
                    }
 
                    else{
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            }.onAppear {//viewが出てきたときの実行アクション
                self.getmovie.startMovie()
                self.getmovie.startSession()
                self.getmovie.clearall()
            }.onDisappear{//viewが閉じるときの実行アクション
                self.getmovie.stopMovie()
                self.getmovie.endSession()
                self.getmovie.clearall()
            }
            .edgesIgnoringSafeArea(.all)
        
            Spacer()
        }
        }
        
        
    }
}


struct Freemode_Previews: PreviewProvider {
    static var previews: some View {
        Freemode()
    }
}
