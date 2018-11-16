//
//  DrawBoardViewController.swift
//  Drawing
//
//  Created by user04 on 2018/8/10.
//  Copyright © 2018年 jerryHU. All rights reserved.
//

import UIKit

class DrawBoardViewController: UIViewController{
    @IBOutlet weak var canvas: Canvas!
    @IBOutlet weak var saveBtnSelect: UIButton!
    @IBOutlet weak var penColor: UIView!
    @IBOutlet weak var changeFontSize: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //不會畫出了畫板的範圍
        canvas.clipsToBounds = true
        //關閉多點觸控
        canvas.isMultipleTouchEnabled = false
        canvas.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    @IBAction func penColorChange(_ sender: UIButton) {
        if(changeFontSize.isHidden == false){
            changeFontSize.isHidden = true
        }
        penColor.isHidden = !penColor.isHidden
    }
    
    @IBAction func changeColorAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            canvas.lineColor = UIColor.red
        case 2:
            canvas.lineColor = UIColor.orange
        case 3:
            canvas.lineColor = UIColor.yellow
        case 4:
            canvas.lineColor = UIColor.green
        case 5:
            canvas.lineColor = UIColor.blue
        case 6:
            canvas.lineColor = UIColor.gray
        case 7:
            canvas.lineColor = UIColor.black
        default:
            canvas.lineColor = UIColor.black
        }
        penColor.isHidden = !penColor.isHidden
    }
    
    @IBAction func penFontChange(_ sender: UIButton) {
        if(penColor.isHidden == false){
            penColor.isHidden = true
        }
        changeFontSize.isHidden = !changeFontSize.isHidden
    }
    
    @IBAction func changeSize(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            canvas.lineWidth = 1
        case 2:
            canvas.lineWidth = 2
        case 3:
            canvas.lineWidth = 3
        case 4:
            canvas.lineWidth = 4
        case 5:
            canvas.lineWidth = 5
        case 6:
            canvas.lineWidth = 6
        case 7:
            canvas.lineWidth = 7
        case 8:
            canvas.lineWidth = 8
        case 9:
            canvas.lineWidth = 9
        default:
            canvas.lineWidth = 9
        }
        changeFontSize.isHidden = !changeFontSize.isHidden
    }
    
    @IBAction func returnBtn(_ sender: UIButton) {
        canvas.undo()
    }
    
    @IBAction func cleanBtn(_ sender: UIButton) {
        canvas.clearCanvas()
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        let image = self.canvas.asImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "储存错误", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "", message: "已储存", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        self.canvas.backgroundColor = UIColor.clear
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
