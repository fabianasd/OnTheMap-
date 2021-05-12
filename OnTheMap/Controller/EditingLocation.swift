//
//  EditingLocation.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 02/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//
//
import UIKit

class EditingLocation: UIViewController {
    
    /*
     
     para fazer o planejamento tecnico vou precisar:
     
     cancelar alteracao e retornar para a tela anterior
     digitar a localizacao
     chamar a funcao de procurar no mapa
     
     */
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var findMap: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.text = "Enter Your Location Here"
    }
    
    @IBAction func locationTextField(_ sender: UITextField) {
        sender.text = ""
    }
    
    
    @IBAction func findMap(_ sender: UIButton) {
        // salvar a localizacao informada no locationTextField para pesquisar na  tela SearchLocation
        print("findMap")
        OTMUser.postStudentLocation() { studentResponse, error in
            //    MapModel.maplist = GetUserResponse
            self.performSegue(withIdentifier: "search", sender: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        print("cancel")
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
