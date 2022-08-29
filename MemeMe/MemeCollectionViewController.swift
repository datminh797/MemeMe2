//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by minhdat on 20/08/2022.
//

import UIKit
import Foundation

class MemeCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
        self.navigationItem.title = "Meme Collection View"
        
        self.collectionView.register(UINib(nibName: "MemeCollectionViewCell", bundle: Bundle(for: MemeCollectionViewCell.self)), forCellWithReuseIdentifier: MemeCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    @objc func addMeme() {
        guard let inforVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "EditMemeViewController") as? EditMemeViewController else {
            return
        }
        inforVC.delegate = self
        let navi = UINavigationController(rootViewController: inforVC)
        self.present(navi, animated: true)
    }
}

extension MemeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeService.object.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell: MemeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.reuseIdentifier, for: indexPath)
            as? MemeCollectionViewCell else { return UICollectionViewCell() }
        let meme = MemeService.object.memes[indexPath.row]
        cell.iconImage.image = meme.memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let meme = MemeService.object.memes[indexPath.row]
        let itemWidth = self.view.frame.size.width / 2 - 14
        let ratio: CGFloat = (meme.memedImage?.size.height ?? 300) / (meme.memedImage?.size.width ?? 300)
        return CGSize(width: itemWidth, height: itemWidth * ratio)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController else {
            return
        }
        detailController.meme = MemeService.object.memes[indexPath.row]
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
    }
}

extension MemeCollectionViewController: EditMemeViewControllerDelegate {
    func reloadData() {
        self.collectionView.reloadData()
    }
}
