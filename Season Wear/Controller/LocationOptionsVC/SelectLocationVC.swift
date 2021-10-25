//
//  SelectLocationVC.swift
//  Season Wear
//
//  Created by Innovative on 25/01/21.
//  Copyright © 2021 innovativeiteration. All rights reserved.
//

import UIKit

class SelectLocationVC: UIViewController {

    @IBOutlet weak var viewSelectLocationContainer: UIView!
    @IBOutlet weak var viewEnterLocationContainer: UIView!
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        self.viewSelectLocationContainer.layer.cornerRadius = 10.0
        self.viewSelectLocationContainer.layer.borderWidth = 2.0
        self.viewSelectLocationContainer.layer.borderColor = UIColor.black.cgColor
        
        self.viewEnterLocationContainer.layer.cornerRadius = 10.0
        self.viewEnterLocationContainer.layer.borderWidth = 2.0
        self.viewEnterLocationContainer.layer.borderColor = UIColor.black.cgColor        
    }
    
    //MARK:- IBActions
    @IBAction func btnCurrentLocationTapped(_ sender: Any) {
        let vc = HomeViewController()
        vc.isFromSelectLocationVC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEnterLocationTapped(_ sender: Any) {
        let vc = SearchAddressViewController()
        vc.isFromHome = false
        //MySingleton.sharedManager()!.boolIsWebServiceCalledOnce = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
