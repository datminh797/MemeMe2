//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by minhdat on 20/08/2022.
//

import UIKit
import Foundation

class MemeTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
        self.navigationItem.title = "Meme"
        let nib = UINib(nibName: "MemeTableViewCell", bundle: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: MemeTableViewCell.reuseIdentifier)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func addMeme() {
        guard let infoViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "EditMemeViewController") as? EditMemeViewController else {
            return
        }
        infoViewController.delegate = self
        let navi = UINavigationController(rootViewController: infoViewController)
        self.present(navi, animated: true)
    }
}

extension MemeTableViewController: EditMemeViewControllerDelegate {
    func reloadData() {
        self.tableView.reloadData()
    }
}

// MARK: Table View Data Source
extension MemeTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeService.object.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemeTableViewCell.reuseIdentifier, for: indexPath) as? MemeTableViewCell else { return UITableViewCell() }

        let meme = MemeService.object.memes[indexPath.row]
        cell.topLabel.text = meme.topTextField
        cell.bottomLabel.text = meme.botTextField
        cell.iconImage?.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController else {
            return
        }
        detailController.meme = MemeService.object.memes[indexPath.row]
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
