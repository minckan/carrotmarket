//
//  File.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class RegistrationController : UIViewController {

    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private var currentPosition:Position?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .carrotOrange500
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "mail")
        let view = Utilities().inputContainerViewWithImage(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerViewWithImage(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerViewWithImage(withImage: image, textField: fullNameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerViewWithImage(withImage: image, textField: usernameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Full Name")
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "UserName")
        return tf
    }()
        
    private let alreadyHaveAccountButton: UIButton = {
        let button = AttributedStrings().attributitedButton("Already have and account?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .carrotOrange400
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
 
    var locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("DEBUG: 위치 서비스 on")
            locationManager.startUpdatingLocation()
            printDebug(locationManager.location?.coordinate)
        } else {
            print("DEBUG: 위치 서비스 off")
        }
        
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegistration() {
        
        guard let profileImage = profileImage else {
            print("DEBUG: please selecr a profile image...")
            return
        }
        
        guard let position = currentPosition else {return}

        guard let email = emailTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        
        let credential = AuthCredential(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage, position: position)
        
        
        
        UserService.shared.registerUser(credential: credential) { error, ref in
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true)
        }
        
        

    }
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 128, height: 128)
    
        // add stack view programmatically
        let stack = UIStackView(arrangedSubviews: [
            emailContainerView,
            passwordContainerView,
            fullnameContainerView,
            usernameContainerView,
            registrationButton])
        
        
        
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileImage
        
        //
        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFit
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}

extension RegistrationController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("didUpdateLocations")
        
        if let location = locations.first {
            printDebug(location.coordinate.latitude)
            printDebug(location.coordinate.longitude)
            
            currentPosition = Position(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            
            saveData(key: Const.LAT, value: String(location.coordinate.latitude))
            saveData(key: Const.LON, value: String(location.coordinate.longitude))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printDebug(error.localizedDescription)
    }
}
