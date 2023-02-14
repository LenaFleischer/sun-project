

import SwiftUI



let orangey = Color(red: 1.00, green: 0.73, blue: 0.47)
let pinky = Color(red: 1.00, green: 0.54, blue: 0.54)

let backgroundC = LinearGradient(
    colors: [pinky, orangey],
    startPoint: .top, endPoint: .bottom)


struct CompositePage: View {
    @Binding var locationArray: [String]
//    @Binding var locDict: [String: [Double]]
    
    @Binding var sunsetCoverArr: Double
    @Binding var sunriseCoverArr: Double
    
    @State var goToAddLocation = false
    
    var body: some View {
        
        NavigationView{
            VStack{
                TabView{
                    ForEach(locationArray, id: \.self){ location in
                        ZStack{
                            backgroundC
                            VStack{
                                Text(location)
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
                                    Image(systemName: "star")
                                        .foregroundColor(Color.white)
                                }
                                
                               

                                Text("prediction: \(getAstheticQuality(cloudCover: sunriseCoverArr))")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30, weight: .light, design: .serif))
                                Image("splitCircle")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.3)
                                    .padding()
                                Text("prediction: \(getAstheticQuality(cloudCover: sunsetCoverArr))")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30, weight: .light, design: .serif))
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
                                
                                
                                NavigationLink(destination: AddLocation(locationArray: locationArray, thisSunriseCloudCover: sunriseCoverArr, thisSunsetCloudCover: sunsetCoverArr), isActive: $goToAddLocation) { EmptyView() }
                                Button(action: {
                                    goToAddLocation = true}
                                       , label: {
                                    Image("add").imageScale(.small)
                                    
                                })
                            }
                    }
                        
                }
            }
                .tabViewStyle(.page)
            
        }
        }
            // this hised the back button
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

func getAstheticQuality(cloudCover: Double) -> String{
    var condition = ""
    if (cloudCover < 30){
        condition = "fine"
    }
    else if (cloudCover > 60){
        condition = "bad"
    }
    else {
        condition = "good"
    }
    return condition
}




