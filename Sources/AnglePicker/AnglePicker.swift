//
//  AnglePicker.swift
//  AnglePicker
//
//  Created by Jacopo Mangiavacchi on 09.20.19.
//
//  This code uses:
//    https://developer.apple.com/documentation/swiftui/gestures/composing_swiftui_gestures
//  and
//    https://developer.apple.com/wwdc19/237

import SwiftUI

public struct AnglePicker : View {
    public var angle: Binding<Angle>
    public var circleColor: Color = Color.blue
    public var selectionColor: Color = Color.white
    public var selectionBorderColor: Color = Color.white
    public var strokeWidth: CGFloat = 30
    
    public init(angle: Binding<Angle>, circleColor: Color, selectionColor: Color, selectionBorderColor: Color, strokeWidth: CGFloat) {
        self.angle = angle
        self.circleColor = circleColor
        self.selectionColor = selectionColor
        self.selectionBorderColor = selectionBorderColor
        self.strokeWidth = strokeWidth
    }
    
    public var body: some View {
        GeometryReader { geometry -> CircleSlider in
            return CircleSlider(frame: geometry.frame(in: CoordinateSpace.local),
                                angle: self.angle,
                                circleColor: self.circleColor,
                                selectionColor: self.selectionColor,
                                selectionBorderColor: self.selectionBorderColor,
                                strokeWidth: self.strokeWidth)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

public struct CircleSlider: View {
    public var frame: CGRect
    public var angle: Binding<Angle>
    public var circleColor: Color
    public var selectionColor: Color
    public var selectionBorderColor: Color
    public var strokeWidth: CGFloat

    @State private var position: CGPoint = CGPoint.zero
    
    public var body: some View {
        let indicatorOffset = CGSize(width: cos(angle.wrappedValue.radians) * Double(frame.midX - strokeWidth / 2), height: -sin(angle.wrappedValue.radians) * Double(frame.midY - strokeWidth / 2))
        return ZStack(alignment: .center) {
            Circle()
                .strokeBorder(circleColor, lineWidth: strokeWidth)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged(self.update(value:))
            )
            Circle()
                .fill(selectionColor)
                .frame(width: strokeWidth, height: strokeWidth, alignment: .center)
                .fixedSize()
                .offset(indicatorOffset)
                .allowsHitTesting(false)
                .overlay(
                    Circle()
                        .stroke(selectionBorderColor, lineWidth: 3)
                        .offset(indicatorOffset)
                        .allowsHitTesting(false)
            )
        }
    }
    
    internal func update(value: DragGesture.Value) {
        self.position = value.location
        self.angle.wrappedValue = Angle(radians: radCenterPoint(value.location, frame: self.frame))
    }
    
    internal func radCenterPoint(_ point: CGPoint, frame: CGRect) -> Double {
        let adjustedAngle = atan2f(Float(frame.midX - point.x), Float(frame.midY - point.y)) + .pi / 2
        return Double(adjustedAngle < 0 ? adjustedAngle + .pi * 2 : adjustedAngle)
    }
}
