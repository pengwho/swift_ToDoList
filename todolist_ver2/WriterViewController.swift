//
//  WriterViewController.swift
//  todolist_ver2
//
//  Created by Alice on 2019/12/29.
//  Copyright © 2019 Alice. All rights reserved.
//

import UIKit

class WriterViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var TaskEditTextField: UITextView!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var CloseKeyBoardButton : UIButton!
    
    var textSendForVC: String? = ""
    var textIndexSendForVC: Int? = -1
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.TaskEditTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskEditTextField.text = textSendForVC
        
        CloseKeyBoardButton.layer.cornerRadius = CloseKeyBoardButton.frame.size.width/2
        EnterButton.layer.cornerRadius = EnterButton.frame.size.width/2
        TaskEditTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeKeyBoard() {
        TaskEditTextField.resignFirstResponder()
        print("closeKeyBoard!")
    }
    
    @objc func keyBoardShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let intersection = keyboardSize.intersection(view.frame)
        
        view.frame.size = CGSize(width: view.frame.width, height: view.frame.height-intersection.height)
    }
    
    @objc func keyBoardHide(_ notification: Notification) {
        view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

}
