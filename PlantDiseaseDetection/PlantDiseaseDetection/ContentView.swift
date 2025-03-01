//  ContentView.swift
//  PlantAppDisease
//
//  Created by Prahit Yaugand on 2/28/25.
//

import SwiftUI


struct ContentView: View {
    @State var val:String = ""
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    let api_url = URL(string: "http://172.16.48.212:5001/predict")
    var body: some View {
        Spacer()
        Text("Plant Disease Detection")
        Spacer()
            TabView(selection: .constant(1)) {
                VStack {
                    HStack {
                        Button("Take Picture") {
                            showImagePicker = true
                            sourceType = .camera
                        }.font(.headline)
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
                        }.font(.headline)
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
                    sendImageToServer(img: image!, url: api_url!)
                }.font(.headline)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 5)
                HStack {
                    Text("Response:")
                    Spacer()
                    
                }
                    if let image = image {
                        Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                }
                }.tabItem { Text("Question") }.tag(1)
            Text("Tab Content 2").tabItem { Text("Map") }.tag(2)
        }.sheet(isPresented: $showImagePicker) {
        ImagePicker(image: $image, sourceType: sourceType)
        
    }
    
    }
}

#Preview {
    ContentView()
}
