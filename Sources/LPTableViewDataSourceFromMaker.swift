//
//  UITableViewDataSourceFromMaker.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//

//#if os(iOS) || os(tvOS)
import Foundation
import UIKit
//#endif

// Mark -

extension UITableView {
    
 public var dataSourceFromMaker:LPTableViewDataSourceMaker? {
        set{
            let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "dataSourceFromMaker".hash)
            objc_setAssociatedObject(self, key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
           let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "dataSourceFromMaker".hash)
            return objc_getAssociatedObject(self, key) as? LPTableViewDataSourceMaker
        }
    }
    
    // Mark -
    
 public  func lpMakeDataSourceMaker(_ maker: @escaping(_ :LPTableViewDataSourceMaker?) ->Void) {
       let make = LPTableViewDataSourceMaker(tableView: self)
         maker(make)
        var dataSourceClass = LPBaseTableViewDataSource.self
        var delegates = [AnyHashable:Any]()
        if (make.commitEditingBlock != nil) || (make.scrollViewDidScrollBlock != nil) {
           if let utf = getIdentifierForReusable() {
            let key:UnsafePointer<Int8>! = (utf as NSString).utf8String
               dataSourceClass = objc_allocateClassPair(LPBaseTableViewDataSource.self, key, 0) as! LPBaseTableViewDataSource.Type
            }
            if make.commitEditingBlock != nil {
//  swift 与 c 通信问题,后续解决
//                let method:OpaquePointer! = OpaquePointer(bitPattern: "commitEditing".hashValue)
//                class_addMethod(dataSourceClass, NSSelectorFromString("tableView:commitEditingStyle:forRowAtIndexPath:"), method, "v@:@@@")
//               if let commitEditingBlock = make.commitEditingBlock {
//                   delegates["tableView:commitEditingStyle:forRowAtIndexPath:"] = commitEditingBlock
//               }
           }
           
           if make.scrollViewDidScrollBlock != nil {
//  swift 与 c 通信问题,后续解决
//            if let scrollViewDidScrollBlock = make.scrollViewDidScrollBlock {
//                    delegates["scrollViewDidScroll:"] = scrollViewDidScrollBlock
//            }
//            let imp = method(for: NSSelectorFromString("scrollViewDidScrollMethod(_:)"))!
//            let status =  class_addMethod(dataSourceClass, NSSelectorFromString("scrollViewDidScroll:"), imp, "v@:@")
//            if status {
//                print("== success == ")
//            }
//            else {
//                print("== failed ==")
//            }
           }
        }
        if self.tableFooterView == nil {
           self.tableFooterView = UIView()
        }
        let delegateProtocol = dataSourceClass.init()
          delegateProtocol.scrollBlock = { scrollView in
               make.scrollViewDidScrollBlock?(scrollView)
           }
        delegateProtocol.sections = (make.sections )
        delegateProtocol.delegates = delegates
        self.lpTableViewDataSource = delegateProtocol
        self.dataSourceFromMaker = make
        self.dataSource = delegateProtocol
        self.delegate = delegateProtocol
    }
    
    // Mark -
    
  public  func lpMakeSectionWithDataFromMaker(_ data:[Any],cellClass:AnyClass) {
        lpMakeDataSourceMaker { (make:LPTableViewDataSourceMaker?) in
                      make?.makeSection({ (section:LPTableViewSectionMaker?) in
                          section?.data(data)
                          section?.cell(cellClass)
                          section?.adapter({ (cell, rowObj, row,section) in
                              
                          })
                          section?.autoHeight()
                      })
                  }
    }

    // Mark -
    
  public  func reloadDataAfterMoreSections() {
        reloadData()
    }
    
   private func getIdentifierForReusable() -> String? {
        let uuidRef = CFUUIDCreate(nil)
        let uuidStrRef = CFUUIDCreateString(nil, uuidRef)
        let retStr = uuidStrRef as? String
        return retStr
    }
    
 
    
    func commitEditing(_ selfObj:Any?,_ cmd:Selector,_ tableViewSelf:UITableView?, _ editingStyle:UITableViewCell.EditingStyle,_ indexPath:NSIndexPath?) {
        let delegateProtocol:LPBaseTableViewDataSourceProtocol = (selfObj as! LPBaseTableViewDataSourceProtocol)
        let block:((_ tableview:UITableView?,_ editingStyle:UITableViewCell.EditingStyle,_ indexpath:NSIndexPath?) ->Void)? = delegateProtocol.delegates![NSStringFromSelector(cmd)] as? ((UITableView?, UITableViewCell.EditingStyle, NSIndexPath?) -> Void)
        if block != nil {
            block!(tableViewSelf,editingStyle,indexPath)
        }
    }
    

  func scrollViewDidScrollMethod(_ selfObj:Any? ,_ sel:Selector, _ scrollView:UIScrollView?) {
     let delegateProtocol:LPBaseTableViewDataSourceProtocol = (selfObj as! LPBaseTableViewDataSourceProtocol)
     let block:((_ scrollView:UIScrollView?) ->Void)? = delegateProtocol.delegates?[NSStringFromSelector(sel)] as? ((UIScrollView?) -> Void)
            if block != nil {
                   block!(scrollView)
            }
    }
}
