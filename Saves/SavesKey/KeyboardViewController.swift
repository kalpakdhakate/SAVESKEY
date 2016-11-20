//
//  KeyboardViewController.swift
//  SAVESKEY
//
//  Created by Kalpak Dhakate on 2/1/16.
//  Copyright © 2016 SAVESKEY. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    @IBOutlet weak var nextKeyboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface()
        RoundCorners()
        RoundLbl()
        Swipes()
        checkPSide()
        doubleTapGesture()
        doubleTapGesture1()
        doubleTapGesture2()
        doubleTapGesture3()
        longPressGesture()
        longPressGesture1()
        longPressGesture2()
        longPressGesture3()
    }
    
    func loadInterface(){
        let nib = UINib(nibName: "SavesKey", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        view = objects[0] as! UIView
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
    }
    
    func Swipes(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(KeyboardViewController.flippedView(_:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(KeyboardViewController.originalView(_:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @IBAction func flippedView(_ animated: Bool){
        sideTurned = !sideTurned
        UIView.transition(with: self.view, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1);
            }, completion: { finished in
        })
        checkPSide()
        
        //ApplePayWall
        if (triggerP && triggerC == true)||(triggerP && triggerO == true)||(triggerP && triggerS == true)||(triggerO && triggerC == true)||(triggerC && triggerS == true)||(triggerO && triggerS == true){
            calculations()
        }
        else{
            resetFunc()
        }
        
    }
    @IBAction func originalView(_ animated: Bool){
        sideTurned = !sideTurned
        UIView.transition(with: self.view, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1);
            }, completion: { finished in
        })
        checkPSide()
        if (triggerP && triggerC == true)||(triggerP && triggerO == true)||(triggerP && triggerS == true)||(triggerO && triggerC == true)||(triggerC && triggerS == true)||(triggerO && triggerS == true){
            calculations()
        }
        else{
            resetFunc()
        }
    }
    

    func doubleTapGesture(){
        Price.isUserInteractionEnabled = true
        let dtap = UITapGestureRecognizer(target: self, action: #selector(copyText))
        dtap.numberOfTapsRequired = 3
        
        Price.addGestureRecognizer(dtap)
    }
    @IBAction func copyText(){
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText(self.Price.text!)
        happeningDisplay.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            self.happeningDisplay.alpha = 1
            self.happeningDisplay.text = "PRICE COPIED & PASTED"
            self.happeningDisplay.alpha = 0
        })
    }
    
    func doubleTapGesture1(){
        PercentOff.isUserInteractionEnabled = true
        
        let dtap1 = UITapGestureRecognizer(target: self, action: #selector(copyText1))
        dtap1.numberOfTapsRequired = 3
        
        PercentOff.addGestureRecognizer(dtap1)
    }
    @IBAction func copyText1(){
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText(self.PercentOff.text!)
        happeningDisplay.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            self.happeningDisplay.alpha = 1
            if self.sideTurned == false{
                self.happeningDisplay.text = "%OFF COPIED & PASTED"
            }
            else{
                self.happeningDisplay.text = "%ADD COPIED & PASTED"
            }
            self.happeningDisplay.alpha = 0
        })
    }
    
    func doubleTapGesture2(){
        OfferPrice.isUserInteractionEnabled = true
        
        let dtap2 = UITapGestureRecognizer(target: self, action: #selector(copyText2))
        dtap2.numberOfTapsRequired = 3
        
        OfferPrice.addGestureRecognizer(dtap2)
    }
    @IBAction func copyText2(){
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText(self.OfferPrice.text!)
        happeningDisplay.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            self.happeningDisplay.alpha = 1
            if self.sideTurned == false{
                self.happeningDisplay.text = "OFFER PRICE COPIED & PASTED"
            }
            else{
                self.happeningDisplay.text = "TOTAL PRICE COPIED & PASTED"
            }
            self.happeningDisplay.alpha = 0
        })
    }
    
    func doubleTapGesture3(){
        Savings.isUserInteractionEnabled = true
        
        let dtap3 = UITapGestureRecognizer(target: self, action: #selector(copyText3))
        dtap3.numberOfTapsRequired = 3
        
        Savings.addGestureRecognizer(dtap3)
    }
    @IBAction func copyText3(){
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText(self.Savings.text!)
        happeningDisplay.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            self.happeningDisplay.alpha = 1
            if self.sideTurned == false{
                self.happeningDisplay.text = "SAVINGS AMOUNT COPIED & PASTED"
            }
            else{
                self.happeningDisplay.text = "ADDED AMOUNT COPIED & PASTED"
            }
            self.happeningDisplay.alpha = 0
        })
    }

    
    func longPressGesture(){
        Price.isUserInteractionEnabled = true
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(directPaste))
        lpg.minimumPressDuration = 0.5
        
        Price.addGestureRecognizer(lpg)
    }
    @IBAction func directPaste(){
//        let copied: UIPasteboard = UIPasteboard.generalPasteboard();
//        copied.string = " " + Price.text! + " "
        happeningDisplay.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            self.happeningDisplay.alpha = 1
            self.happeningDisplay.text = "PRICE"
            self.happeningDisplay.alpha = 0
        })
    }
    
    func longPressGesture1(){
        PercentOff.isUserInteractionEnabled = true
        let lpg1 = UILongPressGestureRecognizer(target: self, action: #selector(directPaste1))
        lpg1.minimumPressDuration = 0.5
        
        PercentOff.addGestureRecognizer(lpg1)
    }
    @IBAction func directPaste1(){
//        let copied: UIPasteboard = UIPasteboard.generalPasteboard();
//        copied.string = " " + PercentOff.text! + " "
        happeningDisplay.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            self.happeningDisplay.alpha = 1
            if self.sideTurned == false{
                self.happeningDisplay.text = "%OFF"
            }
            else{
                self.happeningDisplay.text = "%ADD"
            }
            self.happeningDisplay.alpha = 0
        })
    }
    
    func longPressGesture2(){
        OfferPrice.isUserInteractionEnabled = true
        let lpg2 = UILongPressGestureRecognizer(target: self, action: #selector(directPaste2))
        lpg2.minimumPressDuration = 0.5
        
        OfferPrice.addGestureRecognizer(lpg2)
    }
    @IBAction func directPaste2(){
//        let copied: UIPasteboard = UIPasteboard.generalPasteboard();
//        copied.string = " " + OfferPrice.text! + " "
        happeningDisplay.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            self.happeningDisplay.alpha = 1
            if self.sideTurned == false{
                self.happeningDisplay.text = "OFFER PRICE"
            }
            else{
                self.happeningDisplay.text = "TOTAL PRICE"
            }
            self.happeningDisplay.alpha = 0
        })
    }
    
    func longPressGesture3(){
        Savings.isUserInteractionEnabled = true
        let lpg3 = UILongPressGestureRecognizer(target: self, action: #selector(directPaste3))
        lpg3.minimumPressDuration = 0.5
        
        Savings.addGestureRecognizer(lpg3)
    }
    @IBAction func directPaste3(){
//        let copied: UIPasteboard = UIPasteboard.generalPasteboard();
//        copied.string = " " + Savings.text! + " "
        happeningDisplay.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            self.happeningDisplay.alpha = 1
            if self.sideTurned == false{
                self.happeningDisplay.text = "SAVINGS"
            }
            else{
                self.happeningDisplay.text = "ADDED AMOUNT"
            }
            self.happeningDisplay.alpha = 0
        })
    }
    
    @IBOutlet weak var pSide: UILabel!
    var sideTurned = false
    
    func checkPSide(){
        if sideTurned == true{
            self.pSide.text = "SAVESKEY+"
        }
        else{
            self.pSide.text = "SAVESKEY"
        }
    }
    
    func RoundLbl(){
        for label in self.view.subviews{
            if label is UILabel{
                label.alpha = 0
                (label as! UILabel).layer.cornerRadius = 6
                (label as! UILabel).layer.masksToBounds = true
                UIView.animate(withDuration: 0.3, animations: {
                    label.alpha = 1
                })
            }
            //Price.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.5)
        }
    }
    func RoundCorners(){
        for button in self.view.subviews{
            if button is UIButton{
                button.alpha = 0
                (button as! UIButton).layer.cornerRadius = 10
                if button != self.nextKeyboardButton{
                    UIView.animate(withDuration: 0.7, animations: {
                        button.alpha = 1
                    })}
                else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.nextKeyboardButton.alpha = 1
                    })
                }
                //button.backgroundColor = UIColor(red: 000/255, green: 255/255, blue: 000/255, alpha: 0.5) //Green
            }
        }
    }
    
    @IBOutlet var numPadNum0: UIButton!
    @IBOutlet var numPadNum1: UIButton!
    @IBOutlet var numPadNum2: UIButton!
    @IBOutlet var numPadNum3: UIButton!
    @IBOutlet var numPadNum4: UIButton!
    @IBOutlet var numPadNum5: UIButton!
    @IBOutlet var numPadNum6: UIButton!
    @IBOutlet var numPadNum7: UIButton!
    @IBOutlet var numPadNum8: UIButton!
    @IBOutlet var numPadNum9: UIButton!
    
    @IBOutlet var numPadDot: UIButton!
    
    @IBOutlet var numPadBS1: UIButton!
    @IBOutlet var numPadBS2: UIButton!
    @IBOutlet var numPadBS3: UIButton!
    @IBOutlet var numPadBS4: UIButton!

    @IBOutlet weak var happeningDisplay: UILabel!
    
    func numericButtonStateOff(){ //numericButtonStateOff changes [1-9] alpha to 0.5 and enabled to false
        numPadNum0.isEnabled = false
        numPadNum1.isEnabled = false
        numPadNum2.isEnabled = false
        numPadNum3.isEnabled = false
        numPadNum4.isEnabled = false
        numPadNum5.isEnabled = false
        numPadNum6.isEnabled = false
        numPadNum7.isEnabled = false
        numPadNum8.isEnabled = false
        numPadNum9.isEnabled = false
//        numPadNum0.alpha = 0.5
//        numPadNum1.alpha = 0.5
//        numPadNum2.alpha = 0.5
//        numPadNum3.alpha = 0.5
//        numPadNum4.alpha = 0.5
//        numPadNum5.alpha = 0.5
//        numPadNum6.alpha = 0.5
//        numPadNum7.alpha = 0.5
//        numPadNum8.alpha = 0.5
//        numPadNum9.alpha = 0.5
    }
    
    func numericButtonStateOn(){ //numericButtonStateOn changes [1-9] alpha to 1.0 and enabled to true
        numPadNum0.isEnabled = true
        numPadNum1.isEnabled = true
        numPadNum2.isEnabled = true
        numPadNum3.isEnabled = true
        numPadNum4.isEnabled = true
        numPadNum5.isEnabled = true
        numPadNum6.isEnabled = true
        numPadNum7.isEnabled = true
        numPadNum8.isEnabled = true
        numPadNum9.isEnabled = true
//        numPadNum0.alpha = 1
//        numPadNum1.alpha = 1
//        numPadNum2.alpha = 1
//        numPadNum3.alpha = 1
//        numPadNum4.alpha = 1
//        numPadNum5.alpha = 1
//        numPadNum6.alpha = 1
//        numPadNum7.alpha = 1
//        numPadNum8.alpha = 1
//        numPadNum9.alpha = 1

    }
    
    func dotButtonStateOff(){ //dotButtonStateOff changes [.] alpha to 0.5 and enabled to false
//        numPadDot.alpha = 0.5
        numPadDot.isEnabled = false
    }
    
    func dotButtonStateOn(){ //dotButtonStateOn changes [.] alpha to 1.0 and enabled to true
//        numPadDot.alpha = 1
        numPadDot.isEnabled = true
    }
    
    func bsButtonStateCheck(){ //bsButtonStateCheck checks if the bs button should be enabled or disabled
        if Price.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Price.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9){
            numPadBS1.isEnabled = false
//            numPadBS1.alpha = 0.5
        }
        else{
            numPadBS1.isEnabled = true
//            numPadBS1.alpha = 1.0
        }
        if PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9){
            numPadBS2.isEnabled = false
//            numPadBS2.alpha = 0.5
        }
        else{
            numPadBS2.isEnabled = true
//            numPadBS2.alpha = 1.0
        }
        if OfferPrice.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || OfferPrice.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9){
            numPadBS3.isEnabled = false
//            numPadBS3.alpha = 0.5
        }
        else{
            numPadBS3.isEnabled = true
//            numPadBS3.alpha = 1.0
        }
        if Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9){
            numPadBS4.isEnabled = false
//            numPadBS4.alpha = 0.5
        }
        else{
            numPadBS4.isEnabled = true
//            numPadBS4.alpha = 1.0
        }
    }
    
    func buttonStateDueAns(){ //buttonStateDueAns checks if the selected label is an answer. If it is, then keypad is off if any bs button is pressed.
        if Price.layer.borderWidth > 0 && (Price.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Price.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)){
            numericButtonStateOff()
        }
        if PercentOff.layer.borderWidth > 0 && (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)){
            numericButtonStateOff()
        }
        if OfferPrice.layer.borderWidth > 0 && (OfferPrice.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || OfferPrice.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)){
            numericButtonStateOff()
        }
        if Savings.layer.borderWidth > 0 && (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)){
            numericButtonStateOff()
        }
    }
    
    func triggerChecker(){ //triggerChecker checks if the label is an answer. If it is, then it changes it's color.
        if triggerP == false && sideTurned == false && ((triggerC == true && triggerO == true) || (triggerC == true && triggerS == true) || (triggerS == true && triggerO == true)) {
            Price.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
        }
        else if triggerP == false && sideTurned == true && ((triggerC == true && triggerO == true) || (triggerC == true && triggerS == true) || (triggerS == true && triggerO == true)){
            Price.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
        }
        if triggerC == false && sideTurned == false && ((triggerP == true && triggerO == true) || (triggerP == true && triggerS == true) || (triggerS == true && triggerO == true)) {
            PercentOff.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
        }
        else if triggerC == false && sideTurned == true && ((triggerC == true && triggerO == true) || (triggerC == true && triggerS == true) || (triggerS == true && triggerO == true)){
            PercentOff.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
        }
        if triggerO == false && sideTurned == false && ((triggerC == true && triggerP == true) || (triggerC == true && triggerS == true) || (triggerS == true && triggerP == true)) {
            OfferPrice.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
        }
        else if triggerO == false && sideTurned == true && ((triggerC == true && triggerP == true) || (triggerC == true && triggerS == true) || (triggerS == true && triggerP == true)){
            OfferPrice.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
        }
        if triggerS == false && sideTurned == false && ((triggerC == true && triggerO == true) || (triggerC == true && triggerP == true) || (triggerP == true && triggerO == true)) {
            Savings.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
        }
        else if triggerS == false && sideTurned == true && ((triggerC == true && triggerO == true) || (triggerC == true && triggerP == true) || (triggerP == true && triggerO == true)){
            Savings.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
        }
    }
    
    var microResetActive = false
    var microResetActive1 = false
    var microResetActive2 = false
    var microResetActive3 = false
    
    func microReset(){ //reset lvl 1
        if Price.text == "0" || Price.text == "Price"{
            PercentOff.text = PercentOff!.text
            OfferPrice.text = OfferPrice!.text
            Savings.text = Savings!.text
            i = 0
            dotTapped = false
            P = "0"
            microResetActive = true
            if microResetActive1 == true || microResetActive2 == true || microResetActive3 == true{
                miniReset()
            }
        }
        if PercentOff.text == "0" || (PercentOff.text == "% Off" || PercentOff.text == "% Add"){
            Price.text = Price!.text
            OfferPrice.text = OfferPrice!.text
            Savings.text = Savings!.text
            j = 0
            dotTapped1 = false
            C = "0"
            microResetActive1 = true
            if microResetActive == true || microResetActive2 == true || microResetActive3 == true{
                miniReset()
            }
        }
        if OfferPrice.text == "0" || (OfferPrice.text == "Offer Price" || OfferPrice.text == "Total Price"){
            PercentOff.text = PercentOff!.text
            Price.text = Price!.text
            Savings.text = Savings!.text
            k = 0
            dotTapped2 = false
            O = "0"
            microResetActive2 = true
            if microResetActive1 == true || microResetActive == true || microResetActive3 == true{
                miniReset()
            }
        }
        if Savings.text == "0" || (Savings.text == "Savings" || Savings.text == "Added"){
            PercentOff.text = PercentOff!.text
            OfferPrice.text = OfferPrice!.text
            Price.text = Price!.text
            l = 0
            dotTapped3 = false
            S = "0"
            microResetActive3 = true
            if microResetActive1 == true || microResetActive2 == true || microResetActive == true{
                miniReset()
            }
        }
        triggerChecker()
    }

    func miniReset(){ //reset lvl 2. Doesnt reset whole.
        
        if sideTurned == false{
            
            if Price.layer.borderWidth == 0 {
                Price.layer.borderWidth = 0
                Price.text = "Price"
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
            }
            else{
                Price.text = "0"
                clearPrice = true
            }
            if PercentOff.layer.borderWidth == 0 {
                PercentOff.layer.borderWidth = 0
                PercentOff.text = "% Off"
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
//                if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                    PercentOff.text = "0"
//                }
//                else{
//                    PercentOff.text = "% Off"
//                }
            }
            else{
                PercentOff.text = "0"
                clearPercentOff = true
            }
            if OfferPrice.layer.borderWidth == 0 {
                OfferPrice.layer.borderWidth = 0
                OfferPrice.text = "Offer Price"
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
            }
            else{
                OfferPrice.text = "0"
                clearOfferPrice = true
            }
            if Savings.layer.borderWidth == 0 {
                Savings.layer.borderWidth = 0
                Savings.text = "Savings"
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
//                if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                    Savings.text = "0"
//                }
//                else{
//                    Savings.text = "Savings"
//                }
            }
            else{
                Savings.text = "0"
                clearSavings = true
            }
            P = "0"
            C = "0"
            O = "0"
            S = "0"
            triggerC = false
            triggerP = false
            triggerS = false
            triggerO = false
            Price.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            PercentOff.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            OfferPrice.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            Savings.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            dotTapped = false
            dotTapped1 = false
            dotTapped2 = false
            dotTapped3 = false
            i = 0
            j = 0
            k = 0
            l = 0
            calculations()
            numericButtonStateOn()
            dotButtonStateOn()
            
        }
        else{
            if Price.layer.borderWidth == 0 {
                Price.layer.borderWidth = 0
                Price.text = "Price"
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
            }
            else{
                Price.text = "0"
                clearPrice = true
            }
            if PercentOff.layer.borderWidth == 0 {
                PercentOff.layer.borderWidth = 0
                PercentOff.text = "% Add"
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
//                if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                    PercentOff.text = "0"
//                }
//                else{
//                    PercentOff.text = "% Add"
//                }
            }
            else{
                PercentOff.text = "0"
                clearPercentOff = true
            }
            if OfferPrice.layer.borderWidth == 0 {
                OfferPrice.layer.borderWidth = 0
                OfferPrice.text = "Total Price"
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
            }
            else{
                OfferPrice.text = "0"
                clearOfferPrice = true
            }
            if Savings.layer.borderWidth == 0 {
                Savings.layer.borderWidth = 0
                Savings.text = "Added"
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
//                if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                    Savings.text = "0"
//                }
//                else{
//                    Savings.text = "Added"
//                }
            }
            else{
                Savings.text = "0"
                clearSavings = true
            }
            P = "0"
            C = "0"
            O = "0"
            S = "0"
            triggerC = false
            triggerP = false
            triggerS = false
            triggerO = false
            Price.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            PercentOff.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            OfferPrice.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            Savings.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            dotTapped = false
            dotTapped1 = false
            dotTapped2 = false
            dotTapped3 = false
            i = 0
            j = 0
            k = 0
            l = 0
            calculations()
            numericButtonStateOn()
            dotButtonStateOn()
        }
        microResetActive = false
        microResetActive1 = false
        microResetActive2 = false
        microResetActive3 = false
    }
    
    func resetFunc(){ //reset lvl 3. Resets whole.
        
        if sideTurned == false{
            
            if Price.layer.borderWidth == 0 || Price.layer.borderWidth != 0{
                Price.layer.borderWidth = 0
                Price.text = "Price"
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
            }
            else{
                Price.text = "0"
            }
            if PercentOff.layer.borderWidth == 0 || PercentOff.layer.borderWidth != 0{
                PercentOff.layer.borderWidth = 0
                PercentOff.text = "% Off"
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
//                if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                    PercentOff.text = "0"
//                }
//                else{
//                    PercentOff.text = "% Off"
//                }
            }
            else{
                PercentOff.text = "0"
            }
            if OfferPrice.layer.borderWidth == 0 || OfferPrice.layer.borderWidth != 0{
                OfferPrice.layer.borderWidth = 0
                OfferPrice.text = "Offer Price"
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
            }
            else{
                OfferPrice.text = "0"
            }
            if Savings.layer.borderWidth == 0 || Savings.layer.borderWidth != 0{
                Savings.layer.borderWidth = 0
                Savings.text = "Savings"
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
//                if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                    Savings.text = "0"
//                }
//                else{
//                    Savings.text = "Savings"
//                }
            }
            else{
                Savings.text = "0"
            }
//            P = "0"
//            C = "0"
//            O = "0"
//            S = "0"
            triggerC = false
            triggerP = false
            triggerS = false
            triggerO = false
            dotTapped = false
            dotTapped1 = false
            dotTapped2 = false
            dotTapped3 = false
            Price.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            PercentOff.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            OfferPrice.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            Savings.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            i = 0
            j = 0
            k = 0
            l = 0
            calculations()
            numericButtonStateOn()
            dotButtonStateOn()
        }
        else{
            
            if Price.layer.borderWidth == 0 || Price.layer.borderWidth != 0{
                Price.layer.borderWidth = 0
                Price.text = "Price"
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
            }
            else{
                Price.text = "0"
            }
            if PercentOff.layer.borderWidth == 0 || PercentOff.layer.borderWidth != 0{
                PercentOff.layer.borderWidth = 0
                PercentOff.text = "% Add"
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
//                if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                    PercentOff.text = "0"
//                }
//                else{
//                    PercentOff.text = "% Add"
//                }
            }
            else{
                PercentOff.text = "0"
            }
            if OfferPrice.layer.borderWidth == 0 || OfferPrice.layer.borderWidth != 0{
                OfferPrice.layer.borderWidth = 0
                OfferPrice.text = "Total Price"
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
            }
            else{
                OfferPrice.text = "0"
            }
            if Savings.layer.borderWidth == 0 || Savings.layer.borderWidth != 0{
                Savings.layer.borderWidth = 0
                Savings.text = "Added"
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
//                if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                    Savings.text = "0"
//                }
//                else{
//                    Savings.text = "Added"
//                }
            }
            else{
                Savings.text = "0"
            }
//            P = "0"
//            C = "0"
//            O = "0"
//            S = "0"
            triggerC = false
            triggerP = false
            triggerS = false
            triggerO = false
            dotTapped = false
            dotTapped1 = false
            dotTapped2 = false
            dotTapped3 = false
            Price.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            PercentOff.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            OfferPrice.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            Savings.textColor = UIColor(red: 114/255, green: 112/255, blue: 142/255, alpha: 1)
            i = 0
            j = 0
            k = 0
            l = 0
            calculations()
            numericButtonStateOn()
            dotButtonStateOn()
            
        }
        microResetActive = false
        microResetActive1 = false
        microResetActive2 = false
        microResetActive3 = false
    }
    
    var Magenta = UIColor.magenta.cgColor
    
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var PercentOff: UILabel!
    @IBOutlet weak var OfferPrice: UILabel!
    @IBOutlet weak var Savings: UILabel!
    
    var clearPrice = true
    var clearPercentOff = true
    var clearOfferPrice = true
    var clearSavings = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first as UITouch!
        if sideTurned == false{
            if (touch.view == Price){
                
                Price.layer.borderColor = Magenta
                Price.layer.borderWidth = 1.5
                Price.backgroundColor = UIColor.lightText
                if(Price.text == "Price"){
                    Price.text = "0"
                    clearPrice = true
                }
                if(Price.text == "0"){
                    clearPrice = true
                }
                else if(Price.text != "Price"){
                    clearPrice = false
                }
                
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                PercentOff.layer.borderWidth = 0
                if(PercentOff.text == "0"){
//                    if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                        PercentOff.text = "0"
//                    }
//                    else{
//                        PercentOff.text = "% Off"
//                    }
                    PercentOff.text = "% Off"
                }
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                OfferPrice.layer.borderWidth = 0
                if(OfferPrice.text == "0"){
                    OfferPrice.text = "Offer Price"
                }
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Savings.layer.borderWidth = 0
                if(Savings.text == "0"){
//                    if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                        Savings.text = "0"
//                    }
//                    else{
//                        Savings.text = "Savings"
//                    }
                    Savings.text = "Savings"
                }
                
                if dotTapped == false{
                    numericButtonStateOn()
                    dotButtonStateOn()
                }
                if dotTapped == true{
                    if i < 2{
                        numericButtonStateOn()
                        buttonStateDueAns()
                    }
                    else{
                        numericButtonStateOff()
                    }
                    if i < 0{
                        dotButtonStateOn()
                        dotTapped = false
                    }
                    if dotTapped == false{
                        i = 0
                    }
                }
                if Price.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9){
                    numericButtonStateOff()
                    dotButtonStateOff()
                }
            }
                
            else if(touch.view == PercentOff){
                PercentOff.layer.borderColor = Magenta
                PercentOff.layer.borderWidth = 1.5
                PercentOff.backgroundColor = UIColor.lightText
                if(PercentOff.text == "% Off"){
                    PercentOff.text = "0"
                    clearPercentOff = true
                }
                if(PercentOff.text == "0"){
                    clearPercentOff = true
                }
                else if(PercentOff.text != "% Off"){
                    clearPercentOff = false
                }
                
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Price.layer.borderWidth = 0
                if(Price.text == "0"){
                    Price.text = "Price"
                }
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                OfferPrice.layer.borderWidth = 0
                if(OfferPrice.text == "0"){
                    OfferPrice.text = "Offer Price"
                }
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Savings.layer.borderWidth = 0
                if(Savings.text == "0"){
//                    if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                        Savings.text = "0"
//                    }
//                    else{
//                        Savings.text = "Savings"
//                    }
                    Savings.text = "Savings"
                }
                if(Savings.text == "0" && Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)){
                    Savings.text = "0"
                }
                if(Savings.text == "0" && Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)){
                    Savings.text = "0"
                }
                
                if dotTapped1 == false{
                    numericButtonStateOn()
                    dotButtonStateOn()
                }
                if dotTapped1 == true{
                    if j < 2{
                        numericButtonStateOn()
                        buttonStateDueAns()
                    }
                    else{
                        numericButtonStateOff()
                    }
                    if j < 0{
                        dotButtonStateOn()
                        dotTapped1 = false
                    }
                    if dotTapped1 == false{
                        j = 0
                    }
                }
                if PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9){
                    numericButtonStateOff()
                    dotButtonStateOff()
                }
            }
                
            else if(touch.view == OfferPrice){
                OfferPrice.layer.borderColor = Magenta
                OfferPrice.layer.borderWidth = 1.5
                OfferPrice.backgroundColor = UIColor.lightText
                if(OfferPrice.text == "Offer Price"){
                    OfferPrice.text = "0"
                    clearOfferPrice = true
                }
                if(OfferPrice.text == "0"){
                    clearOfferPrice = true
                }
                else if(OfferPrice.text != "Offer Price"){
                    clearOfferPrice = false
                }
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                PercentOff.layer.borderWidth = 0
                if(PercentOff.text == "0"){
//                    if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                        PercentOff.text = "0"
//                    }
//                    else{
//                        PercentOff.text = "% Off"
//                    }
                    PercentOff.text = "% Off"
                }
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Price.layer.borderWidth = 0
                if(Price.text == "0"){
                    Price.text = "Price"
                }
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Savings.layer.borderWidth = 0
                if(Savings.text == "0"){
//                    if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                        Savings.text = "0"
//                    }
//                    else{
//                        Savings.text = "Savings"
//                    }
                    Savings.text = "Savings"
                }
                if(Savings.text == "0" && Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)){
                    Savings.text = "0"
                }
                if(Savings.text == "0" && Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)){
                    Savings.text = "0"
                }
                
                if dotTapped2 == false{
                    numericButtonStateOn()
                    dotButtonStateOn()
                }
                if dotTapped2 == true{
                    if k < 2{
                        numericButtonStateOn()
                        buttonStateDueAns()
                    }
                    else{
                        numericButtonStateOff()
                    }
                    if k < 0{
                        dotButtonStateOn()
                        dotTapped2 = false
                    }
                    if dotTapped2 == false{
                        k = 0
                    }
                }
                if OfferPrice.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9){
                    numericButtonStateOff()
                    dotButtonStateOff()
                }
            }
                
            else if(touch.view == Savings){
                Savings.layer.borderColor = Magenta
                Savings.layer.borderWidth = 1.5
                Savings.backgroundColor = UIColor.lightText
                if(Savings.text == "Savings"){
                    Savings.text = "0"
                    clearSavings = true
                }
                if(Savings.text == "0"){
                    clearSavings = true
                }
                else if(Savings.text != "Savings"){
                    clearSavings = false
                }
                
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                PercentOff.layer.borderWidth = 0
                if(PercentOff.text == "0"){
//                    if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                        PercentOff.text = "0"
//                    }
//                    else{
//                        PercentOff.text = "% Off"
//                    }
                    PercentOff.text = "% Off"
                }
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                OfferPrice.layer.borderWidth = 0
                if(OfferPrice.text == "0"){
                    OfferPrice.text = "Offer Price"
                }
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Price.layer.borderWidth = 0
                if(Price.text == "0"){
                    Price.text = "Price"
                }
                if(Savings.text == "0" && Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)){
                    Savings.text = "0"
                }
                if(Savings.text == "0" && Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)){
                    Savings.text = "0"
                }
                
                if dotTapped3 == false{
                    numericButtonStateOn()
                    dotButtonStateOn()
                }
                if dotTapped3 == true{
                    if l < 2{
                        numericButtonStateOn()
                        buttonStateDueAns()
                    }
                    else{
                        numericButtonStateOff()
                    }
                    if l < 0{
                        dotButtonStateOn()
                        dotTapped3 = false
                    }
                    if dotTapped3 == false{
                        l = 0
                    }
                }
                if Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9){
                    numericButtonStateOff()
                    dotButtonStateOff()
                }
            }
        }
        else{
            if (touch.view == Price){
                Price.layer.borderColor = Magenta
                Price.layer.borderWidth = 1.5
                Price.backgroundColor = UIColor.lightText
                if(Price.text == "Price"){
                    Price.text = "0"
                    clearPrice = true
                }
                if(Price.text == "0"){
                    clearPrice = true
                }
                else if(Price.text != "Price"){
                    clearPrice = false
                }
                
                
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                PercentOff.layer.borderWidth = 0
                if(PercentOff.text == "0"){
//                    if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                        PercentOff.text = "0"
//                    }
//                    else{
//                        PercentOff.text = "% Add"
//                    }
                    PercentOff.text = "% Add"
                }
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                OfferPrice.layer.borderWidth = 0
                if(OfferPrice.text == "0"){
                    OfferPrice.text = "Total Price"
                }
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Savings.layer.borderWidth = 0
                if(Savings.text == "0"){
//                    if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                        Savings.text = "0"
//                    }
//                    else{
//                        Savings.text = "Added"
//                    }
                    Savings.text = "Added"
                }
                
                if dotTapped == false{
                    numericButtonStateOn()
                    dotButtonStateOn()
                }
                if dotTapped == true{
                    if i < 2{
                        numericButtonStateOn()
                        buttonStateDueAns()
                    }
                    else{
                        numericButtonStateOff()
                    }
                    if i < 0{
                        dotButtonStateOn()
                        dotTapped = false
                    }
                    if dotTapped == false{
                        i = 0
                    }
                }
                if Price.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9){
                    numericButtonStateOff()
                    dotButtonStateOff()
                }
            }
                
            else if(touch.view == PercentOff){
                PercentOff.layer.borderColor = Magenta
                PercentOff.layer.borderWidth = 1.5
                PercentOff.backgroundColor = UIColor.lightText
                if(PercentOff.text == "% Add"){
                    PercentOff.text = "0"
                    clearPercentOff = true
                }
                if(PercentOff.text == "0"){
                    clearPercentOff = true
                }
                else if(PercentOff.text != "% Add"){
                    clearPercentOff = false
                }
                
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Price.layer.borderWidth = 0
                if(Price.text == "0"){
                    Price.text = "Price"
                }
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                OfferPrice.layer.borderWidth = 0
                if(OfferPrice.text == "0"){
                    OfferPrice.text = "Total Price"
                }
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Savings.layer.borderWidth = 0
                if(Savings.text == "0"){
//                    if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                        Savings.text = "0"
//                    }
//                    else{
//                        Savings.text = "Added"
//                    }
                    Savings.text = "Added"
                }
                
                if dotTapped1 == false{
                    numericButtonStateOn()
                    dotButtonStateOn()
                }
                if dotTapped1 == true{
                    if j < 2{
                        numericButtonStateOn()
                        buttonStateDueAns()
                    }
                    else{
                        numericButtonStateOff()
                    }
                    if j < 0{
                        dotButtonStateOn()
                        dotTapped1 = false
                    }
                    if dotTapped1 == false{
                        j = 0
                    }
                }
                if PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9){
                    numericButtonStateOff()
                    dotButtonStateOff()
                }
            }
                
            else if(touch.view == OfferPrice){
                OfferPrice.layer.borderColor = Magenta
                OfferPrice.layer.borderWidth = 1.5
                OfferPrice.backgroundColor = UIColor.lightText
                if(OfferPrice.text == "Total Price"){
                    OfferPrice.text = "0"
                    clearOfferPrice = true
                }
                if(OfferPrice.text == "0"){
                    clearOfferPrice = true
                }
                else if(OfferPrice.text != "Total Price"){
                    clearOfferPrice = false
                }
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                PercentOff.layer.borderWidth = 0
                if(PercentOff.text == "0"){
//                    if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                        PercentOff.text = "0"
//                    }
//                    else{
//                        PercentOff.text = "% Add"
//                    }
                    PercentOff.text = "% Add"
                }
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Price.layer.borderWidth = 0
                if(Price.text == "0"){
                    Price.text = "Price"
                }
                Savings.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Savings.layer.borderWidth = 0
                if(Savings.text == "0"){
//                    if (Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || Savings.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && Savings.text == "0"{
//                        Savings.text = "0"
//                    }
//                    else{
//                        Savings.text = "Added"
//                    }
                    Savings.text = "Added"
                }
                
                if dotTapped2 == false{
                    numericButtonStateOn()
                    dotButtonStateOn()
                }
                if dotTapped2 == true{
                    if k < 2{
                        numericButtonStateOn()
                        buttonStateDueAns()
                    }
                    else{
                        numericButtonStateOff()
                    }
                    if k < 0{
                        dotButtonStateOn()
                        dotTapped2 = false
                    }
                    if dotTapped2 == false{
                        k = 0
                    }
                }
                if OfferPrice.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9){
                    numericButtonStateOff()
                    dotButtonStateOff()
                }
            }
                
            else if(touch.view == Savings){
                Savings.layer.borderColor = Magenta
                Savings.layer.borderWidth = 1.5
                Savings.backgroundColor = UIColor.lightText
                if(Savings.text == "Added"){
                    Savings.text = "0"
                    clearSavings = true
                }
                
                if(Savings.text == "0"){
                    clearSavings = true
                }
                else if(Savings.text != "Added"){
                    clearSavings = false
                }
                
                PercentOff.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                PercentOff.layer.borderWidth = 0
                if(PercentOff.text == "0"){
//                    if (PercentOff.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9) || PercentOff.textColor == UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)) && PercentOff.text == "0"{
//                        PercentOff.text = "0"
//                    }
//                    else{
//                        PercentOff.text = "% Add"
//                    }
                    PercentOff.text = "% Add"
                }
                OfferPrice.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                OfferPrice.layer.borderWidth = 0
                if(OfferPrice.text == "0"){
                    OfferPrice.text = "Total Price"
                }
                Price.backgroundColor = UIColor(red: 128/255, green: 209/255, blue: 238/255, alpha: 0.5)
                Price.layer.borderWidth = 0
                if(Price.text == "0"){
                    Price.text = "Price"
                }
                
                if dotTapped3 == false{
                    numericButtonStateOn()
                    dotButtonStateOn()
                }
                if dotTapped3 == true{
                    if l < 2{
                        numericButtonStateOn()
                        buttonStateDueAns()
                    }
                    else{
                        numericButtonStateOff()
                    }
                    if l < 0{
                        dotButtonStateOn()
                        dotTapped3 = false
                    }
                    if dotTapped3 == false{
                        l = 0
                    }
                }
                if Savings.textColor == UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9){
                    numericButtonStateOff()
                    dotButtonStateOff()
                }
            }
        }
    }
    
    var triggerP = false
    var triggerC = false
    var triggerO = false
    var triggerS = false
    
    var P = "0"
    var C = "0"
    var O = "0"
    var S = "0"
    
    func calculations(){
        
        var dblP = Double(P)
        var dblC = Double(C)
        var dblO = Double(O)
        var dblS = Double(S)
        
        if dblP == nil{
            dblP = 0
        }
        if dblC == nil{
            dblC = 0
        }
        if dblO == nil{
            dblO = 0
        }
        if dblS == nil{
            dblS = 0
        }
        if sideTurned == false{
            if (triggerP && triggerC == true){
                dblO = dblP! - ((dblC!/100)*dblP!)
                if dblO! != 0.0{
                    dblS = dblP! - dblO!
                    O = String(format:"%.2f", dblO!)
                    S = String(format:"%.2f", dblS!)
                    OfferPrice.text = O
                    Savings.text = S
                    OfferPrice.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
                if PercentOff.text! == "100"{
                    OfferPrice.text = "0.00"
                    Savings.text = String(format:"%.2f", dblO! + dblP!)
                    OfferPrice.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerP && triggerO == true){
                dblS = dblP! - dblO!
                if dblS! != 0.0{
                    dblC = (100*(dblP! - dblO!))/dblP!
                    C = String(format:"%.2f", dblC!)
                    S = String(format:"%.2f", dblS!)
                    PercentOff.text = C
                    Savings.text = S
                    PercentOff.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
                if Price.text! == OfferPrice.text!{
                    PercentOff.text = "0"
                    Savings.text = "0"
                    PercentOff.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerP && triggerS == true){
                dblO = dblP! - dblS!
                if dblO! != 0.0{
                    dblC = (100*(dblP! - dblO!))/dblP!
                    C = String(format:"%.2f", dblC!)
                    O = String(format:"%.2f", dblO!)
                    PercentOff.text = C
                    OfferPrice.text = O
                    PercentOff.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    OfferPrice.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
                if Price.text! == Savings.text!{
                    OfferPrice.text = "0.00"
                    PercentOff.text = "100"
                    PercentOff.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    OfferPrice.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerO && triggerC == true){
                dblP = (dblO!/(100-dblC!))*100
                if dblP! != 0.0{
                    dblS = dblP! - dblO!
                    P = String(format:"%.2f", dblP!)
                    S = String(format:"%.2f", dblS!)
                    Savings.text = S
                    Price.text = P
                    Price.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerC && triggerS == true){
                dblP = (dblS! * 100)/dblC!
                if dblP! != 0.0{
                    dblO = dblP! - dblS!
                    P = String(format:"%.2f", dblP!)
                    O = String(format:"%.2f", dblO!)
                    OfferPrice.text = O
                    Price.text = P
                    OfferPrice.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    Price.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerO && triggerS == true){
                dblP = dblO! + dblS!
                if dblP! != 0.0{
                    dblC = (100*(dblP! - dblO!))/dblP!
                    P = String(format:"%.2f", dblP!)
                    C = String(format:"%.2f", dblC!)
                    Price.text = P
                    PercentOff.text = C
                    PercentOff.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    Price.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
            }
        }
        else{
            if (triggerP && triggerC == true){
                dblO = dblP! + ((dblC!/100)*dblP!)
                if dblO! != 0.0{
                    dblS = dblO! - dblP!
                    O = String(format:"%.2f", dblO!)
                    S = String(format:"%.2f", dblS!)
                    OfferPrice.text = O
                    Savings.text = S
                    OfferPrice.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                }
                if PercentOff.text! == "100"{
                    OfferPrice.text = String(format:"%.2f", 2*dblP!)
                    Savings.text = String(format:"%.2f", dblO! - dblP!)
                    OfferPrice.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 0/255, green: 75/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerP && triggerO == true){
                dblS = dblO! - dblP!
                if dblS! != 0.0{
                    dblC = (100*(dblO! - dblP!))/dblO!
                    C = String(format:"%.2f", dblC!)
                    S = String(format:"%.2f", dblS!)
                    PercentOff.text = C
                    Savings.text = S
                    PercentOff.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                }
                if Price.text! == OfferPrice.text!{
                    PercentOff.text = "0"
                    Savings.text = "0"
                    PercentOff.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerP && triggerS == true){
                dblO = dblP! + dblS!
                if dblO! != 0.0{
                    dblC = (100*(dblO! - dblP!))/dblO!
                    C = String(format:"%.2f", dblC!)
                    O = String(format:"%.2f", dblO!)
                    PercentOff.text = C
                    OfferPrice.text = O
                    PercentOff.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                    OfferPrice.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerO && triggerC == true){
                dblP = (dblO!/(100 + dblC!))*100
                if dblP! != 0.0{
                    dblS = dblO! - dblP!
                    P = String(format:"%.2f", dblP!)
                    S = String(format:"%.2f", dblS!)
                    Savings.text = S
                    Price.text = P
                    Price.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                    Savings.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerC && triggerS == true){
                dblP = (dblS! * 100)/dblC!
                if dblP! != 0.0{
                    dblO = dblP! + dblS!
                    P = String(format:"%.2f", dblP!)
                    O = String(format:"%.2f", dblO!)
                    OfferPrice.text = O
                    Price.text = P
                    OfferPrice.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                    Price.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                }
            }
            
            if (triggerO && triggerS == true){
                dblP = dblO! - dblS!
                if dblP! != 0.0{
                    dblC = (100*(dblO! - dblP!))/dblO!
                    P = String(format:"%.2f", dblP!)
                    C = String(format:"%.2f", dblC!)
                    Price.text = P
                    PercentOff.text = C
                    PercentOff.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                    Price.textColor = UIColor(red: 114/255, green: 0/255, blue: 120/255, alpha: 0.9)
                }
            }
        }
        bsButtonStateCheck()
        triggerChecker()
    }
    
    var i = 0
    var j = 0
    var k = 0
    var l = 0
    
    @IBAction func buttonTapped(_ sender: UIButton){
        if dotTapped == true && Price.layer.borderWidth != 0{
            i += 1
        }
        if dotTapped1 == true && PercentOff.layer.borderWidth != 0{
            j += 1
        }
        if dotTapped2 == true && OfferPrice.layer.borderWidth != 0{
            k += 1
        }
        if dotTapped3 == true && Savings.layer.borderWidth != 0{
            l += 1
        }
    }
    
    @IBAction func numberTapped(_ number: UIButton) {
        
        number.isUserInteractionEnabled = true
        if sideTurned == false{
            if(Price.layer.borderWidth > 0){
                if Price.text == "0."{
                    clearPrice = false
                }
                else if clearPrice {
                    Price.text = ""
                    clearPrice = false
                }
                if let typedString = number.titleLabel?.text{
                    let typedNSString = typedString as NSString
                    if let nPrice = Price?.text!{
                        if dotTapped == false{
                            Price.text = "\(nPrice)\(typedNSString.intValue)"
                            triggerP = true
                            P = "\(nPrice)\(typedNSString.intValue)"
                            calculations()
                        }
                        else{
                            for _ in 0...100{
                                Price.text = "\(nPrice)\(typedNSString.intValue)"
                                triggerP = true
                                P = "\(nPrice)\(typedNSString.intValue)"
                                calculations()
                                if i > 1{
                                    numericButtonStateOff()
                                    continue
                                }
                            }
                        }
                    }
                }
            }
            
            if(PercentOff.layer.borderWidth > 0){
                if PercentOff.text == "0."{
                    clearPercentOff = false
                }
                else if clearPercentOff {
                    PercentOff.text = ""
                    clearPercentOff = false
                }
                if let typedString2 = number.titleLabel?.text{
                    let typedNSString2 = typedString2 as NSString
                    if let nPrice1 = PercentOff?.text!{
                        if dotTapped1 == false{
                            PercentOff.text = "\(nPrice1)\(typedNSString2.intValue)"
                            triggerC = true
                            C = "\(nPrice1)\(typedNSString2.intValue)"
                            calculations()
                        }
                        else{
                            for _ in 0...100{
                                PercentOff.text = "\(nPrice1)\(typedNSString2.intValue)"
                                triggerC = true
                                C = "\(nPrice1)\(typedNSString2.intValue)"
                                calculations()
                                if j > 1{
                                    numericButtonStateOff()
                                    continue
                                }
                            }
                        }
                    }
                }
            }
            
            if(OfferPrice.layer.borderWidth > 0){
                if OfferPrice.text == "0."{
                    clearOfferPrice = false
                }
                else if clearOfferPrice {
                    OfferPrice.text = ""
                    clearOfferPrice = false
                }
                if let typedString3 = number.titleLabel?.text{
                    let typedNSString3 = typedString3 as NSString
                    if let nPrice2 = OfferPrice?.text!{
                        if dotTapped2 == false{
                            OfferPrice.text = "\(nPrice2)\(typedNSString3.intValue)"
                            triggerO = true
                            O = "\(nPrice2)\(typedNSString3.intValue)"
                            calculations()
                        }
                        else{
                            for _ in 0...100{
                                OfferPrice.text = "\(nPrice2)\(typedNSString3.intValue)"
                                triggerO = true
                                O = "\(nPrice2)\(typedNSString3.intValue)"
                                calculations()
                                if k > 1{
                                    numericButtonStateOff()
                                    continue
                                }
                            }
                        }
                    }
                }
            }
            
            if(Savings.layer.borderWidth > 0){
                
                if Savings.text == "0."{
                    clearSavings = false
                }
                else if clearSavings {
                    Savings.text = ""
                    clearSavings = false
                }
                if let typedString4 = number.titleLabel?.text{
                    let typedNSString4 = typedString4 as NSString
                    if let nPrice3 = Savings?.text!{
                        if dotTapped3 == false{
                            Savings.text = "\(nPrice3)\(typedNSString4.intValue)"
                            triggerS = true
                            S = "\(nPrice3)\(typedNSString4.intValue)"
                            calculations()
                        }
                        else{
                            for _ in 0...100{
                                Savings.text = "\(nPrice3)\(typedNSString4.intValue)"
                                triggerS = true
                                S = "\(nPrice3)\(typedNSString4.intValue)"
                                calculations()
                                if l > 1{
                                    numericButtonStateOff()
                                    continue
                                }
                            }
                        }
                    }
                }
            }
        }
            
        else
        {
            if(Price.layer.borderWidth > 0){
                
                if Price.text == "0."{
                    clearPrice = false
                }
                else if clearPrice {
                    Price.text = ""
                    clearPrice = false
                }
                if let typedString = number.titleLabel?.text{
                    let typedNSString = typedString as NSString
                    if let nPrice = Price?.text!{
                        if dotTapped == false{
                            Price.text = "\(nPrice)\(typedNSString.intValue)"
                            triggerP = true
                            P = "\(nPrice)\(typedNSString.intValue)"
                            calculations()
                        }
                        else{
                            for _ in 0...100{
                                Price.text = "\(nPrice)\(typedNSString.intValue)"
                                triggerP = true
                                P = "\(nPrice)\(typedNSString.intValue)"
                                calculations()
                                if i > 1{
                                    numericButtonStateOff()
                                    continue
                                }
                            }
                        }
                    }
                }
            }
            
            if(PercentOff.layer.borderWidth > 0){
                if PercentOff.text == "0."{
                    clearPercentOff = false
                }
                else if clearPercentOff {
                    PercentOff.text = ""
                    clearPercentOff = false
                }
                if let typedString2 = number.titleLabel?.text{
                    let typedNSString2 = typedString2 as NSString
                    if let nPrice1 = PercentOff?.text!{
                        if dotTapped1 == false{
                            PercentOff.text = "\(nPrice1)\(typedNSString2.intValue)"
                            triggerC = true
                            C = "\(nPrice1)\(typedNSString2.intValue)"
                            calculations()
                        }
                        else{
                            for _ in 0...100{
                                PercentOff.text = "\(nPrice1)\(typedNSString2.intValue)"
                                triggerC = true
                                C = "\(nPrice1)\(typedNSString2.intValue)"
                                calculations()
                                if j > 1{
                                    numericButtonStateOff()
                                    continue
                                }
                            }
                        }
                    }
                }
            }
            
            if(OfferPrice.layer.borderWidth > 0){
                if OfferPrice.text == "0."{
                    clearOfferPrice = false
                }
                else if clearOfferPrice {
                    OfferPrice.text = ""
                    clearOfferPrice = false
                }
                if let typedString3 = number.titleLabel?.text{
                    let typedNSString3 = typedString3 as NSString
                    if let nPrice2 = OfferPrice?.text!{
                        if dotTapped2 == false{
                            OfferPrice.text = "\(nPrice2)\(typedNSString3.intValue)"
                            triggerO = true
                            O = "\(nPrice2)\(typedNSString3.intValue)"
                            calculations()
                        }
                        else{
                            for _ in 0...100{
                                OfferPrice.text = "\(nPrice2)\(typedNSString3.intValue)"
                                triggerO = true
                                O = "\(nPrice2)\(typedNSString3.intValue)"
                                calculations()
                                if k > 1{
                                    numericButtonStateOff()
                                    continue
                                }
                            }
                        }
                    }
                }
            }
            
            if(Savings.layer.borderWidth > 0){
                if Savings.text == "0."{
                    clearSavings = false
                }
                else if clearSavings {
                    Savings.text = ""
                    clearSavings = false
                }
                if let typedString4 = number.titleLabel?.text{
                    let typedNSString4 = typedString4 as NSString
                    if let nPrice3 = Savings?.text!{
                        if dotTapped3 == false{
                            Savings.text = "\(nPrice3)\(typedNSString4.intValue)"
                            triggerS = true
                            S = "\(nPrice3)\(typedNSString4.intValue)"
                            calculations()
                        }
                        else{
                            for _ in 0...100{
                                Savings.text = "\(nPrice3)\(typedNSString4.intValue)"
                                triggerS = true
                                S = "\(nPrice3)\(typedNSString4.intValue)"
                                calculations()
                                if l > 1{
                                    numericButtonStateOff()
                                    continue
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    var dotTapped = false
    var dotTapped1 = false
    var dotTapped2 = false
    var dotTapped3 = false
    
    @IBAction func didTapDot1() {
        
        if sideTurned == false{
            if let input = Price?.text {
                var hasDot = false
                for ch in input.unicodeScalars {
                    if ch == "." {
                        hasDot = true
                        break
                    }
                }
                if (hasDot == false && Price.layer.borderWidth > 0) {
                    dotTapped = true
                    Price.text = "\(input)."
                    dotButtonStateOff()
                }
            }

            if let input2 = PercentOff?.text {
                var hasDot2 = false
                for ch2 in input2.unicodeScalars {
                    if ch2 == "." {
                        hasDot2 = true
                        break
                    }
                }
                if (hasDot2 == false && PercentOff.layer.borderWidth > 0) {
                    dotTapped1 = true
                    PercentOff.text = "\(input2)."
                    dotButtonStateOff()
                }
            }
            
            if let input3 = OfferPrice?.text {
                var hasDot3 = false
                for ch3 in input3.unicodeScalars {
                    if ch3 == "." {
                        hasDot3 = true
                        break
                    }
                }
                if (hasDot3 == false && OfferPrice.layer.borderWidth > 0){
                    dotTapped2 = true
                    OfferPrice.text = "\(input3)."
                    dotButtonStateOff()
                }
            }
            
            if let input4 = Savings?.text {
                var hasDot4 = false
                for ch4 in input4.unicodeScalars {
                    if ch4 == "." {
                        hasDot4 = true
                        break
                    }
                }
                if (hasDot4 == false && Savings.layer.borderWidth > 0){
                    dotTapped3 = true
                    Savings.text = "\(input4)."
                    dotButtonStateOff()
                }
            }
        }
        else{
            if let input = Price?.text {
                var hasDot = false
                for ch in input.unicodeScalars {
                    if ch == "." {
                        hasDot = true
                        break
                    }
                }
                if (hasDot == false && Price.layer.borderWidth > 0) {
                    dotTapped = true
                    Price.text = "\(input)."
                    dotButtonStateOff()
                }
            }
            
            if let input2 = PercentOff?.text {
                var hasDot2 = false
                for ch2 in input2.unicodeScalars {
                    if ch2 == "." {
                        hasDot2 = true
                        break
                    }
                }
                if (hasDot2 == false && PercentOff.layer.borderWidth > 0) {
                    dotTapped1 = true
                    PercentOff.text = "\(input2)."
                    dotButtonStateOff()
                }
            }
            
            if let input3 = OfferPrice?.text {
                var hasDot3 = false
                for ch3 in input3.unicodeScalars {
                    if ch3 == "." {
                        hasDot3 = true
                        break
                    }
                }
                if (hasDot3 == false && OfferPrice.layer.borderWidth > 0){
                    dotTapped2 = true
                    OfferPrice.text = "\(input3)."
                    dotButtonStateOff()
                }
            }
            
            if let input4 = Savings?.text {
                var hasDot4 = false
                for ch4 in input4.unicodeScalars {
                    if ch4 == "." {
                        hasDot4 = true
                        break
                    }
                }
                if (hasDot4 == false && Savings.layer.borderWidth > 0){
                    dotTapped3 = true
                    Savings.text = "\(input4)."
                    dotButtonStateOff()
                }
            }
        }
    }
    
    
    @IBAction func bs1(_ sender: UIButton) {
        let choppedString1 = String(Price.text!.characters.dropLast())
        if(Price.text != "Price"){
            Price.text = choppedString1
            if(Price.layer.borderWidth>0 && Price.text! == "0"){
                clearPrice = true
                Price.text = choppedString1
            }
            else if(Price.layer.borderWidth>0 && Price.text! != "0"){
                clearPrice = false
                Price.text = choppedString1
                P = Price.text!
                calculations()
            }
            else if(Price.text! != "0"){
                P = Price.text!
                calculations()
            }
            if(choppedString1 == ""){
                Price.text = "0"
                if(Price.text == "0" && Price.layer.borderWidth != 0){
                    clearPrice = true
                }
            }
            if Price.text == "0" && Price.layer.borderWidth == 0{
                miniReset()
            }
            if Price.text == "0" && Price.layer.borderWidth > 0{
                microReset()
            }
        }
        if dotTapped == true{
            
            i -= 1
            
            if i < 2{
                numericButtonStateOn()
                buttonStateDueAns()
                if Price.layer.borderWidth == 0{
                    numericButtonStateOff()
                }
            }
            if i < 0{
                dotButtonStateOn()
                dotTapped = false
                if Price.layer.borderWidth == 0{
                    dotButtonStateOff()
                }
            }
            if dotTapped == false{
                i = 0
            }
        }
    }
    @IBAction func bs2(_ sender: UIButton) {
        if sideTurned == false{
            let choppedString2 = String(PercentOff.text!.characters.dropLast())
                if(PercentOff.text != "% Off"){
                PercentOff.text = choppedString2
                if(PercentOff.layer.borderWidth>0 && PercentOff.text! == "0"){
                    clearPercentOff = true
                    PercentOff.text = choppedString2
                }
                else if(PercentOff.layer.borderWidth>0 && PercentOff.text! != "0"){
                    clearPercentOff = false
                    PercentOff.text = choppedString2
                    C = PercentOff.text!
                    calculations()
                }
                else if(PercentOff.text! != "0"){
                    C = PercentOff.text!
                    calculations()
                }
                if(choppedString2 == ""){
                    PercentOff.text = "0"
                    if(PercentOff.text == "0" && PercentOff.layer.borderWidth != 0){
                        clearPercentOff = true
                    }
                }
                if PercentOff.text == "0" && PercentOff.layer.borderWidth == 0{
                    miniReset()
                }
                if PercentOff.text == "0" && PercentOff.layer.borderWidth > 0{
                    microReset()
                }
                    
            }
            if dotTapped1 == true{
                j -= 1
                if j < 2{
                    numericButtonStateOn()
                    buttonStateDueAns()
                    if PercentOff.layer.borderWidth == 0{
                        numericButtonStateOff()
                    }
                }
                if j < 0{
                    dotButtonStateOn()
                    dotTapped1 = false
                    if PercentOff.layer.borderWidth == 0{
                        dotButtonStateOff()
                    }
                }
                if dotTapped1 == false{
                    j = 0
                }
            }
        }
        
        else{
            let choppedString2 = String(PercentOff.text!.characters.dropLast())
            if(PercentOff.text != "% Add"){
                PercentOff.text = choppedString2
                if(PercentOff.layer.borderWidth>0 && PercentOff.text! == "0"){
                    clearPercentOff = true
                    PercentOff.text = choppedString2
                }
                else if(PercentOff.layer.borderWidth>0 && PercentOff.text! != "0"){
                    clearPercentOff = false
                    PercentOff.text = choppedString2
                    C = PercentOff.text!
                    calculations()
                }
                else if(PercentOff.text! != "0"){
                    C = PercentOff.text!
                    calculations()
                }
                if(choppedString2 == ""){
                    PercentOff.text = "0"
                    if(PercentOff.text == "0" && PercentOff.layer.borderWidth != 0){
                        clearPercentOff = true
                    }
                }
                if PercentOff.text == "0" && PercentOff.layer.borderWidth == 0{
                    miniReset()
                }
                if PercentOff.text == "0" && PercentOff.layer.borderWidth > 0{
                    microReset()
                }
            }
            if dotTapped1 == true{
                j -= 1
                if j < 2{
                    numericButtonStateOn()
                    buttonStateDueAns()
                    if PercentOff.layer.borderWidth == 0{
                        numericButtonStateOff()
                    }
                }
                if j < 0{
                    dotButtonStateOn()
                    dotTapped1 = false
                    if PercentOff.layer.borderWidth == 0{
                        dotButtonStateOff()
                    }
                }
                if dotTapped1 == false{
                    j = 0
                }
            }
        }
    }
    @IBAction func bs3(_ sender: UIButton) {
        if sideTurned == false{
            let choppedString3 = String(OfferPrice.text!.characters.dropLast())
            if(OfferPrice.text != "Offer Price"){
                OfferPrice.text = choppedString3
                if(OfferPrice.layer.borderWidth>0 && OfferPrice.text! == "0"){
                    clearOfferPrice = true
                    OfferPrice.text = choppedString3
                }
                else if(OfferPrice.layer.borderWidth>0 && OfferPrice.text! != "0"){
                    clearOfferPrice = false
                    OfferPrice.text = choppedString3
                    O = OfferPrice.text!
                    calculations()
                }
                else if(OfferPrice.text! != "0"){
                    O = OfferPrice.text!
                    calculations()
                }
                if(choppedString3 == ""){
                    OfferPrice.text = "0"
                    if(OfferPrice.text == "0" && OfferPrice.layer.borderWidth != 0){
                        clearOfferPrice = true
                    }
                }
                if OfferPrice.text == "0" && OfferPrice.layer.borderWidth == 0{
                    miniReset()
                }
                if OfferPrice.text == "0" && OfferPrice.layer.borderWidth > 0{
                    microReset()
                }
            }
            if dotTapped2 == true{
                k -= 1
                if k < 2{
                    numericButtonStateOn()
                    buttonStateDueAns()
                    if OfferPrice.layer.borderWidth == 0{
                        numericButtonStateOff()
                    }
                }
                if k < 0{
                    dotButtonStateOn()
                    dotTapped2 = false
                    if OfferPrice.layer.borderWidth == 0{
                        dotButtonStateOff()
                    }
                }
                if dotTapped2 == false{
                    k = 0
                }
            }
        }
        else{
            let choppedString3 = String(OfferPrice.text!.characters.dropLast())
            if(OfferPrice.text != "Total Price"){
                OfferPrice.text = choppedString3
                if(OfferPrice.layer.borderWidth>0 && OfferPrice.text! == "0"){
                    clearOfferPrice = true
                    OfferPrice.text = choppedString3
                }
                else if(OfferPrice.layer.borderWidth>0 && OfferPrice.text! != "0"){
                    clearOfferPrice = false
                    OfferPrice.text = choppedString3
                    O = OfferPrice.text!
                    calculations()
                }
                else if(OfferPrice.text! != "0"){
                    O = OfferPrice.text!
                    calculations()
                }
                if OfferPrice.text! == ""{
                    OfferPrice.text = "0"
                }
                if(choppedString3 == ""){
                    OfferPrice.text = "0"
                    if(OfferPrice.text == "0" && OfferPrice.layer.borderWidth != 0){
                        clearOfferPrice = true
                    }
                }
                if OfferPrice.text == "0" && OfferPrice.layer.borderWidth == 0{
                    miniReset()
                }
                if OfferPrice.text == "0" && OfferPrice.layer.borderWidth > 0{
                    microReset()
                }
            }
            if dotTapped2 == true{
                
                k -= 1
                if k < 2{
                    numericButtonStateOn()
                    buttonStateDueAns()
                    if OfferPrice.layer.borderWidth == 0{
                        dotButtonStateOff()
                    }
                }
                if k < 0{
                    dotButtonStateOn()
                    dotTapped2 = false
                    if OfferPrice.layer.borderWidth == 0{
                        numericButtonStateOff()
                    }
                }
                if dotTapped2 == false{
                    k = 0
                }
            }
        }
    }
    
    @IBAction func bs4(_ sender: UIButton) {
        if sideTurned == false{
            let choppedString4 = String(Savings.text!.characters.dropLast())
            if(Savings.text != "Savings"){
                Savings.text = choppedString4
                if(Savings.layer.borderWidth>0 && Savings.text! == "0"){
                    clearSavings = true
                    Savings.text = choppedString4
                }
                else if(Savings.layer.borderWidth>0 && Savings.text! != "0"){
                    clearSavings = false
                    Savings.text = choppedString4
                    S = Savings.text!
                    calculations()
                }
                else if(Savings.text! != "0"){
                    S = Savings.text!
                    calculations()
                }
                if Savings.text! == ""{
                    Savings.text = "0"
                }
                if(choppedString4 == ""){
                    Savings.text = "0"
                    if(Savings.text == "0" && Savings.layer.borderWidth != 0){
                        clearSavings = true
                    }
                }
                if Savings.text == "0" && Savings.layer.borderWidth == 0{
                    miniReset()
                }
                if Savings.text == "0" && Savings.layer.borderWidth > 0{
                    microReset()
                }
            }
            if dotTapped3 == true{
                l -= 1
                if l < 2{
                    numericButtonStateOn()
                    buttonStateDueAns()
                    if Savings.layer.borderWidth == 0{
                        numericButtonStateOff()
                    }
                }
                if l < 0{
                    dotButtonStateOn()
                    if Savings.layer.borderWidth == 0{
                        dotButtonStateOff()
                    }
                    dotTapped3 = false
                }
                if dotTapped3 == false{
                    l = 0
                }
            }
        }
        else{
            let choppedString4 = String(Savings.text!.characters.dropLast())
            if(Savings.text != "Added"){
                Savings.text = choppedString4
                if(Savings.layer.borderWidth>0 && Savings.text! == "0"){
                    clearSavings = true
                    Savings.text = choppedString4
                }
                else if(Savings.layer.borderWidth>0 && Savings.text! != "0"){
                    clearSavings = false
                    Savings.text = choppedString4
                    S = Savings.text!
                    calculations()
                }
                else if(Savings.text! != "0"){
                    S = Savings.text!
                    calculations()
                }
                if Savings.text! == ""{
                    Savings.text = "0"
                }
                if(choppedString4 == ""){
                    Savings.text = "0"
                    if(Savings.text == "0" && Savings.layer.borderWidth != 0){
                        clearSavings = true
                    }
                }
                if Savings.text == "0" && Savings.layer.borderWidth == 0{
                    miniReset()
                }
                if Savings.text == "0" && Savings.layer.borderWidth > 0{
                    microReset()
                }
            }
            if dotTapped3 == true{
                l -= 1
                if l < 2{
                    numericButtonStateOn()
                    buttonStateDueAns()
                    if Savings.layer.borderWidth == 0{
                        numericButtonStateOff()
                    }
                }
                if l < 0{
                    dotButtonStateOn()
                    if Savings.layer.borderWidth == 0{
                        dotButtonStateOff()
                    }
                    dotTapped3 = false
                }
                if dotTapped3 == false{
                    l = 0
                }
            }
        }
    }
    
    @IBAction func resetButton(_ sender: UIButton!){
        resetFunc()
        numericButtonStateOn()
        dotButtonStateOn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
}
