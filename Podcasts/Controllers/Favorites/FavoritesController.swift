//
//  FavoritesController.swift
//  Podcasts
//
//  Created by Mokhtar on 11/14/18.
//  Copyright © 2018 Mokhtar. All rights reserved.
//

import UIKit

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var presenter : FavoritesPresenter!
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        
        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else { return }
        
        let alertController = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.presenter.deletFaviorte(selectedIndexPath: selectedIndexPath)
            self.collectionView?.deleteItems(at: [selectedIndexPath])

        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
}


extension FavoritesController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        let episodesPresenter = EpisodePresenter()
        episodesPresenter.podcast = self.presenter.getPodcasts()[indexPath.item]
        episodesController.presenter = episodesPresenter
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getPodcasts().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritePodcastCell
        
        let podcast = self.presenter.getPodcasts()[indexPath.item]
        
        cell.nameLabel.text = podcast.trackName
        cell.artistNameLabel.text = podcast.artistName
        
        if let url = URL(string: podcast.artworkUrl600 ?? "") {
            cell.imageView.sd_setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
