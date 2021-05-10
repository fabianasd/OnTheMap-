//
//  SearchLocationController.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 09/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

class SearchLocationController: UIViewController {
    /*
     ao cancelar deve voltar para tela anterior editingLocation (confirmar tela)
     informar link do linkedin no textField
     mostrar um preview no map (confirmar)
     ao clicar em submit cadastrar o link junto com nome e localizacao
     */
    @IBOutlet weak var linkLinkedin: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkLinkedin.text = "Enter a Link to Share Here"
    }
    
    @IBAction func linkLinkedinTextField(_ sender: UITextField) {
        sender.text = ""
    }
    
    
    @IBAction func submit(_ sender: Any) {
        //deve salvar no MapModel o link do linkedin, juntamente com a localizacao e nome do usuario
        //retornar as informacoes no mapViewControllerList
    }
    
    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

