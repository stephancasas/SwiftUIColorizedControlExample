//
//  ColorizedProgressView.swift
//  SwiftUIColorizedControlExample
//
//  Created by Stephan Casas on 7/16/23.
//

import SwiftUI;

/// ## NOTE
///
/// Referencing catalog colors of `NSColor` without first importing
/// AppKit in the referencing `.swift` file may cause a runtime
/// exception to be thrown by your application.
///
import AppKit;

struct ColorizedProgressView: NSViewRepresentable {
    
    private let minValue: Double;
    private let maxValue: Double;
    
    @Binding private var           value: Double;
    @Binding private var     isAnimating: Bool;
    @Binding private var isIndeterminate: Bool;
    @Binding private var  indicatorColor: NSColor;
    
    init(_ value: Binding<Double>, color: Binding<NSColor>, min minValue: Double = 0, max maxValue: Double = 1) {
        self.minValue = minValue;
        self.maxValue = maxValue;
        
        self._value = value;
        self._indicatorColor = color;
        
        self._isAnimating = .constant(true);
        self._isIndeterminate = .constant(false);
    }
    
    init(_ value: Binding<Double>, color: NSColor, min minValue: Double = 0, max maxValue: Double = 1) {
        self.init(
            value,
            color: .constant(color),
            min: minValue,
            max: maxValue);
    }
    
    init(_ value: Binding<Double>, min minValue: Double = 0, max maxValue: Double = 1) {
        self.init(
            value,
            color: .constant(NSColor(cgColor: NSColor.controlAccentColor.cgColor) ?? .controlColor),
            min: minValue,
            max: maxValue);
    }
    
    // MARK: - Config
    
    /// Bind the progress indicator's animation activity
    /// to a stateful value.
    ///
    func isAnimating(_ isAnimating: Binding<Bool>) -> Self {
        var copy = self;
        copy._isAnimating = isAnimating;
        
        return copy;
    }
    
    /// Bind the progress indicator's indeterminate appearance
    /// to a stateful value.
    ///
    func isIndeterminate(_ isIndeterminate: Binding<Bool>) -> Self {
        var copy = self;
        copy._isIndeterminate = isIndeterminate;
        
        return copy;
    }
    
    // MARK: - Statefulness
    
    private func applyState(in view: NSProgressIndicator) {
        view.doubleValue = self.value;
        view.isIndeterminate = self.isIndeterminate;
        
        if let color = self.indicatorColor.usingColorSpace(.displayP3),
           let filter = CIFilter.colorCube(for: color) {
            view.contentFilters = [filter];
        }
        
        if self.isAnimating {
            view.startAnimation(nil);
        } else {
            view.stopAnimation(nil);
        }
    }
    
    // MARK: - NSViewRepresentable
    
    func makeNSView(context: Context) -> NSProgressIndicator {
        let view = NSProgressIndicator();
        view.minValue = self.minValue;
        view.maxValue = self.maxValue;
        
        self.applyState(in: view);
        
        return view;
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        self.applyState(in: nsView);
    }
}
