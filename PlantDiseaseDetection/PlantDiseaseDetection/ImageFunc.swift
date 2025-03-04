import Foundation
import SwiftUI

import CoreLocation



func sendImageToServer(img: UIImage, url: URL, rp: @escaping (String?) -> Void) {
    guard let imageData = img.jpegData(compressionQuality: 0.8) else {
        print("Error: Could not convert image to JPEG data.")
        rp(nil)
        return
    }

    let boundary = UUID().uuidString

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    var body = Data()
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    request.httpBody = body

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            rp(nil) // Return nil in case of error
            return
        }

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("Image uploaded successfully.")
        } else {
            print("Failed to upload image.")
        }

        // Parse JSON response
        if let data = data {
            do {
                // Decoding the JSON response into a dictionary
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let disease = jsonResponse?["disease"] as? String,
                   let plant = jsonResponse?["plant"] as? String,
                   let prediction = jsonResponse?["prediction"] as? String {
                    let formattedResponse = """
                    Plant: \(plant)
                    Disease/Condition: \(disease)
                    Prediction: \(prediction)
                    """
                    DispatchQueue.main.async {
                        rp(formattedResponse)
                    }
                } else {
                    DispatchQueue.main.async {
                        rp("Error: Malformed response")
                    }
                }
            } catch {
                print("Error parsing JSON response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    rp("Error parsing response")
                }
            }
        } else {
            DispatchQueue.main.async {
                rp("No data received from server")
            }
        }
    }

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
