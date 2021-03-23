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
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper Methods
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Fails")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let request = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            //Will show all results
            print(request)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
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

