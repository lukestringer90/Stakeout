//
//  ListSelectionViewController.swift
//  Stakeout
//
//  Created by Luke Stringer on 31/03/2018.
//  Copyright © 2018 Luke Stringer. All rights reserved.
//

import UIKit
import Swifter

class ListSelectionViewController: UITableViewController {
    
    var selectedListStore: SelectedListStore? = SelectedListStore.shared
    var isSelectingInitialList = false
    
    var lists: [List]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLists(for: Constants.Twitter.lukestringer90)
        
        if isSelectingInitialList {
            navigationItem.leftBarButtonItem = nil
            if #available(iOS 13.0, *) {
                isModalInPresentation = true
            }
        }
    }
}

// MARK: Twitter
extension ListSelectionViewController {
    
    func getLists(for user: UserTag) {
        Swifter.shared().getSubscribedLists(reverse: false, success: { json in
            self.lists = json.array?.compactMap { object -> List? in
                guard
                    let id = object["id"].integer,
                    let slug = object["slug"].string,
                    let name = object["name"].string,
                    let ownerScreenName = object["user"].object?["screen_name"]?.string
                    else { return nil }
                return List(id: id, slug: slug, name: name, ownerScreenName: ownerScreenName)
            }
            self.tableView.reloadSections([0], with: .automatic)
        }) { error in
            print(error)
        }
    }
}

// MARK: UITableViewController
extension ListSelectionViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lists = lists else { return 0 }
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell"),
            let list = lists?[indexPath.row]
            else {
                fatalError("Cannot setup list cell")
        }
        cell.textLabel?.text = list.name
        if let storedList = selectedListStore?.list {
            cell.accessoryType = list == storedList ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selected = lists?[indexPath.row] else { return }
        
        let previous = selectedListStore?.list
        
        selectedListStore?.replace(with: selected)
        
        if let previousSelected = previous, let index = lists?.index(of: previousSelected) {
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        if isSelectingInitialList {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
