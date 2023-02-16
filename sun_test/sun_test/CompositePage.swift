
import SwiftUI


let orangey = Color(red: 1.00, green: 0.73, blue: 0.47)
let pinky = Color(red: 1.00, green: 0.54, blue: 0.54)

let backgroundC = LinearGradient(
    colors: [pinky, orangey],
    startPoint: .top, endPoint: .bottom)

public var locDict: [String: [Double]] = [:]

struct CompositePage: View {
    @Binding var locationArray: [String]
    @State var goToAddLocation = false

    var body: some View {
        
        NavigationView{
            VStack{
                TabView{
                    ForEach(locationArray, id: \.self){ location in
                        ZStack{
                            backgroundC
                            Image("splitCircle")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.3)
                                .padding()
                            VStack{
                                let cloudCoverArr = locDict[location]
                                let sunriseCover = getAstheticQuality(cloudCover: cloudCoverArr?[0] ?? -1)
                                let sunsetCover = getAstheticQuality(cloudCover: cloudCoverArr?[1] ?? -1)
                                
                                Text(location)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30, weight: .light, design: .serif))
                                    //.frame(alignment: .top)
                                    .frame(maxHeight: .infinity, alignment: .top)
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
                                
                                /*Image("splitCircle")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.3)
                                    .padding()
                                */
                                Spacer()
                                    .frame(height: 65)

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
                            
                                
                                Text("sunset")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30, weight: .light, design: .serif))
                           
                                HStack{
                                    NavigationLink(destination: AddLocation(locationArray: locationArray), isActive: $goToAddLocation) { EmptyView() }
                                    if (locDict.count > 1){
                                        Button(action: {
                                            //removes the location from dict
                                            if let index = locationArray.firstIndex(of: location) {
                                                locationArray.remove(at: index)
                                            }
                                            locDict[location] = nil
                                        }
                                               , label: {
                                            Image(systemName: "trash")
                                                .imageScale(.medium)
                                                .foregroundColor(Color.white)
                                                .frame(maxHeight: .infinity, alignment: .bottom)
                                        })
                                    }
                                    
                                    
                                    Button(action: {
                                        goToAddLocation = true}
                                           , label: {
                                        Image("add")
                                            .imageScale(.medium)
                                            .frame(maxHeight: .infinity, alignment: .bottom)
                                            
                                    })
                                }
                                
                            }
                        }
                    }
                }
                .tabViewStyle(.page)
                
                
            }
        }
        // this hides the back button
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





/*struct ImageOverlay: View {
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
        
        Text("prediction: ")
            .foregroundColor(Color.white)
            .font(.system(size: 30, weight: .light, design: .serif))

        
        // CENTER OF CIRCLE

        Text("hello: ")
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
}*/



