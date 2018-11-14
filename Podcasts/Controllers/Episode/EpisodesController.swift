//
//  Podcast.swift
//  Podcasts
//
//  Created by Mokhtar on 11/14/18.
//  Copyright © 2018 Mokhtar. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController, EpisodePresneterDelegate {
    
    fileprivate let cellId = "cellId"
    var presenter : EpisodePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButtons()
        presenter.delegate = self
    }
    
    //MARK:- Setup Work
    
    fileprivate func setupNavigationBarButtons() {
        //checking if we have already saved this podcast as fav
        if presenter.hasFavorited {
            // setting up heart icon
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))
            ]
        }
    }
    
    @objc fileprivate func handleSaveFavorite() {
        presenter.favoriatePodcast()
        showBadgeHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
    }
    
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}


extension EpisodesController {
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            self.presenter.downloadEpisode(indexPath: indexPath)
        }
        return [downloadAction]
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return presenter.episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = presenter.episodes[indexPath.row]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.presenter.episodes)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.episodes.count
    }
    
    fileprivate func setupCell(cell: EpisodeCell,episode: Episode) {
        cell.titleLabel.text = episode.title
        cell.descriptionLabel.text = episode.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
        
        if let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "") {
            cell.episodeImageView.sd_setImage(with: url)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = presenter.episodes[indexPath.row]
        setupCell(cell: cell, episode: episode)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
