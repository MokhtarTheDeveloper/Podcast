//
//  DownloadsController.swift
//  Podcasts
//
//  Created by Mokhtar on 11/14/18.
//  Copyright © 2018 Mokhtar. All rights reserved.
//

import UIKit

typealias DownloadCellInfo = (title: String,description: String, date: String, imageURL: URL?)

class DownloadsController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    var presenter : DownloadsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        setupTableView()
        presenter.setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.refreshEpisodes()
        tableView.reloadData()
    }
    
    //MARK:- Setup
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
}

extension DownloadsController : DownloadPresenterDelegate {
    func showProgress(index : Int, progress : Double) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
        cell.progressLabel.text = "\(Int(progress * 100))%"
        cell.progressLabel.isHidden = false
        
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }
    
    func showPlayer(episode: Episode) {
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: presenter.episodes)
    }
    
    func presentAlert(episode: Episode) {
        let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream url instead", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.presenter.episodes)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}

extension DownloadsController {
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.playDownloadedEpisode(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.removeEpisode(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.episodes.count
    }
    
    func setupCell(cell: EpisodeCell,info: DownloadCellInfo) {
        cell.titleLabel.text = info.title
        cell.descriptionLabel.text = info.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.pubDateLabel.text = info.date
        if let url = info.imageURL {
            cell.episodeImageView.sd_setImage(with: url)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let info = presenter.setupCell(at: indexPath)
        setupCell(cell: cell, info: info)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
