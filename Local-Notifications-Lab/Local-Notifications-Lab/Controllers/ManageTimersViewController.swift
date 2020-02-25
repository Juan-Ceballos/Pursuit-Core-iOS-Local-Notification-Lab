//
//  ManageTimersViewController.swift
//  Local-Notifications-Lab
//
//  Created by Juan Ceballos on 2/20/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import UserNotifications

class ManageTimersViewController: UIViewController {
    
    @IBOutlet weak var notifTableView: UITableView!
    
    private var notifications = [UNNotificationRequest]()   {
        didSet  {
            DispatchQueue.main.async {
                self.notifTableView.reloadData()
            }
        }
    }
    
    private let center = UNUserNotificationCenter.current()
    
    private let pendingNotification = PendingNotification()
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifTableView.dataSource = self
        configureRefreshControl()
        loadNotifications()
    }
    
    @objc private func loadNotifications()    {
        pendingNotification.getPendingNotifications { (requests) in
            self.notifications = requests
            
            // stop the refresh control from animating and remove from the UI
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func configureRefreshControl()  {
        refreshControl = UIRefreshControl()
        notifTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
    }
    
    private func removeNotification(atIndexPath indexPath: IndexPath)   {
        // remove notification from UNNotificationCenter
        let notification = notifications[indexPath.row]
        let identifier = notification.identifier
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // remove from array of notifications
        notifications.remove(at: indexPath.row)
        
        // remove from tableView
        notifTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

extension ManageTimersViewController: UITableViewDataSource    {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.title
        cell.detailTextLabel?.text = notification.content.body
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // with just this listens for swipes
        if editingStyle == .delete  {
            // we will delete the pending notification
            removeNotification(atIndexPath: indexPath)
        }
    }
}

extension ManageTimersViewController: SetTimerNotificationDelegate  {
    func didCreateNotification(_ SetTimerNotificationDelegate: SetTimerNotificationDelegate) {
        loadNotifications()
    }
}
