/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Base class for any UITableViewController that is the master of the split view controller for
 adaptability between regular and compact mode.
*/

import UIKit

class BaseTableViewController: UITableViewController {
	var savedSelectionIndexPath: IndexPath?
	private var detailTargetChange: NSObjectProtocol!
	
	// MARK: - View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.delegate = self  // So we can listen when we come and go on the nav stack.
		
		detailTargetChange = NotificationCenter.default.addObserver(
			forName: UIViewController.showDetailTargetDidChangeNotification,
			object: nil,
			queue: OperationQueue.main) { [weak self] (_) in
				// Whenever the target for showDetailViewController changes, update all of our cells
				// to ensure they have the right accessory type.
				//
                guard let self = self else { return }
                
                for cell in self.tableView.visibleCells {
					let indexPath = self.tableView.indexPath(for: cell)
					self.tableView.delegate?.tableView!(self.tableView, willDisplay: cell, forRowAt: indexPath!)
				}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	// MARK: Utility functions
	
	func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
		// For subclasses to override.
	}
	
 	func isTwoLevelCell(indexPath: IndexPath) -> Bool {
		// For subclasses to override.
		return false
	}
	
	func splitViewWantsToShowDetail() -> Bool {
		return splitViewController?.traitCollection.horizontalSizeClass == .regular
	}
	
	func pushOrPresentViewController(viewController: UIViewController, cellIndexPath: IndexPath) {
		if splitViewWantsToShowDetail() {
			if isTwoLevelCell(indexPath: cellIndexPath) {
				navigationController?.pushViewController(viewController, animated: true) // Just push instead of replace.
				tableView.deselectRow(at: cellIndexPath, animated: false)
			} else {
				let navVC = UINavigationController(rootViewController: viewController)
				splitViewController?.showDetailViewController(navVC, sender: navVC)	// Replace the detail view controller.
			}
		} else {
			navigationController?.pushViewController(viewController, animated: true) // Just push instead of replace.
		}
	}
	
	func pushOrPresentStoryboard(storyboardName: String, cellIndexPath: IndexPath) {
		let exampleStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
		if let exampleViewController = exampleStoryboard.instantiateInitialViewController() {
			pushOrPresentViewController(viewController: exampleViewController, cellIndexPath: cellIndexPath)
		}
	}

}

// MARK: - UITableViewDelegate

extension BaseTableViewController {
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if splitViewWantsToShowDetail() {
			cell.accessoryType = .none
			if self.savedSelectionIndexPath != nil {
				self.tableView.selectRow(at: savedSelectionIndexPath, animated: true, scrollPosition: .none)
			}
		} else {
			cell.accessoryType = .disclosureIndicator
			tableView.deselectRow(at: indexPath, animated: false)
		}
		
		configureCell(cell: cell, indexPath: indexPath as IndexPath)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		savedSelectionIndexPath = indexPath
	}
	
}

// MARK: - UINavigationControllerDelegate

extension BaseTableViewController: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		if viewController == self {
			// We re-appeared on the nav stack (likely because we manually popped) so our saved selection should be cleared.
			savedSelectionIndexPath = nil
		}
	}
	
}
