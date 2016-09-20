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
    
    override func sceneDidLoad() {
        let width: CGFloat = 8
        self.nodeShape = SKShapeNode.init(rectOf: CGSize.init(width: width, height: width), cornerRadius: width * 0.5)
        
        if let node = self.nodeShape {
            node.lineWidth = 2
            node.fillColor = SKColor.darkGray
            node.strokeColor = SKColor.darkGray
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
    
    // Source: Apple Developer Portal - Pathfinding
    // https://developer.apple.com/library/content/documentation/General/Conceptual/GameplayKit_Guide/Pathfinding.html
    //
    // I used the source to learn about how pathfinding works in GameplayKit
    
    private func findPathBetweenLastTwoNodes() {
        let offset = self.nodes.count - 1
        
        // Define the obstacle graph for pathfinding
        // and define the starting and ending points
        
        let graph = GKObstacleGraph(obstacles: self.obstacleGraph, bufferRadius: 8)
        let startNode = GKGraphNode2D(point: float2(x: Float(self.nodes[offset - 1].x), y: Float(self.nodes[offset - 1].y)))
        let endNode = GKGraphNode2D(point: float2(x: Float(self.nodes[offset].x), y: Float(self.nodes[offset].y)))
        
        graph.connectUsingObstacles(node: startNode)
        graph.connectUsingObstacles(node: endNode)
        
        // Find the shortest path in a background thread
        
        DispatchQueue.global(qos: .userInitiated).async {
            let path = graph.findPath(from: startNode, to: endNode)
            
            // Return if there is no route available
            
            guard path.count > 0 else {
                return
            }
            
            // Create obstacles for the pathfinder algorithm
            // Obstacles are the outlines of the path sections
            
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
            
            // Draw a line between the last two points
            // to show the shortest path between them
            
            var cgPointArray = [CGPoint]()
            
            for node in path {
                if let grapNode = node as? GKGraphNode2D {
                    let point = CGPoint(x: CGFloat(grapNode.position.x), y: CGFloat(grapNode.position.y))
                    cgPointArray.append(point)
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
