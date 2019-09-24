//
//  Created by Abel Orosz
//  Copyright © 2016. Abel Orosz. All rights reserved.
//

import SpriteKit

typealias float2 = SIMD2<Float>

extension float2 {
    
    func deltaTo(_ a: SIMD2<Float>) -> SIMD2<Float> {
        return SIMD2<Float>(Float(self.x) - a.x, self.y - a.y)
    }
    
    func length() -> Float {
        return sqrt(pow(self.x, 2) + pow(self.y, 2))
    }
    
    func normalize() -> SIMD2<Float> {
        let l = self.length()
        return SIMD2<Float>(self.x / Float(l), self.y / Float(l))
    }
}
