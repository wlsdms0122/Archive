//
//  EdgeBorder.swift
//
//
//  Created by JSilver on 2023/02/24.
//

import SwiftUI

public struct EdgeBorder: Shape {
    public var edges: Edge.Set
    public var cornerRadius: CGFloat
    
    public init(
        edges: Edge.Set = .all,
        cornerRadius: CGFloat = 0
    ) {
        self.edges = edges
        self.cornerRadius = cornerRadius
    }
    
    public func path(in rect: CGRect) -> Path {
        let cornerRadius = min(cornerRadius, min(rect.width / 2, rect.height / 2))
        
        let topPath = Path {
            $0.move(to: .init(
                x: rect.minX + cornerRadius,
                y: rect.minY
            ))
            $0.addLine(to: .init(
                x: rect.maxX - cornerRadius,
                y: rect.minY
            ))
            
            $0.move(to: .init(
                x: rect.minX + cornerRadius,
                y: rect.minY
            ))
            $0.addArc(
                center: .init(
                    x: rect.minX + cornerRadius,
                    y: rect.minY + cornerRadius
                ),
                radius: cornerRadius,
                startAngle: .degrees(-90),
                endAngle: .degrees(-135),
                clockwise: true
            )
            
            $0.move(to: .init(
                x: rect.maxX - cornerRadius,
                y: rect.minY
            ))
            $0.addArc(
                center: .init(
                    x: rect.maxX - cornerRadius,
                    y: rect.minY + cornerRadius
                ),
                radius: cornerRadius,
                startAngle: .degrees(-90),
                endAngle: .degrees(-45),
                clockwise: false
            )
        }
        
        let trailingPath = Path {
            $0.move(to: .init(
                x: rect.maxX,
                y: rect.minY + cornerRadius
            ))
            $0.addLine(to: .init(
                x: rect.maxX,
                y: rect.maxY - cornerRadius
            ))
            
            $0.move(to: .init(
                x: rect.maxX,
                y: rect.minY + cornerRadius
            ))
            $0.addArc(
                center: .init(
                    x: rect.maxX - cornerRadius,
                    y: rect.minY + cornerRadius
                ),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(-45),
                clockwise: true
            )
            
            $0.move(to: .init(
                x: rect.maxX,
                y: rect.maxY - cornerRadius
            ))
            $0.addArc(
                center: .init(
                    x: rect.maxX - cornerRadius,
                    y: rect.maxY - cornerRadius
                ),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(45),
                clockwise: false
            )
        }
        
        let bottomPath = Path {
            $0.move(to: .init(
                x: rect.maxX - cornerRadius,
                y: rect.maxY
            ))
            $0.addLine(to: .init(
                x: rect.minX + cornerRadius,
                y: rect.maxY
            ))
            
            $0.move(to: .init(
                x: rect.maxX - cornerRadius,
                y: rect.maxY
            ))
            $0.addArc(
                center: .init(
                    x: rect.maxX - cornerRadius,
                    y: rect.maxY - cornerRadius
                ),
                radius: cornerRadius,
                startAngle: .degrees(90),
                endAngle: .degrees(45),
                clockwise: true
            )
            
            $0.move(to: .init(
                x: rect.minX + cornerRadius,
                y: rect.maxY
            ))
            $0.addArc(
                center: .init(
                    x: rect.minX + cornerRadius,
                    y: rect.maxY - cornerRadius
                ),
                radius: cornerRadius,
                startAngle: .degrees(90),
                endAngle: .degrees(135),
                clockwise: false
            )
        }
        
        let leadingPath = Path {
            $0.move(to: .init(
                x: rect.minX,
                y: rect.maxY - cornerRadius
            ))
            $0.addLine(to: .init(
                x: rect.minX,
                y: rect.minY + cornerRadius
            ))
            
            $0.move(to: .init(
                x: rect.minX,
                y: rect.maxY - cornerRadius
            ))
            $0.addArc(
                center: .init(
                    x: rect.minX + cornerRadius,
                    y: rect.maxY - cornerRadius
                ),
                radius: cornerRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(125),
                clockwise: true
            )
            
            $0.move(to: .init(
                x: rect.minX,
                y: rect.minY + cornerRadius
            ))
            $0.addArc(
                center: .init(
                    x: rect.minX + cornerRadius,
                    y: rect.minY + cornerRadius
                ),
                radius: cornerRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(225),
                clockwise: false
            )
        }
        
        return Path {
            if edges.contains(.top) {
                $0.addPath(topPath)
            }
            
            if edges.contains(.trailing) {
                $0.addPath(trailingPath)
            }
            
            if edges.contains(.bottom) {
                $0.addPath(bottomPath)
            }
            
            if edges.contains(.leading) {
                $0.addPath(leadingPath)
            }
        }
    }
}
