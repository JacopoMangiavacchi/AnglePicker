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
    public var color: Color = Color.white
    public var selectionColor: Color = Color.white
    public var strokeColor: Color = Color.gray
    public var strokeWidth: CGFloat = 30
    
    public var body: some View {
        GeometryReader { geometry -> CircleSlider in
            return CircleSlider(frame: geometry.frame(in: CoordinateSpace.local),
                                angle: self.angle,
                                color: self.color,
                                selectionColor: self.selectionColor,
                                strokeColor: self.strokeColor,
                                strokeWidth: self.strokeWidth)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

public struct CircleSlider: View {
    public var frame: CGRect
    public var angle: Binding<Angle>
    public var color: Color
    public var selectionColor: Color
    public var strokeColor: Color
    public var strokeWidth: CGFloat

    @State private var position: CGPoint = CGPoint.zero
    
    public var body: some View {
        let indicatorOffset = CGSize(width: cos(angle.wrappedValue.radians) * Double(frame.midX - strokeWidth / 2), height: -sin(angle.wrappedValue.radians) * Double(frame.midY - strokeWidth / 2))
        return ZStack(alignment: .center) {
            Circle()
                .strokeBorder(Color.blue, lineWidth: strokeWidth)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged(self.update(value:))
            )
            Circle()
                .fill(color)
                .frame(width: strokeWidth, height: strokeWidth, alignment: .center)
                .fixedSize()
                .offset(indicatorOffset)
                .allowsHitTesting(false)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
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
