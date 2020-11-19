//
//  AppLifeCycleUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit
import RxSwift

class AppLifeCycleUseCase {
    typealias T = AppLifeCycleUseCase
    
    var stateController: StateController!
    
    private var disposeBag = DisposeBag()
    
    init(dependencies: Dependencies = .standard) {
        dependencies.didFinishLaunching
            .subscribe(onNext: { [unowned self] _ in self.didFinishLaunching() })
            .disposed(by: disposeBag)
        dependencies.willEnterForeground
            .subscribe(onNext: { [unowned self] _ in self.willEnterForeground() })
            .disposed(by: disposeBag)
        dependencies.didBecomeActive
            .subscribe(onNext: { [unowned self] _ in self.didBecomeActive() })
            .disposed(by: disposeBag)
        dependencies.willResignActive
            .subscribe(onNext: { [unowned self] _ in self.willResignActive() })
            .disposed(by: disposeBag)
        dependencies.didEnterBackground
            .subscribe(onNext: { [unowned self] _ in self.didEnterBackground() })
            .disposed(by: disposeBag)
        dependencies.willTerminate
            .subscribe(onNext: { [unowned self] _ in self.willTerminate() })
            .disposed(by: disposeBag)
    }
    
    private func didFinishLaunching() {
        Logger.verbose(topic: .debug, message: "didFinishLaunching")
    }

    private func willEnterForeground() {
        Logger.verbose(topic: .debug, message: "willEnterForeground")
    }

    private func didBecomeActive() {
        Logger.verbose(topic: .debug, message: "didBecomeActive")
    }

    private func willResignActive() {
        Logger.verbose(topic: .debug, message: "willResignActive")
    }

    private func didEnterBackground() {
        Logger.verbose(topic: .debug, message: "didEnterBackground")
    }

    private func willTerminate() {
        Logger.verbose(topic: .debug, message: "willTerminate")
    }

}

// MARK: - StateControllerInjector

extension AppLifeCycleUseCase : StateControllerInjector {
    @discardableResult
    func with(stateController: StateController) -> AppLifeCycleUseCase {
        self.stateController = stateController
        return self
    }
}

// MARK: - Instance Method
extension AppLifeCycleUseCase {
    static let standard: AppLifeCycleUseCase = {
        return AppLifeCycleUseCase()
    }()
}

// MARK: - Dependencies

extension AppLifeCycleUseCase {
    struct Dependencies {
        let didFinishLaunching: Observable<Void>
        let willEnterForeground: Observable<Void>
        let didBecomeActive: Observable<Void>
        let willResignActive: Observable<Void>
        let didEnterBackground: Observable<Void>
        let willTerminate: Observable<Void>

        static var standard: Dependencies {
            let notificationCenter = NotificationCenter.default.rx
            return Dependencies(
                didFinishLaunching: notificationCenter.notification(UIApplication.didFinishLaunchingNotification).map { _ in () },
                willEnterForeground: notificationCenter.notification(UIApplication.willEnterForegroundNotification).map { _ in () },
                didBecomeActive: notificationCenter.notification(UIApplication.didBecomeActiveNotification).map { _ in () },
                willResignActive: notificationCenter.notification(UIApplication.willResignActiveNotification).map { _ in () },
                didEnterBackground: notificationCenter.notification(UIApplication.didEnterBackgroundNotification).map { _ in () },
                willTerminate: notificationCenter.notification(UIApplication.willTerminateNotification).map { _ in () }
            )
        }
    }
}
