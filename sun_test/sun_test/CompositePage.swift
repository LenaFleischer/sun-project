
import SwiftUI


let orangey = Color(red: 1.00, green: 0.73, blue: 0.47)
let pinky = Color(red: 1.00, green: 0.54, blue: 0.54)

let backgroundC = LinearGradient(
    colors: [pinky, orangey],
    startPoint: .top, endPoint: .bottom)

public var percentDict: [String: [Double]] = [:]
public var timeDict: [String: [String]] = [:]
public var currLocation: String = ""

struct CompositePage: View {
    @Binding var locationArray: [String]
   
    @State var goToAddLocation = false
    @State private var sunriseToggle = true
    
    @State var currentPercent:Double = -1
    @State var currentTime = ""
    @State var currentPrediction = ""

    var body: some View {
        
        NavigationView{
            VStack{
                TabView{
                    ForEach(locationArray, id: \.self){ location in
                        ZStack{
                            // sets the background color and circle
                            backgroundC
                            Image("halfCircle")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.3)
                                .padding()
                                
                            VStack{
                                let locPercentArr = percentDict[location]
                                let sunrisePercent = locPercentArr?[0] ?? -1
                                let sunsetPercent = locPercentArr?[1] ?? -1
                                let sunrisePrediction = getAstheticQuality(prediction: sunrisePercent)
                                let sunsetPrediction = getAstheticQuality(prediction: sunsetPercent)
                                
                                
                                let locTimeArr = timeDict[location]
                                let sunriseTime = locTimeArr![0]
                                let sunsetTime = locTimeArr![1]
                                
                                let sunsetViewTime = getViewByTime(actualTime: sunsetTime)
                                let sunriseViewTime = getViewByTime(actualTime: sunriseTime)
                                
                                
                                Toggle("sunrise", isOn: $sunriseToggle)
                                    .labelsHidden() // hides the text label
                                    .toggleStyle(SwitchToggleStyle(tint: .white))
                            
                                // this either dispays the location or, if it is the current locaction, then also displays 'current'
                                if (currLocation == location){
                                    Text("Current: \(location)")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 30, weight: .light, design: .default))
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .padding()
                                }
                                else{
                                    Text(location)
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 40, weight: .light, design: .default))
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .padding()
                                }
                                
                                
                                if sunriseToggle{
                                    Text("sunrise")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 40, weight: .light, design: .default))
                                    
                                    HStack{
                                        if sunrisePercent > 10{
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            if sunrisePercent > 30{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                                if sunrisePercent > 50{
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(Color.white)
                                                        .imageScale(.large)
                                                    if sunrisePercent > 70 {
                                                        Image(systemName: "star.fill")
                                                            .foregroundColor(Color.white)
                                                            .imageScale(.large)
                                                        if sunrisePercent > 90 {
                                                            Image(systemName: "star.fill")
                                                                .foregroundColor(Color.white)
                                                                .imageScale(.large)
                                                        }
                                                        else if sunrisePercent > 80 { //81-90
                                                            Image(systemName: "star.leadinghalf.fill")
                                                                .foregroundColor(Color.white)
                                                                .imageScale(.large)
                                                            
                                                        }else { // 71-80
                                                            Image(systemName: "star")
                                                                .foregroundColor(Color.white)
                                                                .imageScale(.large)
                                                        }
                                                    }
                                                    else if sunrisePercent > 60 { //61-70
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
                                                else if sunrisePercent > 40{ //41-50
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
                                            }else if sunrisePercent > 20{ //21-30
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
                                    VStack{
                                        Spacer()
                                            .frame(height: 75)
                                        Text("\(Int(sunrisePercent))%")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 40, weight: .light, design: .default))
                                        Spacer()
                                            .frame(height: 75)
                                        Text("prediction: \(sunrisePrediction)")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 40, weight: .light, design: .default))
                                        Text("view by \(sunriseViewTime) a.m.")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 40, weight: .light, design: .default))
                                        Text("sunrise at \(sunriseTime) a.m.")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 40, weight: .light, design: .default))
                                    }
                                }else {
                                    Text("sunset")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 40, weight: .light, design: .default))
                                    HStack{
                                        if sunsetPercent > 10{
                                            Image(systemName: "star.fill")
                                                .foregroundColor(Color.white)
                                                .imageScale(.large)
                                            if sunsetPercent > 30{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color.white)
                                                    .imageScale(.large)
                                                if sunsetPercent > 50{
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(Color.white)
                                                        .imageScale(.large)
                                                    if sunsetPercent > 70 {
                                                        Image(systemName: "star.fill")
                                                            .foregroundColor(Color.white)
                                                            .imageScale(.large)
                                                        if sunsetPercent > 90 {
                                                            Image(systemName: "star.fill")
                                                                .foregroundColor(Color.white)
                                                                .imageScale(.large)
                                                        }
                                                        else if sunsetPercent > 80 { //81-90
                                                            Image(systemName: "star.leadinghalf.fill")
                                                                .foregroundColor(Color.white)
                                                                .imageScale(.large)
                                                            
                                                        }else { // 71-80
                                                            Image(systemName: "star")
                                                                .foregroundColor(Color.white)
                                                                .imageScale(.large)
                                                        }
                                                    }
                                                    else if sunsetPercent > 60 { //61-70
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
                                                else if sunsetPercent > 40{ //41-50
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
                                            }else if sunsetPercent > 20{ //21-30
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
                                    VStack{
                                        Spacer()
                                            .frame(height: 75)
                                        Text("\(Int(sunsetPercent))%")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 40, weight: .light, design: .default))
                                        Spacer()
                                            .frame(height: 75)
                                        Text("prediction: \(sunsetPrediction)")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 40, weight: .light, design: .default))
                                        Text("view by \(sunsetViewTime) p.m.")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 40, weight: .light, design: .default))
                                        Text("sunset at \(sunsetTime) p.m.")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 40, weight: .light, design: .default))
                                    }
                                }

                                
                                
                                
                                
                                
                                Spacer()
                                    .frame(height: 10)

                                // this HStack contains the two buttons and the label about viewing 20 mins early
                                HStack{
                                    NavigationLink(destination: AddLocation(locationArray: locationArray), isActive: $goToAddLocation) { EmptyView() }
                                    
                                    if (percentDict.count > 1 && currLocation != location){
                                        
                                        Button(action: {
                                            //removes the location from dict
                                            if let index = locationArray.firstIndex(of: location) {
                                                locationArray.remove(at: index)
                                            }
                                            percentDict[location] = nil
                                            timeDict[location] = nil
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
                                    Spacer()
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
                .background(LinearGradient(
                    colors: [pinky, orangey],
                    startPoint: .top, endPoint: .bottom))
                .background(pinky.edgesIgnoringSafeArea(.top)) // fills the screen color to the top
                .background(orangey.edgesIgnoringSafeArea(.bottom)) // fills the screen color to the bottom
                
            }
        }
        // this hides the back button
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
    }
}

// converts the cloud cover percentage to a good bad fine condition
func getAstheticQuality(prediction: Double) -> String{
    if (prediction > 90){
        return "amazing"
    }
    else if (prediction > 70){
        return "great"
    }
    else if (prediction > 50){
        return "good"
    }
    else if (prediction > 20){
        return "ok"
    }
    else {
        return "bad"
    }
}




func getViewByTime(actualTime: String) -> String{
    // get the minutes
    let timeItems = actualTime.split(separator: ":")
    let hour = Int(timeItems[0]) ?? 0
    let mins = Int(timeItems[1]) ?? 0
    
    if ((mins - 20) >= 0){
        let newMins = String(mins - 20)
        return String(hour) + ":" + newMins
    } else {
        let newHour = hour - 1
        let newMins = (mins + 60) - 20
        return String(newHour) + ":" + String(newMins)
    }
}

