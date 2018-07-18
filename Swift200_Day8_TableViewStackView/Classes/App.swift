//
//  App.swift
//  Swift200_Day8_TableViewStackView
//
//  Created by Swift on 14/07/2018.
//  Copyright © 2018 Rodrigo Bruno. All rights reserved.
//

import UIKit
import UserNotificationsUI

class App{
    static let compartilhado = App()

    typealias Cidade = (nome:String, fundo:String, credito:String, codigo:String)
    var cidades:[Cidade] = [
        ("São Paulo", "sp", "The Photographer", "sao%20paulo,br"),
        ("Rio de Janeiro", "rj", "Rosino", "rio,br"),
        ("Brasília", "br", "Fabio Luiz", "brasilia,br"),
        ("Guarulhos", "gr", "WWF", "guarulhos,br"),
        ("Londrina", "ln", "Wilson Vieira", "londrina,br"),
    ]
    
    var usarCelsius = true
    private var favorita = "São Paulo"

    func favoritarCidade(comNome nome:String) {
		// Se o "nome" for uma das "cidade" salva em "favorita""
        // Se não aciona o fatal erro
        for cidade in cidades {
            if cidade.nome == nome {
                favorita = nome
                App.compartilhado.salvarFavorita(comNome: nome)
                return
            }
        }
        fatalError("Não encontrei na lista a cidade com este nome!")

    }

    func dadosCidadeFavorita() -> Cidade {
        // Retornar os dados da favorita
        for cidade in cidades {
            if cidade.nome == favorita {
                return cidade
            }
        }

        fatalError("Não encontrei na lista a cidade favorita")
    }
    
    // Banco de dados para persistir informações
    let ud = UserDefaults.standard
    let kFavoritaKey = "favorita"
    let kCelsiusKey = "celsius"
    
    func salvarFavorita(comNome nome:String) {
        
        // 1. Recupera a tabela salva
        var salvoFavorita:String = ud.object(forKey: kFavoritaKey) as? String ?? favorita
        
        // 2. atualiza com valor
        salvoFavorita = nome
        
        // 3. salva
        ud.set(salvoFavorita, forKey: kFavoritaKey)
    }
    
    func definirCelsius(usarCelsius celsius:Bool) {
        
        // 1. Recupera a tabela salva
        var salvoCelsius:Bool = ud.object(forKey: kCelsiusKey) as? Bool ?? true
        
        // 2. atualiza com valor
        salvoCelsius = celsius
        
        // 3. salva
        ud.set(salvoCelsius, forKey: kCelsiusKey)
    }
    
    // lendo do banco
    func recuperarFavorita() {
        let qualFavorita = ud.value(forKey: kFavoritaKey) as? String ?? favorita
        favoritarCidade(comNome:qualFavorita)
    }
    
    func recuperarCelsius() {
        let éGrausCelsius = ud.value(forKey: kCelsiusKey) as? Bool ?? usarCelsius
        usarCelsius = éGrausCelsius
    }
    
    // Configuração da badge
    var mostrandoBadge:Bool {
        get {
            return ud.bool(forKey: "mostra-badge")
        }
        
        set {
            ud.set(newValue, forKey: "mostra-badge")
            if newValue == true {
                // precisamos da autorização
                let config = UIUserNotificationSettings(types: [.badge], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(config)
            }
        }
    }
}
