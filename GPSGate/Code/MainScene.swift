//
//  Created by Abel Orosz on 2016-09-16.
//  Copyright © 2016. Abel Orosz. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainScene: SKScene {
    
    private var nodes = [CGPoint]()
    private var nodeShape: SKShapeNode?
    private var obstacleGraph = [GKPolygonObstacle]()
    
    override func didMove(to view: SKView) {
        let w: CGFloat = 8
        self.nodeShape = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.5)
        
        if let endNode = self.nodeShape {
            endNode.lineWidth = 2
            endNode.fillColor = SKColor.darkGray
            endNode.strokeColor = SKColor.darkGray
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = self.nodeShape?.copy() as! SKShapeNode? {
            let position = touch.location(in: self)
            
            node.position = position
            self.addChild(node)
            
            self.nodes.append(position)
            
            if self.nodes.count % 2 == 0 {
                self.findPathBetweenLastTwoNodes()
            }
        }
    }
    
    private func findPathBetweenLastTwoNodes() {
        let offset = self.nodes.count - 1
        
        // Source: Apple Developer Portal - Pathfinding
        // https://developer.apple.com/library/content/documentation/General/Conceptual/GameplayKit_Guide/Pathfinding.html
        //
        // I used the source to learn about how pathfinding works in GameplayKit
        
        let graph = GKObstacleGraph(obstacles: self.obstacleGraph, bufferRadius: 8)
        let startNode = GKGraphNode2D(point: float2(x: Float(self.nodes[offset - 1].x), y: Float(self.nodes[offset - 1].y)))
        let endNode = GKGraphNode2D(point: float2(x: Float(self.nodes[offset].x), y: Float(self.nodes[offset].y)))
        
        graph.connectUsingObstacles(node: startNode)
        graph.connectUsingObstacles(node: endNode)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let path = graph.findPath(from: startNode, to: endNode)
            
            guard path.count > 0 else {
                return
            }
            
            for i in stride(from: 1, to: path.count, by: 1) {
                let pointA = (path[i - 1] as! GKGraphNode2D).position
                let pointB = (path[i] as! GKGraphNode2D).position
                
                let unitAB = pointB.deltaTo(pointA).normalize()
                let unitBA = pointA.deltaTo(pointB).normalize()
                
                let size: Float = 4.0
                var outline = [float2]()
                outline.append(float2(x: unitAB.y * (-1) * size + pointA.x, y: unitAB.x * size + pointA.y))
                outline.append(float2(x: unitAB.y * size + pointA.x, y: unitAB.x * (-1) * size + pointA.y))
                outline.append(float2(x: unitBA.y * (-1) * size + pointB.x, y: unitBA.x * size + pointB.y))
                outline.append(float2(x: unitBA.y * size + pointB.x, y: unitBA.x * (-1) * size + pointB.y))
                
                self.obstacleGraph.append(GKPolygonObstacle(points: outline))
            }
            
            var f2PointArray = [float2]()
            var cgPointArray = [CGPoint]()
            
            for node in path {
                if let grapNode = node as? GKGraphNode2D {
                    f2PointArray.append(grapNode.position)
                    cgPointArray.append(CGPoint(x: CGFloat(grapNode.position.x), y: CGFloat(grapNode.position.y)))
                }
            }
            
            let line = SKShapeNode(points: &cgPointArray, count: cgPointArray.count)
            line.lineWidth = 2
            line.strokeColor = SKColor.randomColor()
            
            DispatchQueue.main.async {
                self.addChild(line)
            }
        }
    }
    
}
