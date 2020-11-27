//
//  LPDataSourceSection.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//

//#if os(iOS) || os(tvOS)
import Foundation
import UIKit
//#endif

open class LPDataSourceSection {
    
    var data:[Any]?
    var cell:AnyClass?
    var identifier:String?
    var adapter:AdapterBlock?
    var event:EventBlock?
    var headerTitle:String?
    var footerTitle:String?
    var headerView:UIView?
    var footerView:UIView?
    var isAutoHeight:Bool = false
    var staticHeight:CGFloat = 0.0
    var tableViewCellStyle:UITableViewCell.CellStyle = UITableViewCell.CellStyle.default
    
    // 根据模型高度
    var autoModelHeight:Bool = false
    // 缓存模型高度
    var cacheModelHeight:Bool = true
    
    init() {
        
    }
    
}

