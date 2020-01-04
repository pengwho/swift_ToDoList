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
    
    @IBOutlet weak var ShowChosenIcon: UIImageView!
    @IBOutlet weak var ShowChosenLabel: UILabel!
    @IBOutlet weak var ChooseSegment: UISegmentedControl!
    
    
    var textSendFormVC: String? = ""
    var textIndexSendFormVC: Int? = -1
    var priorityIdSendFormVC: Int? = 0
    
    let priorityImageDics: [Int:UIImage] = [0: UIImage(named: "icon_transparent")!,
                                            1: UIImage(named: "icon_star_blue")!,
                                            2: UIImage(named: "icon_star_yellow")!,
                                            3: UIImage(named: "icon_star_orange")!,
                                            4: UIImage(named: "icon_star_red")!]
    
    let priorityColorDics: [Int:UIColor] = [0: UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0),
                                            1: UIColor(red:0.00, green:0.09, blue:1.00, alpha:1.0),
                                            2: UIColor(red:0.54, green:0.59, blue:0.00, alpha:1.0),
                                            3: UIColor(red:0.59, green:0.32, blue:0.00, alpha:1.0),
                                            4: UIColor(red:0.75, green:0.00, blue:0.00, alpha:1.0)]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.TaskEditTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskEditTextField.text = textSendFormVC
        ChooseSegment.selectedSegmentIndex = priorityIdSendFormVC!
        ShowChosenIcon?.image = priorityImageDics[ChooseSegment.selectedSegmentIndex]
        ShowChosenLabel?.textColor = priorityColorDics[ChooseSegment.selectedSegmentIndex]
        ChooseSegment?.tintColor = priorityColorDics[ChooseSegment.selectedSegmentIndex]
        
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
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        switch ChooseSegment.selectedSegmentIndex {
        case 0...ChooseSegment.numberOfSegments-1 :
            ShowChosenIcon?.image = priorityImageDics[ChooseSegment.selectedSegmentIndex]
            ShowChosenLabel?.textColor = priorityColorDics[ChooseSegment.selectedSegmentIndex]
            ChooseSegment?.tintColor = priorityColorDics[ChooseSegment.selectedSegmentIndex]
            priorityIdSendFormVC = ChooseSegment.selectedSegmentIndex
        default:
            print("Segment Change Error!")
            break
        }
    }

}
