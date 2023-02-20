
import SwiftUI


let orangey = Color(red: 1.00, green: 0.73, blue: 0.47)
let pinky = Color(red: 1.00, green: 0.54, blue: 0.54)

let backgroundC = LinearGradient(
    colors: [pinky, orangey],
    startPoint: .top, endPoint: .bottom)

public var locDict: [String: [Double]] = [:]
public var currLocation: String = ""

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
                                let sunriseCoverDub = cloudCoverArr?[0] ?? -1
                                let sunsetCoverDub = cloudCoverArr?[1] ?? -1
                                
                                let fixed_location = getFixedLocation(location: location)
                                if (currLocation == location){
                                    Text("Current: \(fixed_location)")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 30, weight: .light, design: .default))
                                        //.frame(alignment: .top)
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .padding()
                                   // Spacer()
                                     //   .frame(height: 60)
                                }
                                else{
                                    Text(fixed_location)
                                    
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 40, weight: .light, design: .default))
                                    //.frame(alignment: .top)
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .padding()
                                  //  Spacer()
                                   //     .frame(height: 50)
                                }
                                
                                
                                
                                Text("sunrise")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 40, weight: .light, design: .default))
                                HStack{
                                    /*
                                    91-100  - 5    - XXXXX
                                    81-90   - 4.5  - XXXXx
                                    71-80   - 4    - XXXX0
                                    61-70   - 3.5  - XXXx0
                                    51-60   - 3    - XXX00
                                    41-50   - 2.5  - XXx00
                                    31-40   - 2    - XX000
                                    21-30   - 1.5  - Xx000
                                    11-20   - 1    - X0000
                                    0-10    - 0    - 00000
                                     
                                     30-59 good
                                     0-30 fine
                                     60-100 bad 
                                    */
                                    
                                    // this is the part for when we get the % from lenas code
                                    if sunriseCoverDub > 10{
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        if sunriseCoverDub > 30{
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            if sunriseCoverDub > 50{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                                if sunriseCoverDub > 70 {
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(Color.white)
                                                        .imageScale(.large)
                                                    if sunriseCoverDub > 90 {
                                                        Image(systemName: "star.fill")
                                                            .foregroundColor(Color.white)
                                                            .imageScale(.large)
                                                    }
                                                    else if sunriseCoverDub > 80 { //81-90
                                                        Image(systemName: "star.leadinghalf.fill")
                                                            .foregroundColor(Color.white)
                                                            .imageScale(.large)
                                                        
                                                    }else { // 71-80
                                                        Image(systemName: "star")
                                                            .foregroundColor(Color.white)
                                                            .imageScale(.large)
                                                    }
                                                }
                                                else if sunriseCoverDub > 60 { //61-70
                                                    Image(systemName: "star.leadinghalf.fill")
                                                        .foregroundColor(Color.white)
                                                        .imageScale(.large)
                                                    Image(systemName: "star")
                                                        .foregroundColor(Color.white)
                                                        .imageScale(.large)
                                                }else { // 51-60
                                                    Image(systemName: "star")
                                                        .foregroundColor(Color.white)
                                                        .imageScale(.large)
                                                    Image(systemName: "star")
                                                        .foregroundColor(Color.white)
                                                        .imageScale(.large)
                                                }
                                            }
                                            else if sunriseCoverDub > 40{ //41-50
                                                Image(systemName: "star.leadinghalf.fill")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                                Image(systemName: "star")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                                Image(systemName: "star")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                            } else{ //31-40
                                                Image(systemName: "star")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                                Image(systemName: "star")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                                Image(systemName: "star")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                            }
                                        }else if sunriseCoverDub > 20{ //21-30
                                            Image(systemName: "star.leadinghalf.fill")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            Image(systemName: "star")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            Image(systemName: "star")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            Image(systemName: "star")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                       } else{ //11-20
                                            Image(systemName: "star")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            Image(systemName: "star")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            Image(systemName: "star")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            Image(systemName: "star")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                       }
                                    } else{ // 0-10
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                    }
                                        
                                }
                                VStack{ // got errors if this is not in a vstack
                                    Spacer()
                                        .frame(height: 60)
                                    Text("Time")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 40, weight: .light, design: .default))
                                    
                                    Text("prediction: \(sunriseCover)")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 40, weight: .light, design: .default))
                                    
                                    Spacer()
                                        .frame(height: 70)
                                    
                                    Text("prediction: \(sunsetCover)")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 40, weight: .light, design: .default))
                                    
                                    Text("Time")
                                     .foregroundColor(Color.white)
                                     .font(.system(size: 40, weight: .light, design: .default))
                                     
                                    Spacer()
                                        .frame(height: 55)
                                }
                                HStack{
                                    if sunriseCover == "good"{
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                    }
                                    else if sunriseCover == "fine"{
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star.leadinghalf.fill")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                    }
                                    else{
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundColor(Color.white)
                                            .imageScale(.large)
                                    }
                                    
                                }
                                
                                Text("sunset")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 40, weight: .light, design: .default))
                                
                                Spacer()
                                    .frame(height: 10)
                                
                               /* Text("for best views,")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20, weight: .light, design: .default))
                                    .frame(alignment: .bottom)
                                Text("go outside 20 minutes early!")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20, weight: .light, design: .default))
                                    .frame(alignment: .bottom)
                           */
                                HStack{
                                    NavigationLink(destination: AddLocation(locationArray: locationArray), isActive: $goToAddLocation) { EmptyView() }
                                    
                                    if (locDict.count > 1 && currLocation != location){
                                        
                                        Button(action: {
                                            //removes the location from dict
                                            if let index = locationArray.firstIndex(of: location) {
                                                locationArray.remove(at: index)
                                            }
                                            locDict[location] = nil
                                        }
                                               , label: {
                                            Image(systemName: "trash")
                                                .imageScale(.large)
                                                .foregroundColor(Color.white)
                                                .frame(maxHeight: .infinity)
                                                .padding()
                                        })
                                        
                                        
                                    } else{
                                        Spacer()
                                            .frame(width: 40)
                                    }
                                    
                                    VStack{
                                        Text("for best views,")
                                             .foregroundColor(Color.white)
                                             .font(.system(size: 20, weight: .light, design: .default))
                                             
                                         Text("go outside 20 minutes early!")
                                             .foregroundColor(Color.white)
                                             .font(.system(size: 20, weight: .light, design: .default))
                                             
                                    }
                                   // Spacer()
                                    Button(action: {
                                        goToAddLocation = true}
                                           , label: {
                                        Image("add")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .imageScale(.large)
                                            .frame(maxHeight: .infinity)
                                            .padding()
                                    })
                                }
                            }
                        }
                    }
                }
                .tabViewStyle(.page) // gives the page the ...'s 
                .background(pinky.edgesIgnoringSafeArea(.top))
                .background(orangey.edgesIgnoringSafeArea(.bottom))
                
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


func getFixedLocation(location:String) -> String{
    let commaIndex = location.firstIndex(of:",")
    
    var fixed_location = location
    
    if(commaIndex != nil){
        let city = location[..<commaIndex!]
        
        let stateIndex = location.index(commaIndex!, offsetBy: 1)
        let state = location[stateIndex...]
        
        fixed_location = String(city) + ", " + String(state)
    }
    
    return fixed_location
}




