//
//  Created by Abel Orosz
//  Copyright © 2016. Abel Orosz. All rights reserved.
//

import SpriteKit

extension float2 {
    
    func deltaTo(_ a: float2) -> float2 {
        return float2(self.x - a.x, self.y - a.y)
    }
    
    func length() -> Float {
        return sqrt(pow(self.x, 2) + pow(self.y, 2))
    }
    
    func normalize() -> float2 {
        let l = self.length()
        return float2(self.x / Float(l), self.y / Float(l))
    }
    
}
