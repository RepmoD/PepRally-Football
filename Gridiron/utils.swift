import SwiftUI

#if canImport(UIKit)
import UIKit

// iOS specific extensions
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#else
import AppKit

// macOS specific extensions
extension View {
    func cornerRadius(_ radius: CGFloat, corners: RoundedCornerLocation) -> some View {
        clipShape(MacRoundedCorner(radius: radius, corners: corners))
    }
}

enum RoundedCornerLocation {
    case topLeft, topRight, bottomLeft, bottomRight, allCorners
}

struct MacRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: RoundedCornerLocation = .allCorners

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        // Start from top left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + (corners == .topLeft || corners == .allCorners ? radius : 0)))
        
        // Top left corner
        if corners == .topLeft || corners == .allCorners {
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: Angle(degrees: 180),
                       endAngle: Angle(degrees: 270),
                       clockwise: false)
        } else {
            path.addLine(to: topLeft)
        }
        
        // Top edge and top right corner
        path.addLine(to: CGPoint(x: rect.maxX - (corners == .topRight || corners == .allCorners ? radius : 0), y: rect.minY))
        if corners == .topRight || corners == .allCorners {
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: Angle(degrees: 270),
                       endAngle: Angle(degrees: 0),
                       clockwise: false)
        } else {
            path.addLine(to: topRight)
        }
        
        // Right edge and bottom right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - (corners == .bottomRight || corners == .allCorners ? radius : 0)))
        if corners == .bottomRight || corners == .allCorners {
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                       radius: radius,
                       startAngle: Angle(degrees: 0),
                       endAngle: Angle(degrees: 90),
                       clockwise: false)
        } else {
            path.addLine(to: bottomRight)
        }
        
        // Bottom edge and bottom left corner
        path.addLine(to: CGPoint(x: rect.minX + (corners == .bottomLeft || corners == .allCorners ? radius : 0), y: rect.maxY))
        if corners == .bottomLeft || corners == .allCorners {
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                       radius: radius,
                       startAngle: Angle(degrees: 90),
                       endAngle: Angle(degrees: 180),
                       clockwise: false)
        } else {
            path.addLine(to: bottomLeft)
        }
        
        // Close the path
        path.closeSubpath()
        return path
    }
}
#endif
