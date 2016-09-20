//
//  Created by Abel Orosz on 2016-09-16.
//  Copyright © 2016. Abel Orosz. All rights reserved.
//

import SpriteKit

extension SKColor {
    
    static func randomColor() -> SKColor {
        let rRed = CGFloat(drand48())
        let rGreen = CGFloat(drand48())
        let rBlue = CGFloat(drand48())
        
        return SKColor(red: rRed, green: rGreen, blue: rBlue, alpha: 1)
    }
    
}
