//
//  TempoViewController.swift
//  Swift200_Day8_TableViewStackView
//
//  Created by Swift on 14/07/2018.
//  Copyright © 2018 Rodrigo Bruno. All rights reserved.
//

import UIKit

class TempoViewController: UIViewController {
    @IBOutlet weak var uiIcone: UILabel?
    @IBOutlet weak var uiTemperatura: UILabel?
    @IBOutlet weak var uiCidade: UILabel?
    @IBOutlet weak var uiImagemFundo: UIImageView?
    @IBOutlet weak var uiCredito: UILabel?
    @IBOutlet weak var uiSpinner: UIActivityIndicatorView?
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        atualizaAtual()
        
        let dados = App.compartilhado.dadosCidadeFavorita()
        uiCidade?.text = dados.nome
        uiImagemFundo?.image = UIImage(named: dados.fundo)
        uiCredito?.text = dados.credito

		uiTemperatura?.text = " "
        uiIcone?.text = " "

        uiSpinner?.startAnimating()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let favorita = App.compartilhado.dadosCidadeFavorita()
        guard let dados = forecast(forCity: favorita.codigo) else {
            return
        }

        uiIcone?.text = dados.icon
        uiImagemFundo?.image = UIImage(named: favorita.fundo)
        
        var temperaturaAtual = 0
        
        if App.compartilhado.usarCelsius {
            uiTemperatura?.text = "\(dados.temp)ºC"
            temperaturaAtual = dados.temp
        } else {
            let fahrenheit = Int((Double(dados.temp) * 1.8) + 32)
            uiTemperatura?.text = "\(fahrenheit)ºF"
            temperaturaAtual = fahrenheit
        }
        
        if App.compartilhado.mostrandoBadge {
            UIApplication.shared.applicationIconBadgeNumber = temperaturaAtual
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }

        uiSpinner?.stopAnimating()
    }
    
    func atualizaAtual() {
        App.compartilhado.recuperarFavorita()
        App.compartilhado.recuperarCelsius()
    }

}
