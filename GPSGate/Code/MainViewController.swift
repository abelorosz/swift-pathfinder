//
//  Created by Abel Orosz on 2016-09-16.
//  Copyright © 2016. Abel Orosz. All rights reserved.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {
    
    var scene: MainScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scene = MainScene(size: self.view.frame.size)
        self.scene.scaleMode = .aspectFill
        self.scene.backgroundColor = SKColor.white
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
