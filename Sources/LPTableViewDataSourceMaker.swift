//
//  LPTableViewDataSourceMaker.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//

//#if os(iOS) || os(tvOS)
import Foundation
import UIKit
//#endif

public class LPTableViewDataSourceMaker {
    
    weak var tableView:UITableView?
    lazy var sections = [LPDataSourceSection]()
   public var scrollViewDidScrollBlock:((_ scrollView:UIScrollView) ->Void)?
   public var commitEditingBlock:((_ tableView:UITableView,_ editingStyle:UITableViewCell.EditingStyle,_ indexPath:NSIndexPath) ->Void)?
    
    
    required public init(tableView:UITableView) {
        self.tableView = tableView
    }
    
   public func makeSection(_ block:@escaping (_ section:LPTableViewSectionMaker?) ->Void) {
        let sectionMaker = LPTableViewSectionMaker()
        block(sectionMaker)
        if sectionMaker.section.cell != nil {
            self.tableView?.register(sectionMaker.section.cell!, forCellReuseIdentifier: sectionMaker.section.identifier ?? "")
        }
         self.sections.append(sectionMaker.section)
    }
    
    func height() ->(CGFloat) ->LPTableViewDataSourceMaker {
        return { height in
            self.tableView?.rowHeight = height
            return self
        }
    }
    
    func headerView() ->(UIView) ->LPTableViewDataSourceMaker {
        return { headerView in
            let headerView = UIView()
            self.tableView?.tableHeaderView?.layoutIfNeeded()
            self.tableView?.tableHeaderView = headerView
            return self
        }
    }
    
    func footerView() ->(UIView) ->LPTableViewDataSourceMaker {
        return { footerView in
             let footerView = UIView()
            self.tableView?.tableFooterView?.layoutIfNeeded()
            self.tableView?.tableFooterView = footerView
            return self
        }
    }
    
  public  func reloadIndexPath(data:[Any],indexPath:IndexPath) {
            let targetSection = sections[indexPath.section]
            UIView.performWithoutAnimation {
            tableView?.beginUpdates()
            targetSection.data?.replaceSubrange(Range(NSRange(location: indexPath.row, length: 1))!, with:data)
            tableView?.reloadRows(at: [indexPath], with: .none)
            tableView?.endUpdates()
          }
    }
    
 public func reloadSection(data:[Any],sectionAt:Int) {
             let targetSection = sections[sectionAt]
              targetSection.data = data
              UIView.performWithoutAnimation {
              tableView?.beginUpdates()
              sections.replaceSubrange(Range(NSRange(location: sectionAt, length: 1))!, with: [targetSection])
              tableView?.reloadSections(IndexSet([sectionAt]), with: .none)
              tableView?.endUpdates()
        }
  }
    
    public func reloadSection(sections:[Int]) {
                UIView.performWithoutAnimation {
                tableView?.beginUpdates()
                tableView?.reloadSections(IndexSet(sections), with: .none)
                tableView?.endUpdates()
          }
    }
    
    public func reloadRows(rows:[IndexPath]) {
            UIView.performWithoutAnimation {
                tableView?.beginUpdates()
                tableView?.reloadRows(at: rows, with: .none)
                tableView?.endUpdates()
             }
       }
    
 public func commitEditing(_ block:@escaping (_ tableview:UITableView, _ editingStyle:UITableViewCell.EditingStyle,_ indexPath:NSIndexPath) ->Void) {
        self.commitEditingBlock = block
    }
    
  public  func scrollViewDidScroll(_ block:@escaping(_ scrollView:UIScrollView) ->Void) {
        self.scrollViewDidScrollBlock = block
    }
}
