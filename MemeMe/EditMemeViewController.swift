//
//  EditMemeViewController.swift
//  MemeMe
//
//  Created by minhdat on 20/08/2022.
//

import UIKit
import Foundation

protocol EditMemeViewControllerDelegate: AnyObject {
    func reloadData()
}

class EditMemeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBot: UITextField!
    @IBOutlet weak var contentImageView: UIView!
    @IBOutlet weak var albumItem: UIBarButtonItem!
    @IBOutlet weak var cameraItem: UIBarButtonItem!
    
    @IBAction func albumAction(_ sender: Any) {
        self.chooseSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        self.chooseSourceType(sourceType: .camera)
    }
    
    weak var delegate: EditMemeViewControllerDelegate?

    let memeTextAttributes:[NSAttributedString.Key:Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.5]
    
    func configureText(textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.sizeToFit()
    }
    
    func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        self.title = "Meme"
        subscribeToKeyboardNotifications()
        self.configureText(textField: self.textFieldTop, text: "TOP TEXTFIELD")
        self.configureText(textField: self.textFieldBot, text: "BOTTOM TEXTFIELD")
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupGestures() {
        let tapped = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapped)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if textFieldBot.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        else if textFieldTop.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func saveAction() {
        let memedImage = self.getMemeImage()
        let meme = MemeModel(topTextField: textFieldTop.text, botTextField: textFieldBot.text, image: imageView.image, memedImage: memedImage)
        MemeService.object.memes.append(meme)
        delegate?.reloadData()
        self.dismiss(animated: true)
    }
    
    @objc func shareAction() {
        let memedImage = self.getMemeImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItemds: [Any]?, error: Error?) -> Void in
            if completed {
                self.saveAction()
            }
        }
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true)
    }
    
    func getMemeImage() -> UIImage {
        self.contentImageView.layoutIfNeeded()
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.contentImageView.drawHierarchy(in: self.imageView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
}

extension EditMemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func chooseSourceType(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("PhotoService: Could not create image :(")
            return
        }
        imageView.image = image
        imageView.backgroundColor = .clear
        self.view.layoutIfNeeded()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditMemeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


