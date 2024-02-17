//
//  ContentView.swift
//  AI Voice Asistant
//
//  Created by Kerem Demir on 16.02.2024.
//

import SwiftUI
import SiriWaveView

struct ContentView: View {
    
    @State var viewModel = ViewModel()
    @State var isSymbolAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("AI Voice Asistant")
                .font(.title2)
            
            Spacer()
            SiriWaveView()
                .power(power: viewModel.audioPower )
                .opacity(viewModel.siriWaveFormOpacity)
                .frame(height: 256)
                .overlay {
                    overlayView
                }
            Spacer()
            
            switch viewModel.state {
            case .recordingSpeech:
                cancelRecordingButton
            case .processingSpeech, .playingSpeech:
                cancelButton
                
            default: EmptyView()
            }
            
            Picker("Select Voice", selection: $viewModel.selectedVoice) {
                ForEach(VoiceType.allCases, id: \.self) {
                    Text($0.rawValue).id($0)
                }
            }
            .pickerStyle(.segmented)
            .disabled(!viewModel.isIdle)
            
            if case let .error(error) = viewModel.state {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .lineLimit(2)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    var overlayView: some View {
        switch viewModel.state {
        case .idle, .error :
            startCaptureButton
        case .processingSpeech:
            Image(systemName: "brain")
                .symbolEffect(.bounce.up.byLayer,
                              options: .repeating,
                              value: isSymbolAnimating)
                .font(.system(size: 128))
                .onAppear {
                    isSymbolAnimating = true
                }
                .onDisappear {
                    isSymbolAnimating = false
                }
        default:
            EmptyView()
        }
    }
    
    var startCaptureButton: some View {
        Button {
            viewModel.startCaptureVoice()
        } label: {
            Image(systemName: "mic.circle")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 128))
        }.buttonStyle(.borderless)
    }
    
    var cancelRecordingButton: some View {
        Button {
            viewModel.cancelRecording()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 44))
        }.buttonStyle(.borderless)
    }

    var cancelButton: some View {
        Button {
            viewModel.cancelProcessingTask()
        } label: {
            Image(systemName: "stop.circle.fill")
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.red)
                .font(.system(size: 44))
        }.buttonStyle(.borderless)
    }
    
}

#Preview("Idle") {
    ContentView()
}

#Preview("Recording Speech") {
    let viewModel = ViewModel()
    viewModel.state = .recordingSpeech
    viewModel.audioPower = 0.20
    return ContentView(viewModel: viewModel)
}

#Preview("Processing Speech") {
    let viewModel = ViewModel()
    viewModel.state = .processingSpeech
    return ContentView(viewModel: viewModel)
}

#Preview("Playing Speech") {
    let viewModel = ViewModel()
    viewModel.state = .playingSpeech
    viewModel.audioPower = 0.3
    return ContentView(viewModel: viewModel)
}

#Preview("Error") {
    let viewModel = ViewModel()
    viewModel.state = .error("An error has occured !")
    return ContentView(viewModel: viewModel)
}
