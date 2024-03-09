//
//  FolderView.swift
//
//  Created by Sake Salverda on 10/03/2024.
//

import SwiftUI

struct Paper: View {
    var width: CGFloat = 86
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 6)
            
            VStack(spacing: 6) {
                ForEach(0...4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 7)
                        .foregroundStyle(.opacity(0.05))
                }
            }
            .foregroundStyle(.black)
            .padding(12)
        }
        .frame(width: width, height: 120)
    }
}

struct FolderShape: Shape {
    var cornerRadius: CGFloat
    
    /// Width of height drop
    var tabWidth: CGFloat = 50
    
    /// Magnitude of height drop
    var tabHeight: CGFloat = 15
    
    /// Starting X-coordinate of height drop
    var tabStartX: CGFloat = 80
    
    
    var tabControlPointOffset: CGFloat {
        tabWidth / 2.5
    }
    
    /// End X-coordinate of height drop
    private var tabEndX: CGFloat {
        tabStartX + tabWidth
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.minX + tabStartX, y: rect.minY))
        
        // height drop
        path.addCurve(
            to: CGPoint(x: rect.minX + tabEndX, y: rect.minY + tabHeight),
            control1: CGPoint(x: rect.minX + tabStartX + tabControlPointOffset, y: rect.minY),
            control2: CGPoint(x: rect.minX + tabEndX - tabControlPointOffset, y: rect.minY + tabHeight)
        )
        
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + tabHeight))
        
        // top right curve
        // not a style: .continuous curve, smooth curve's can be implemented with a bit more work
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius + tabHeight),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        // move to bottom right
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        
        // move to bottom left
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        
        // close the path
        path.closeSubpath()
        
        return path
    }
}

struct FolderView: View {
    private let cornerRadius: CGFloat = 25
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.white)
                    
                    Rectangle()
                        .foregroundStyle(.purple)
                        .opacity(0.8)
                }
                .clipShape(FolderShape(cornerRadius: cornerRadius))
                .foregroundStyle(.purple.secondary)
                
                Paper()
                    .frame(height: 45, alignment: .top)
                    .rotationEffect(.degrees(-3), anchor: .topTrailing)
            }
            .frame(height: 70)
            .clipped()
            
            VStack(spacing: 20) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        Text("Personal")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("123")
                            .foregroundStyle(.secondary)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .fontDesign(.rounded)
            .padding()
            .background(Color.purple)
            .shadow(color: .black.opacity(0.25), radius: 10)
        }
        .frame(width: 250)
        
        // this ensures the shadow of the bottom part
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    FolderView()
        .padding()
}

#Preview("Paper") {
    Paper()
        .padding()
}

#Preview("Curve") {
    FolderShape(cornerRadius: 20)
        .stroke(lineWidth: 4) // I use a stroke here as it is easier to spot line mistakes
        .frame(width: 200, height: 100)
        .padding()
}
