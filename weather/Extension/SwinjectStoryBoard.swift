//
//  SwinjectStoryBoard.swift
//  weather
//
//  Created by Vlad Rakovich on 19.09.2022.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
   @objc class func setup() {
     defaultContainer.autoregister(Networking.self, initializer: Request.init)
       defaultContainer.storyboardInitCompleted(MainViewController.self) { resolver, controller in
         controller.req = resolver ~> Networking.self
       }

   }
}
