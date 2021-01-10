//
//  SwiftUIView.swift
//  Movie
//
//  Created by SHIRAHATA YUTAKA on 2020/12/07.
//

import SwiftUI

struct CALayerView: UIViewControllerRepresentable {
    var caLayer:CALayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<CALayerView>) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame

        return viewController
    }
    //プレビュー動画をアップデートしている
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame

    }
}

