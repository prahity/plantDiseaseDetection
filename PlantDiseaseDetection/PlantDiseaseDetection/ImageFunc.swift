//
//  ImageFunc.swift
//  PlantDiseaseDetection
//
//  Created by Prahit Yaugand on 3/1/25.
//

import Foundation
import SwiftUI

func sendImageToServer(img: UIImage, url: URL) {
    // Convert image to JPEG data with compression
    guard let imageData = img.jpegData(compressionQuality: 0.8) else {
        print("Error: Could not convert image to JPEG data.")
        return
    }

    // Generate unique boundary string for multipart form data
    let boundary = UUID().uuidString

    // Create a URLRequest
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // Set the Content-Type header for multipart/form-data with boundary
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    // Initialize an empty Data object to build the body of the request
    var body = Data()

    // Start the multipart form data
    body.append("--\(boundary)\r\n".data(using: .utf8)!)

    // Add content disposition (image field name and filename)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)

    // Append the Content-Type for the image
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)

    // Append the actual image data
    body.append(imageData)

    // End the multipart form data
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    // Set the body of the request
    request.httpBody = body

    // Perform the request using URLSession
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Check for errors
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }

        // Check if we received a valid response
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                print("Image uploaded successfully.")
            } else {
                print("Failed to upload image. Status code: \(httpResponse.statusCode)")
            }
        } else {
            print("Error: Invalid response received.")
        }

        // Optionally, you can log the server's response data
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Server Response: \(responseString)")
        }
    }

    // Start the task
    task.resume()
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.modalPresentationStyle = .fullScreen
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }
    }
}

