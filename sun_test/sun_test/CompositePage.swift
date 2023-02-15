import SwiftUI



let orangey = Color(red: 1.00, green: 0.73, blue: 0.47)
let pinky = Color(red: 1.00, green: 0.54, blue: 0.54)

let backgroundC = LinearGradient(
    colors: [pinky, orangey],
    startPoint: .top, endPoint: .bottom)

public var locDict: [String: [String]] = [:]

struct CompositePage: View {
    @Binding var locationArray: [String]
    @Binding var sunsetCoverArr: Double
    @Binding var sunriseCoverArr: Double
    //    @Binding var locDict: [String: [Double]]
    
    @State var goToAddLocation = false
    //@State var locDict: [String: [String]]
    
    
    var body: some View {
        
        NavigationView{
            VStack{
                TabView{
                    ForEach(locationArray, id: \.self){ location in
                        ZStack{
                            backgroundC
                            VStack{
                                
                              //  var index = locationArray.index(of: location)
                               // var sunriseCover = getAstheticQuality(cloudCover: sunriseCoverArr[locationArray.firstIndex(of: location) ?? 0])
                                //var sunsetCover = getAstheticQuality(cloudCover: sunsetCoverArr[locationArray.firstIndex(of: location) ?? 0])
                                var sunriseCover = getAstheticQuality(cloudCover: sunriseCoverArr)
                                var sunsetCover = getAstheticQuality(cloudCover: sunsetCoverArr)
                                //locDict[location] = [sunriseCover, sunsetCover]
                                
                                Text(location)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30, weight: .light, design: .serif))
                                Text("sunrise")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30, weight: .light, design: .serif))
                                
                                HStack{
                                    if sunriseCover == "good"{
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                    }
                                    else if sunriseCover == "fine"{
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.leadinghalf.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                    }
                                    else{
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                    }
                                    
                                }
                                
                                Text("prediction: \(sunriseCover)")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30, weight: .light, design: .serif))
                                
                                Image("splitCircle")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.3)
                                    .padding()

                                Text("prediction: \(sunsetCover)")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30, weight: .light, design: .serif))
                                HStack{
                                    if sunsetCover == "good"{
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                    }
                                    else if sunsetCover == "fine"{
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star.leadinghalf.fill")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                    }
                                    else{
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                    }
                                    
                                }
                                
                                /*
                                Image("splitCircle")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.3)
                                    .padding()
                                    .overlay(ImageOverlay(sunriseCover: $sunriseCover, sunsetCover: $sunsetCover))
                                 */
                                
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
    if (cloudCover < 30){
        return "fine"
    }
    else if (cloudCover > 60){
        return "bad"
    }
    else {
        return "good"
    }
}



/*
struct ImageOverlay: View {
    @Binding var sunriseCover: String
    @Binding var sunsetCover: String
    
    var body: some View {
        HStack{
            if sunriseCover == "good"{
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
            }
            else if sunriseCover == "fine"{
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.leadinghalf.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
            }
            else{
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
            }
            
        }
        
        Text("prediction: \(sunriseCover)")
            .foregroundColor(Color.white)
            .font(.system(size: 30, weight: .light, design: .serif))
        
        // CENTER OF CIRCLE

        Text("prediction: \(sunsetCover)")
            .foregroundColor(Color.white)
            .font(.system(size: 30, weight: .light, design: .serif))
        HStack{
            if sunsetCover == "good"{
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
            }
            else if sunsetCover == "fine"{
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star.leadinghalf.fill")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
            }
            else{
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
                Image(systemName: "star")
                    .foregroundColor(Color.white)
            }
            
        }
    }
}
*/


