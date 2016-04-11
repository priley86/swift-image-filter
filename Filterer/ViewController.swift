//
//  ViewController.swift
//  Filterer
//
//  Created by Patrick Riley on 2016-01-17.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedFilter = ""
    
    @IBOutlet weak var filteredImage: UIImageView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filteredImageView: UIView!
    
    @IBOutlet var factorView: UIView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var slider: UISlider!

    @IBOutlet var brightnessButton: UIButton!
    @IBOutlet var contrastButton: UIButton!
    @IBOutlet var grayscaleButton: UIButton!
    @IBOutlet var sepiaButton: UIButton!
    
    let imageProcessor = ImageProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        factorView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        factorView.translatesAutoresizingMaskIntoConstraints = false
        filteredImageView.backgroundColor = UIColor.blackColor()
        filteredImageView.translatesAutoresizingMaskIntoConstraints = false
        compareButton.enabled = false
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func compareBtnDown(sender: AnyObject) {
        showFilteredImage()
    }
    @IBAction func compareBtnUp(sender: AnyObject) {
        hideFilteredImage()
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        let sliderValue = Int(sender.value)
        var settings: [(filter: String, factor: Int)]
        settings = []
        
        switch(selectedFilter){
            case "Brightness":
                switch(sliderValue){
                    case 0:
                        settings = [(filter: selectedFilter, factor: -80)]
                        break;
                    case 1:
                        settings = [(filter: selectedFilter, factor: -60)]
                        break;
                    case 2:
                        settings = [(filter: selectedFilter, factor: -40)]
                        break;
                    case 3:
                        settings = [(filter: selectedFilter, factor: -20)]
                        break;
                    case 4:
                        settings = [(filter: selectedFilter, factor: 20)]
                        break;
                    case 5:
                        settings = [(filter: selectedFilter, factor: 40)]
                        break;
                    default:
                        return;
                }
                break;
            case "Grayscale","Sepia","Contrast":
                settings = [(filter: selectedFilter, factor: (sliderValue + 1))]
                break;
            default:
                return;
            
        }
        setFilterImage(settings)
    }
    
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            hideSliderView()
            editButton.selected = false
            
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    @IBAction func onEdit(sender: UIButton) {
        if (sender.selected) {
            hideSliderView()
            sender.selected = false
        } else {
            hideSecondaryMenu()
            filterButton.selected = false
            
            showSliderView()
            sender.selected = true
        }
    }
    
    @IBAction func onBrightnessFilter(sender: UIButton) {
        if (sender.selected) {
            resetFilter()
            deselectFilterButton(brightnessButton)
        } else {
            selectFilter("Brightness")
        }
    }
    
    @IBAction func onContrastFilter(sender: UIButton) {
        if (sender.selected) {
            resetFilter()
            deselectFilterButton(contrastButton)
        } else {
            selectFilter("Contrast")
        }
    }
    
    @IBAction func onGrayscaleFilter(sender: UIButton) {
        if (sender.selected) {
            resetFilter()
            deselectFilterButton(grayscaleButton)
        } else {
            selectFilter("Grayscale")
        }
    }
    
    @IBAction func onSepiaFilter(sender: UIButton) {
        if (sender.selected) {
            resetFilter()
            deselectFilterButton(sepiaButton)
        } else {
            selectFilter("Sepia")
        }
    }
    
    func selectFilter (selected: String){
        selectedFilter = selected
        var settings: [(filter: String, factor: Int)]
        settings = []
        
        switch(selected){
            case "Brightness":
                settings = [(filter: "Brightness", factor: -20)]
                selectFilterButton(brightnessButton)
                deselectFilterButton(contrastButton)
                deselectFilterButton(grayscaleButton)
                deselectFilterButton(sepiaButton)
                break;
            case "Contrast":
                settings = [(filter: "Contrast", factor: 4)]
                selectFilterButton(contrastButton)
                deselectFilterButton(brightnessButton)
                deselectFilterButton(grayscaleButton)
                deselectFilterButton(sepiaButton)
                break;
            case "Grayscale":
                settings = [(filter: "Grayscale", factor: 4)]
                selectFilterButton(grayscaleButton)
                deselectFilterButton(brightnessButton)
                deselectFilterButton(contrastButton)
                deselectFilterButton(sepiaButton)
                break;
            case "Sepia":
                settings = [(filter: "Sepia", factor: 4)]
                selectFilterButton(sepiaButton)
                deselectFilterButton(brightnessButton)
                deselectFilterButton(grayscaleButton)
                deselectFilterButton(contrastButton)
                break;
            default:
                break;
        }
        setFilterImage(settings)
        compareButton.enabled = true
    }
    
    func setFilterImage(settings: [(filter: String, factor: Int)]){
        let singleFilterImage = RGBAImage(image: filteredImage.image!)
        let singleFiltered = imageProcessor.applyFilters(singleFilterImage!, filterSettings: settings)
        
        imageView.image = singleFiltered.toUIImage()!
    }
    
    func resetFilter(){
        imageView.image = filteredImage.image
        selectedFilter = ""
        compareButton.enabled = false
    }
    
    func deselectFilterButton(btn: UIButton){
        btn.backgroundColor = UIColor.blackColor()
        btn.selected = false
    }
    func selectFilterButton(btn: UIButton){
        btn.selected = true
        btn.backgroundColor = UIColor.darkGrayColor()
    }
    
    func showSliderView() {
        view.addSubview(factorView)
        
        let bottomConstraint = factorView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = factorView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = factorView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = factorView.heightAnchor.constraintEqualToConstant(59)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.factorView.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.factorView.alpha = 1.0
        }
    }
    
    func hideSliderView() {
        UIView.animateWithDuration(0.4, animations: {
            self.factorView.alpha = 0
            }) { completed in
                if completed == true {
                    self.factorView.removeFromSuperview()
                }
        }
    }
    
    func hideFilteredImage(){
        UIView.animateWithDuration(0.4, animations: {
            self.filteredImageView.alpha = 0
            }) { completed in
                if completed == true {
                    self.filteredImageView.removeFromSuperview()
                }
        }
    }
    
    func showFilteredImage(){
        view.insertSubview(filteredImageView, belowSubview:secondaryMenu)
        
        let bottomConstraint = filteredImageView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = filteredImageView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = filteredImageView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let topConstraint = filteredImageView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, topConstraint])
        
        view.layoutIfNeeded()
        
        self.filteredImageView.alpha = 0.0
        UIView.animateWithDuration(0.4) {
            self.filteredImageView.alpha = 1.0
        }
    }
    
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(59)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

}

