import SwiftUI
import CoreLocation

// Model to store the location and response data
struct LocationResponse: Identifiable {
    var id = UUID()  // Unique identifier for each entry
    var latitude: Double
    var longitude: Double
    var response: String
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var userLatitude: Double?
    @Published var userLongitude: Double?
    
    // Store location and response in a list
    @Published var locationResponses: [LocationResponse] = []

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate method to update the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    // Function to add a location and response to the list
    func addLocationResponse(response: String) {
        if let lat = userLatitude, let lon = userLongitude {
            let newLocationResponse = LocationResponse(latitude: lat, longitude: lon, response: response)
            locationResponses.append(newLocationResponse)
        }
    }
}

struct ContentView: View {
    @State var val: String = ""
    @State var rp: String = ""
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    let api_url = URL(string: "http://10.195.170.31:5001/predict")
    @StateObject private var locationManager = LocationManager()
    
    // Use a state to bind to the selected tab
    @State private var selectedTab = 1

    var body: some View {
        VStack {
            Spacer()
            Text("Plant Disease Detection")
                .font(.title)
            Spacer()

            TabView(selection: $selectedTab) { // Bind selection to the state
                ScrollView {
                    VStack {
                        HStack {
                            Button("Take Picture") {
                                showImagePicker = true
                                sourceType = .camera
                            }
                            .font(.headline)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 5)

                            Spacer()

                            Button("Upload Image") {
                                showImagePicker = true
                                sourceType = .photoLibrary
                            }
                            .font(.headline)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                        }

                        TextEditor(text: $val)
                            .frame(height: 150)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))

                        Button("Submit") {
                            hideKeyboard()
                            rp = "Waiting for response ..."
                            if let image = image, let apiUrl = api_url {
                                sendImageToServer(img: image, url: apiUrl) { response in
                                    if let response = response {
                                        rp = response
                                        // Save location and response when submission is done
                                        locationManager.addLocationResponse(response: response)
                                    } else {
                                        rp = "Upload failed"
                                    }
                                }
                            }
                        }
                        .font(.headline)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(radius: 5)

                        HStack {
                            VStack {
                                Text("Response:")
                                Text(rp)
                                    .foregroundColor(rp == "Upload failed" ? .red : .green)
                            }
                            Spacer()
                        }

                        if let lat = locationManager.userLatitude, let lon = locationManager.userLongitude {
                            Text("Latitude: \(lat)")
                            Text("Longitude: \(lon)")
                        } else {
                            Text("Fetching location...")
                        }
                    }

                    // Image Preview
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()
                    }
                }
                .tabItem {
                    Text("Question")
                }
                .tag(1)

                // Second Tab: Displaying the stored location and responses
                VStack {
                    Text("Location Responses")
                        .font(.title2)
                        .padding()

                    List(locationManager.locationResponses) { locationResponse in
                        VStack(alignment: .leading) {
                            Text("Latitude: \(locationResponse.latitude)")
                            Text("Longitude: \(locationResponse.longitude)")
                            Text("Response: \(locationResponse.response)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
                .tabItem {
                    Text("Locations")
                }
                .tag(2)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image, sourceType: sourceType)
            }
        }
    }
}

#Preview {
    ContentView()
}

private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
