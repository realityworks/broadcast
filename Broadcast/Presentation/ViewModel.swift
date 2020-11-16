//
//  ViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation

protocol ViewModelleable {
    associatedtype Cancellable : Hashable
    
    var cancellables: Set<Cancellable> { get set }
}

/// Protocol extension for the base class
class ViewModel : ViewModelleable {
    
}
