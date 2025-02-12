//
//  SVGImageViewController.swift
//  PuppyMode
//
//  Created by 이승준 on 2/9/25.
//

import UIKit

class SVGImageViewController: UIViewController {
    
    let svgView = SVGImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = svgView
    }
    
}
