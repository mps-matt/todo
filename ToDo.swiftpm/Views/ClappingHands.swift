import SwiftUI

//
//  ClappingHands.swift
//  ClappingHands
//
//  Created by Amos Gyamfi on 5.9.2021.
//
import SwiftUI

struct ClappingHands: View {
    
    @State private var blinking = false
    @State private var openingClosing = true
    @State private var clapping = true
    
    var body: some View {
        
        VStack {
            Spacer()
            
            ZStack {
                    Image("head")
                    
                    VStack {
                        ZStack {
                            Image("eyelid")
                            
                            Image("eye_blink")
                                .scaleEffect(y: blinking ? 0 : 1)
                                .animation(.timingCurve(0.68, -0.6, 0.32, 1.6).delay(1).repeatForever(autoreverses: false), value: blinking)
                            /*.animation(.easeIn(duration: 0.25).speed(10).delay(1).repeatForever(autoreverses: true), value: blinking)*/
                        }
                        
                        ZStack {
                            Image("mouth")
                                .scaleEffect(x: openingClosing ? 0.7 : 1)
                                .animation(.timingCurve(0.68, -0.6, 0.32, 1.6).delay(1).repeatForever(autoreverses: true), value: openingClosing)
                            
                            HStack {
                                Image("left_hand")
                                    .rotationEffect(.degrees(clapping ? 15 : -5), anchor: .bottom)
                                    .offset(x: clapping ? 20 : -40)
                                    .animation(.easeOut(duration: 0.2).repeatForever(autoreverses: true), value: clapping)
                                
                                
                                Image("right_hand")
                                    .rotationEffect(.degrees(clapping ? -15 : 5), anchor: .bottom)
                                    .offset(x: clapping ? -20 : 40)
                                    .animation(.easeOut(duration: 0.2).repeatForever(autoreverses: true), value: clapping)
                            }
                            
                        }
                    }
                    .task{
                        clapping.toggle()
                        blinking.toggle()
                        openingClosing.toggle()
                    }
            }
            
            Spacer()
        }
        .padding()
        
    }
    
}

struct ClappingHands_Previews: PreviewProvider {
    static var previews: some View {
        ClappingHands()
            .preferredColorScheme(.dark)
    }
}
