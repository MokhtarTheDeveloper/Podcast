//
//  DownloadsPresenter.swift
//  Podcasts
//
//  Created by Mokhtar on 11/14/18.
//  Copyright © 2018 Mokhtar. All rights reserved.
//

import Foundation

protocol DownloadPresenterDelegate : class {
    func showProgress(index : Int, progress : Double)
    func showPlayer(episode: Episode)
    func presentAlert(episode: Episode)
}

class DownloadsPresenter {
    weak var delegate : DownloadPresenterDelegate?
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    func refreshEpisodes() {
        episodes = UserDefaults.standard.downloadedEpisodes()
    }
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    @objc fileprivate func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        
        
        guard let index = self.episodes.index(where: { $0.title == episodeDownloadComplete.episodeTitle }) else { return }
        
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        
        print(progress, title)
        
        // lets find the index using title
        guard let index = self.episodes.index(where: { $0.title == title }) else { return }
        delegate?.showProgress(index: index, progress : progress)
    }
    
    typealias DownloadCellInfo = (title: String,description: String, date: String, imageURL: URL?)
    
    func setupCell(at indexPath: IndexPath) -> DownloadCellInfo {
        let title = episodes[indexPath.row].title
        let description = episodes[indexPath.row].description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.string(from: episodes[indexPath.row].pubDate)
        let url = URL(string: episodes[indexPath.row].imageUrl?.toSecureHTTPS() ?? "")
        let info = (title: title,description: description, date: date, imageURL: url)
        return info
    }
    
    func playDownloadedEpisode(at indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
            delegate?.showPlayer(episode: episode)
        if episode.fileUrl != nil {
            delegate?.showPlayer(episode: episode)
        } else {
            delegate?.presentAlert(episode: episode)
        }
    }
    
    func removeEpisode(at indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        episodes.remove(at: indexPath.row)
        UserDefaults.standard.deleteEpisode(episode: episode)
    }
}
