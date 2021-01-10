//
//  ViewController.swift
//  Syosabi
//
//  Created by SHIRAHATA YUTAKA on 2020/12/08.
//

import SwiftUI

class NaviViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc: UIHostingController = UIHostingController(rootView: SubView())
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)

        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        vc.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
