//
//  ViewController.swift
//  WallpaperAR
//
//  Created by Admin on 26.01.2021.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController{

    @IBOutlet var sceneView: ARSCNView!
    
    var planes = [Plane]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the view's delegate
            sceneView.delegate = self
            
            // Show statistics such as fps and timing information
            sceneView.showsStatistics = true
            
            sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
            
            sceneView.autoenablesDefaultLighting = true
            
            // Create a new scene
            let scene = SCNScene()
            
            // Set the scene to the view
            sceneView.scene = scene
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            
            configuration.planeDetection = .vertical

            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            sceneView.session.pause()
        }
}


    // MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            
            guard anchor is ARPlaneAnchor else { return }
            
            let plane = Plane(anchor: anchor as! ARPlaneAnchor)
            
            self.planes.append(plane)
            node.addChildNode(plane)
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            
            let plane = self.planes.filter { plane in
                return plane.anchor.identifier == anchor.identifier
            }.first
            
            guard plane != nil else { return }
            
            plane?.update(anchor: anchor as! ARPlaneAnchor)
        }
}

