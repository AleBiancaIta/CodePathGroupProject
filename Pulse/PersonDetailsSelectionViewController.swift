//
//  PersonDetailsSelectionViewController.swift
//  Pulse
//
//  Created by Bianca Curutan on 11/23/16.
//  Copyright © 2016 ABI. All rights reserved.
//

import UIKit

protocol PersonDetailsSelectionViewControllerDelegate: class {
    func personDetailsSelectionViewController(personDetailsSelectionViewController: PersonDetailsSelectionViewController, didDismissSelector _: Bool)
    func personDetailsSelectionViewController(personDetailsSelectionViewController: PersonDetailsSelectionViewController, didAddCard card: Card)
    func personDetailsSelectionViewController(personDetailsSelectionViewController: PersonDetailsSelectionViewController, didRemoveCard card: Card)
}

class PersonDetailsSelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: PersonDetailsSelectionViewControllerDelegate?
    var selectedCards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manage Modules"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 5
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        tableView.register(UINib(nibName: "CustomTextCell", bundle: nil), forCellReuseIdentifier: "CustomTextCell")
    }
    
    
    @IBAction func onDismiss(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
        delegate?.personDetailsSelectionViewController(personDetailsSelectionViewController: self, didDismissSelector: true)
    }
}

// MARK: - UITableViewDataSource

extension PersonDetailsSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = Constants.personCards[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTextCell", for: indexPath) as! CustomTextCell
        cell.message = card.name
        cell.submessage = card.descr
        cell.imageName = card.imageName
        
        if selectedCards.contains(card) {
            cell.accessoryType =  .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.personCards.count
    }
}

// MARK: - UITableViewDelegate

extension PersonDetailsSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row != 0 && indexPath.row != 1 else {
            //print("Sorry, info and team cards may not be manually updated")
            //alertController.message = "Sorry, info and team cards may not be manually updated"
            //present(alertController, animated: true)
            ABIShowDropDownAlert(type: AlertTypes.alert, title: "Alert!", message: "Sorry, info and team cards may not be manually updated")
            return
        }
        
        let card = Constants.personCards[indexPath.row]
        if selectedCards.contains(card) {
            for (index, personCard) in selectedCards.enumerated() {
                // Double check to avoid index out of bounds
                if personCard.id == card.id && 0 <= index && selectedCards.count > index {
                    selectedCards.remove(at: index)
                }
            }
            delegate?.personDetailsSelectionViewController(personDetailsSelectionViewController: self, didRemoveCard: card)
        } else {
            if 0 <= indexPath.row && indexPath.row < Constants.personCards.count {
                selectedCards.append(card)
                delegate?.personDetailsSelectionViewController(personDetailsSelectionViewController: self, didAddCard: card)
            }
        }
        
        tableView.reloadData()
    }
}
