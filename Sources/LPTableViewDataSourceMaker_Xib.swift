//
//  LPTableViewDataSourceMaker_Xib.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//

//#if os(iOS) || os(tvOS)
import Foundation
import UIKit
//#endif

extension LPTableViewDataSourceMaker {
    
    func makeSectionWithXib(_ block: @escaping (_ section: LPTableViewSectionMaker) ->Void) {
        let sectionMaker = LPTableViewSectionMaker()
        block(sectionMaker)
        if sectionMaker.section.cell != nil {
            let nib = UINib(nibName: NSStringFromClass(sectionMaker.section.cell!), bundle: nil)
            self.tableView?.register(nib, forCellReuseIdentifier: sectionMaker.section.identifier ?? "")
        }
        self.sections.append(sectionMaker.section)
    }
    
}
