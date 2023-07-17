//
//  SwiftUIColorizedControlExampleApp.swift
//  SwiftUIColorizedControlExample
//
//  Created by Stephan Casas on 7/16/23.
//

import SwiftUI
import AppKit;

// MARK: - Main

@main
struct SwiftUIColorizedControlExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Sample Content

struct ContentView: View {
    
    @State var progressValue: Double = 0;
    @State var progressColor: NSColor = .systemGray;
    
    @State var animating: Bool = false;
    @State var indeterminate: Bool = false;
    
    var body: some View {
        VStack(spacing: 15, content: {
            NativeProgressViewGroup()
            ColorizedProgressViewGroup()
            ColorizedProgressViewOptionsGroup()
        })
        .padding()
        .toolbar(content: {
            ProgressButton(for: -0.05)
            ProgressButton(for:  0.05)
        })
        .navigationTitle("Custom Progress Indicator")
        .frame(minWidth: 525)
    }
    
    // MARK: - Groups
    
    private func NativeProgressViewGroup() -> some View {GroupBox("Native View", content:{
        ProgressView(value: self.progressValue)
            .tint(.init(nsColor: self.progressColor))
            .padding()
    })}
    
    private func ColorizedProgressViewGroup() -> some View {GroupBox("Custom View", content:{
        ColorizedProgressView(
            self.$progressValue, color: self.$progressColor)
        .isAnimating(self.$animating)
        .isIndeterminate(self.$indeterminate)
        .padding()
    })}
    
    
    private func ColorizedProgressViewOptionsGroup() -> some View { GroupBox("Options", content: {
        HStack(content: {
            OptionControls()
            
            Divider()
            
            ColorControls()
        })
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        
    })}
    
    
    // MARK: - Control Sections
    
    private func OptionControls() -> some View { VStack(alignment: .leading, content: {
        Toggle("Animation", isOn: self.$animating)
        Toggle("Indeterminate", isOn: self.$indeterminate)
    })}
    
    private func ColorControls() -> some View { HStack(content:{
        HStack(content:{
            ColorButton(for: .systemGray)
            ColorButton(for: .controlAccentColor)
        })
        
        Divider()
        
        HStack(content:{
            ColorButton(for: .systemRed)
            ColorButton(for: .systemOrange)
            ColorButton(for: .systemYellow)
            ColorButton(for: .systemGreen)
            ColorButton(for: .systemBlue)
            ColorButton(for: .systemIndigo)
            ColorButton(for: .systemPurple)
            ColorButton(for: .systemPink)
        })
    })}
    
    // MARK: - Buttons
    
    private func ProgressButton(for value: Double) -> some View {
        let dir = value > 0 ? "right" : "left";
        
        return Button(action: {
            self.progressValue = min(1, max(0, self.progressValue + value));
        }, label: {Image(systemName: "chevron.\(dir)") } )
    }
    
    private func ColorButton(for color: NSColor) -> some View { Button(
        action: {
            self.progressColor = color
        }, label: {
            Circle()
                .frame(width: 10)
                .foregroundColor(.init(nsColor: color))
        }
    )}
    
    
}
