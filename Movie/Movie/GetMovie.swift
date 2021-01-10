//
//  GetMovie.swift
//  Movie
//
//  Created by SHIRAHATA YUTAKA on 2020/12/09.
//

import UIKit
import AVFoundation
import Combine
import opencv2
import Photos
import PhotosUI


//class GetMovie: UIViewController, AVCaptureFileOutputRecordingDelegate {
//class GetMovie: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate, ObservableObject {
class GetMovie: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {

    
    ///撮影した画像
    @Published var image: UIImage?
    //画像のキャプチャー
    @Published var capimage1: UIImage?
    @Published var capimage2: UIImage?
    @Published var iscapimage1:Bool = false
    @Published var iscapimage2:Bool = false
    @Published var isviewimage1:Bool = false
    @Published var isviewimage2:Bool = false
    @Published var repeatflug:Bool = false
    @Published var ischange:Bool = true
    @Published var ischange1:Bool = false
    @Published var ischange2:Bool = false
    @Published var iscapture:Bool = false
    //動画の開始
    @Published var isrecordmovie:Bool = false
    @Published var isopenmoviefile:Bool = false
    @Published var ismakefile = true
    @Published var isfinishmovie = false
    var wvideo = VideoWriter()
    
    //animationの作成
    @Published var recimages: [UIImage]! = []
    @Published var isanimation:Bool = false
    @Published var count:Int = 0
    @Published var framerate:Int32 = 15
    
    @Published var Startrectime = Date().addingTimeInterval(0)

    // ビデオのアウトプット
    //private var myVideoOutput: AVCaptureMovieFileOutput!
    /*
    private var filewriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var audioInput: AVAssetWriterInput?
    var lastTime: CMTime! // 最後に保存したデータのPTS
    var offsetTime = CMTime.zero
    */
    ///プレビュー用レイヤー
    var previewLayer:CALayer!
    //dataOutput
    var dataOutput = AVCaptureVideoDataOutput()

    ///撮影開始フラグ
    private var _takeMovie:Bool = false
    @Published var takingmovie:Bool = false
    ///セッション
    private let captureSession = AVCaptureSession()
    ///撮影デバイス
    private var capturepDevice:AVCaptureDevice!
    //初期設定
    override init() {
        super.init()

        prepareCamera()
        beginSession()
    }

    //撮影開始フラグをONにする
    //captureOutput関数で画像を取得する
    func takeMovie() {
        _takeMovie = true
    }
    //previewの開始
    func startMovie() {
        takingmovie = true
    }
    //録画の中止
    func stopMovie() {
        takingmovie = false
    }
    //イメージ画像の保存
    func captureimage1(){
        iscapimage1 = true
        ischange1 = true
    }
    
    func captureimage2(){
        iscapimage2 = true
        ischange2 = true
    }
    
    //アニメーション用の動画取得
    func recordmovie(){
        self.recimages = []
        isanimation = false
        isfinishmovie = false
        isrecordmovie = true
        self.Startrectime = Date().addingTimeInterval(0)
    }
    
