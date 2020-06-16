//
//  ViewController.swift
//  MetalTriangles
//
//  Created by David Kanenwisher on 6/15/20.
//  Copyright © 2020 dkanen. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let metalView = view as? MTKView else {
            fatalError("metal view not set up in storyboard")
        }
        renderer = Renderer(metalView: metalView)
    }


}

