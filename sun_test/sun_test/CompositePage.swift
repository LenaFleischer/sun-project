

import SwiftUI



let orangey = Color(red: 1.00, green: 0.73, blue: 0.47)
let pinky = Color(red: 1.00, green: 0.54, blue: 0.54)

let backgroundC = LinearGradient(
    colors: [pinky, orangey],
    startPoint: .top, endPoint: .bottom)


struct CompositePage: View {
    var body: some View {
        ZStack{
            backgroundC
            VStack{
                Text("Location")
                    .foregroundColor(Color.white)
                    .font(.system(size: 30, weight: .light, design: .serif))
                Text("sunrise")
                    .foregroundColor(Color.white)
                    .font(.system(size: 30, weight: .light, design: .serif))
                HStack{
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.white)
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.white)
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.white)
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.white)
                    Image(systemName: "star")
                        .foregroundColor(Color.white)
                }
                Image("splitCircle")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.3)
                            .padding()

                HStack{
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.white)
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.white)
                    Image(systemName: "star")
                        .foregroundColor(Color.white)
                    Image(systemName: "star")
                        .foregroundColor(Color.white)
                    Image(systemName: "star")
                        .foregroundColor(Color.white)
                }
                Text("sunset")
                    .foregroundColor(Color.white)
                    .font(.system(size: 30, weight: .light, design: .serif))
                
            }
        }
    }
}

