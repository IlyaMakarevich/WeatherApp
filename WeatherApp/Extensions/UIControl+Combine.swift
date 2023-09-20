//
//  UIControl+Combine.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import UIKit
import Combine

extension UIControl {
    final class EventSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
        private var subscriber: SubscriberType?
        private let control: Control
        private let event: UIControl.Event

        init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            control.removeTarget(self, action: #selector(eventHandler), for: event)
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(control)
        }
    }

    struct EventPublisher<Control: UIControl>: Publisher {
        public typealias Output = Control
        public typealias Failure = Never

        let control: Control
        let controlEvents: UIControl.Event

        init(control: Control, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
        }

        public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = EventSubscription(subscriber: subscriber, control: control, event: controlEvents)
            subscriber.receive(subscription: subscription)
        }
    }
}

public protocol CombineCompatible { }

extension UIControl: CombineCompatible { }
public extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> AnyPublisher<Self, Never> {
        UIControl.EventPublisher(control: self, events: events).eraseToAnyPublisher()
    }
}

public extension UIControl {
    func tapPublisher() -> AnyPublisher<Void, Never> {
        publisher(for: .touchUpInside)
            .throttle(for: .milliseconds(100),
                      scheduler: DispatchQueue.main,
                      latest: false)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
}
