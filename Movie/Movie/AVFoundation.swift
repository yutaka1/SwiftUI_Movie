//
//  SwiftUIView.swift
//  Movie
//
//  Created by SHIRAHATA YUTAKA on 2020/12/07.
//

import UIKit
import AVFoundation
import Combine


class AVFoundationVM: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    ///撮影した画像
    @Published var image: UIImage?
    ///プレビュー用レイヤー
    var previewLayer:CALayer!

    ///撮影開始フラグ
    private var _takePhoto:Bool = false
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
    func takePhoto() {
        _takePhoto = true
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
        } catch {
            print(error.localizedDescription)
        }
        //カメラ映像を画面に出力する為の設定
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        //CALayerのサブクラス
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        
        //video formatの決定
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]

        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }

        captureSession.commitConfiguration()

        let queue = DispatchQueue(label: "FromF.github.com.AVFoundationSwiftUI.AVFoundation")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
  
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
        if _takePhoto {
            _takePhoto = false
            //previewから画像を取得する
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    self.image = image
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
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }

        return nil

 }

 }


