//
//  ViewController.swift
//  SeeFood
//
//  Created by Faiq on 23/03/2021.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- Constants and Variables
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera  //.photoLibrary to access library
        imagePicker.allowsEditing = false
    }
    
    //MARK:- ImagePicker Delegates Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //1- Picking or capturing image
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            //2- Converting it into CIImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            //3- Passing image for detecting
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper Methods
    func detect(image: CIImage) {
        //1- Load up our Inceptionv3 Model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Fails")
        }
        
        //2- Create a request for classification from model
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let request = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            //Will show all results
            print(request)
        }
        
        //3- Data which we are passing for classification
        let handler = VNImageRequestHandler(ciImage: image)
        
        //4- Perform the req
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    //MARK:- IBActions
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}

