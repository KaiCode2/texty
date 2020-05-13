//
//  CirclePlayView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-04-14.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import Combine

internal struct CirclePlayView: View {

    @State private var isPlaying = false
    private var playPublisher = Publishers.PlayPublisher()

    var body: some View {
        ZStack {
            Circle()
            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                .background(RadialGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(red: 0.9, green: 0.05, blue: 0.25), location: 0),
                                                                      Gradient.Stop(color: Color(red: 0.9, green: 0.8, blue: 0.8), location: 1)]),
                                           center: .center,
                startRadius: 20, endRadius: 100)).clipShape(Circle())
                .foregroundColor(.clear)
            .shadow(radius: 10)
                .accessibility(label: Text("Play")).frame(minWidth: 60, idealWidth: 100, maxWidth: 100, minHeight: 60, idealHeight: 100, maxHeight: 100)

            (isPlaying ? Image(systemName: "pause.fill") : Image(systemName: "play.fill"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 30, idealWidth: 40, maxWidth: 40,
                       minHeight: 30, idealHeight: 40, maxHeight: 40)
                .padding(.leading, (isPlaying ? 0 : 5))
                .colorScheme(.dark)
        }.onTapGesture {
            withAnimation(.easeOut(duration: 0.2)) {
                self.isPlaying.toggle()
            }
        }.onReceive(playPublisher) { (playback) in
            self.isPlaying = playback.isPlaying
        }
    }
}

#if DEBUG

struct CirclePlayView_Previews: PreviewProvider {


    static var previews: some View {
        CirclePlayView()
    }
}
#endif