    //動画撮影とカメラロールへの保存
    /*
    func stopmovie(){
        isrecordmovie = false
        self.videoInput?.markAsFinished()
        self.filewriter?.finishWriting(completionHandler: {
              DispatchQueue.main.async {
                self.filewriter = nil // 録画終了
              }
          })
        self.outputVideos()
    }
 */
    //初期状態にフラグを戻す
    func clearall(){
        isviewimage1 = false
        isviewimage2 = false
        repeatflug = false
        ischange = true
        ischange1 = false
        ischange2 = false
        iscapture = false
        isrecordmovie = false
    }
    //カメラデバイスの設定
    //初期化時に呼び出される
    private func prepareCamera() {
        captureSession.sessionPreset = .photo

        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            capturepDevice = availableDevice
        }
    }
    
    //初期化時に呼び出される
    private func beginSession() {
        //デバイスの初期化
        do {

            // 指定したデバイスを使用するために入力を初期化
            //これがあるとプレビューが表示されなくなる
            let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)
            captureSession.addInput(captureDeviceInput)
            
            try capturepDevice.lockForConfiguration()
            capturepDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: framerate)
            capturepDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: framerate)
            capturepDevice.unlockForConfiguration()
            
        } catch {
            print(error.localizedDescription)
        }
        //カメラ映像を画面に出力する為の設定
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        //CALayerのサブクラス
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        


        //video formatの決定
        self.dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
        
        //vieoの保存先の設定
        //フレーム毎に呼び出すデリゲート登録
        let queue:DispatchQueue = DispatchQueue(label: "myqueue", attributes: .concurrent)
        self.dataOutput.setSampleBufferDelegate(self, queue: queue)
        self.dataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(dataOutput) {
            self.captureSession.addOutput(self.dataOutput)
        }
        
        captureSession.commitConfiguration()
    }
 
    //startRunningメソッドにより、セッションの入力から出力までの流れが実行される
    func startSession() {
        if captureSession.isRunning { return }
        captureSession.startRunning()
    }
    //セッションのストップ
    func endSession() {
        if !captureSession.isRunning { return }
        captureSession.stopRunning()
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //let isVideo = output is AVCaptureVideoDataOutput
        if takingmovie {
            //previewから画像を取得し、BufferをUIImageに変換する
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                //同期処理での呼び出し
                DispatchQueue.main.async {
                    let imagecv = self.convertColor(source: image)
                    self.image = imagecv
                    if self.iscapimage1 == true{
                        self.capimage1 = imagecv
                        self.iscapimage1 = false
                        self.isviewimage1 = true
                    }
                    if self.iscapimage2 == true{
                        self.capimage2 = imagecv
                        self.iscapimage2 = false
                        self.isviewimage2 = true
                    }
                    if (self.isrecordmovie == true){
                        
                        self.recimages.append(imagecv)
                        if (self.recimages.count/Int(self.framerate)) >= 5{
                            self.isrecordmovie = false
                            self.isfinishmovie = true
                        }
                    }
                    else{

                    }
                   
                }
            }
        }
    }
    
    //captureOutputで使用
    //CMSampleBufferをUIImageに変換している
    private func getImageFromSampleBuffer (buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            if let image = context.createCGImage(ciImage, from: imageRect) {
                //return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
                return UIImage(cgImage: image, scale: UIScreen.main.scale/10, orientation: .up)
            }
        }
        return nil
    }
    
    func convertColor(source srcImage: UIImage) -> UIImage {
        //let CONTOUR_COLOR = Scalar(0.0, 0.0, 0.0, 0.0)
        let srcMat = Mat(uiImage: srcImage)
        let rotMat = Mat()
        let dstMat = Mat()

        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
            Imgproc.cvtColor(src: srcMat, dst: dstMat, code: .COLOR_RGB2BGRA)
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            Core.rotate(src: srcMat, dst: rotMat, rotateCode: .ROTATE_180)
            Imgproc.cvtColor(src: rotMat, dst: dstMat, code: .COLOR_RGB2BGRA)
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait{
            Core.rotate(src: srcMat, dst: rotMat, rotateCode: .ROTATE_90_CLOCKWISE)
            Imgproc.cvtColor(src: rotMat, dst: dstMat, code: .COLOR_RGB2BGRA)
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
            Core.rotate(src: srcMat, dst: rotMat, rotateCode: .ROTATE_90_COUNTERCLOCKWISE)
            Imgproc.cvtColor(src: rotMat, dst: dstMat, code: .COLOR_RGB2BGRA)
        }
        else{
            //Core.rotate(src: srcMat, dst: rotMat, rotateCode: .ROTATE_90_COUNTERCLOCKWISE)
            Core.rotate(src: srcMat, dst: rotMat, rotateCode: .ROTATE_90_CLOCKWISE)
            Imgproc.cvtColor(src: rotMat, dst: dstMat, code: .COLOR_RGB2BGRA)
        }
        
        return dstMat.toUIImage()
    }
    
}
