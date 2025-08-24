//
//  ImagePickerView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 12.04.2025.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct ImagePickerView: View {
    
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            
            Button {
                isPickerShowing = true
            } label: {
                Text("Select a photo")
            }
            
            //Upload
            if selectedImage != nil {
                Button {
                    uploadPhoto()
                } label: {
                    Text("Upload  photo")
                }
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(
                selectedImage: $selectedImage,
                isPickerShowing: $isPickerShowing
            )
        }
    }
    
    /*func uploadPhoto() {
        
        //Make sure that the selected image property isn't nil
        guard selectedImage != nil else {
            return
        }
        
        //Create storage reference
        let storageRef = Storage.storage().reference()
        
        //Turn our image into data
        let imageData = selectedImage!.jpegData(compressionQuality: 0.6)
        
        guard imageData != nil else {
            return
        }
        
        //Specify the file path and name
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        //Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                
                //Save a reference to the file in Firestore
                let db = Firestore.firestore()
                db.collection("images")
                    .document()
                    .setData(["url":path])
                
            }
        }
        
    }*/
    
    func uploadPhoto() {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.6) else {
            return
        }

        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = Storage.storage().reference().child(path)

        fileRef.putData(imageData, metadata: nil) { metadata, error in
            if error == nil {
                fileRef.downloadURL { url, error in
                    if let url = url {
                        let db = Firestore.firestore()
                        db.collection("images").document().setData(["url": url.absoluteString])
                    }
                }
            } else {
                print("Upload error: \(error!.localizedDescription)")
            }
        }
    }

}

#Preview {
    ImagePickerView()
}

