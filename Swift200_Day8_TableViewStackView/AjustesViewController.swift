//
//  AjustesViewController.swift
//  Swift200_Day8_TableViewStackView
//
//  Created by Swift on 14/07/2018.
//  Copyright © 2018 Rodrigo Bruno. All rights reserved.
//

import UIKit

class AjustesViewController: UIViewController {
    @IBOutlet weak var uiTabela: UITableView?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        atualizaParaFavorita()
    }
}

extension AjustesViewController : UITableViewDataSource, UITableViewDelegate {
    // 1. Quantas sections teremos
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    // 2. Quantas rows na section 'x'
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
			return App.compartilhado.cidades.count
        } else if section == 1 {
			return 2
        } else {
            print("Seção inválida")
            return 0
        }
    }

    // 3. Quantas cell utilizar no indexpath(row+section) 'X'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let celula = uiTabela?.dequeueReusableCell(withIdentifier: "CellCidade") else {
                fatalError("Não encontei a celula")
            }
            let linha = indexPath.row
            celula.textLabel?.text = App.compartilhado.cidades[linha].nome
            return celula

        } else if indexPath.section == 1 {
            guard let celula = uiTabela?.dequeueReusableCell(withIdentifier: "CellGraus") else {
                fatalError("Não encontei a celula")
            }

            if indexPath.row == 0 {
                let botão = UISwitch()
                botão.isOn = App.compartilhado.usarCelsius
                botão.addTarget(self, action: #selector(trocaCelsius(sender:)), for: .valueChanged)
                celula.accessoryView = botão
                celula.textLabel?.text = "Exibir em grau Celsius"
                //return celula
                
            } else if indexPath.row == 1 {
                let badge = UISwitch()
                badge.isOn = App.compartilhado.mostrandoBadge
                badge.addTarget(self, action: #selector(trocaBagde(sender:)), for: .valueChanged)
                celula.accessoryView = badge
                celula.textLabel?.text = "Exibir temperatura no ícone"
            
            }
            
            return celula

        } else {
            print("Indexpath inválida")
            return UITableViewCell()
        }
    }

    // 4. Título da seção
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Qual cidade deseja ver a temperatura?"
        case 1: return "Ajustes"
        default: return nil
        }
    }

    // Seleciona a cidade
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if indexPath.section == 0 {
            	cell.accessoryType = .checkmark
            	let cidade = cell.textLabel?.text ?? ""
                App.compartilhado.favoritarCidade(comNome: cidade)
            }
        }
    }

    // Deseleciona a cidade anterior
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }

    //
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return indexPath
        } else {
            return nil
        }
    }

    //
    private func atualizaParaFavorita() {
        // Qual a favotita
        let favorita = App.compartilhado.dadosCidadeFavorita().nome
        let cidades = App.compartilhado.cidades
        var indiceFavorita = 0

        for (index, cidade) in cidades.enumerated() {
            if cidade.nome == favorita {
                indiceFavorita = index
            }
        }

        let indexPath = IndexPath(row: indiceFavorita, section: 0)
        uiTabela?.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        uiTabela?.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    // Switch da escala ligado
    @objc func trocaCelsius(sender:UISwitch) {
        App.compartilhado.definirCelsius(usarCelsius: sender.isOn)
    }
    
    @objc func trocaBagde(sender:UISwitch) {
        App.compartilhado.mostrandoBadge = sender.isOn
        //App.compartilhado.definirCelsius(usarCelsius: sender.isOn)
    }
}
