//
//  MenuViewController.swift
//  FlipSideMenu
//
//  Created by ZachZhang on 16/6/26.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menu(menu: MenuViewController, didSelectItemAtIndex index: Int)
    func menuDidCancel(menu: MenuViewController)
}

class MenuViewController: UITableViewController {
    weak var delegate : MenuViewControllerDelegate?
    
    var selectedItem = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = NSIndexPath(forRow: selectedItem, inSection: 0)
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        
    }
}

extension MenuViewController {
    @IBAction func dismissMenu(sender: UIButton) {
        delegate?.menuDidCancel(self)
    }
}

// MARK: Menu Protocol

extension MenuViewController : Menu {
    var menuItems : [UIView] {
        return [tableView.tableHeaderView!] + tableView.visibleCells
    }
}


// MARK: - UITableView Delegate

extension MenuViewController {
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath == tableView.indexPathForSelectedRow ? nil : indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.menu(self, didSelectItemAtIndex: indexPath.row)
    }
}
