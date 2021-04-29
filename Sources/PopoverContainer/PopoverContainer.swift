//
//  PopoverContainer.swift
//  PopoverContainer
//
//  Copyright © 2021 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the &quot;Software&quot;), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

struct PopoverAnchorNameKey: PreferenceKey {
	static var defaultValue: [String: UIView] = [:]
	static func reduce(value: inout [String: UIView], nextValue: () -> [String: UIView]) {
		value = value.merging(nextValue()) { $1 }
	}
}

struct PopoverContainerModifier<Popover>: ViewModifier where Popover: View {
	@State var anchors = [String: UIView]()
	@Binding var isPresented: Bool
	let anchorName: String
	let popoverContent: () -> Popover

	func body(content: Content) -> some View {
		content
			.onPreferenceChange(PopoverAnchorNameKey.self) { anchors = $0 }
			.background(background)
	}

	@ViewBuilder
	var background: some View {
		if isPresented {
			SwiftUI.Color.clear.onAppear {
				if let view = anchors[anchorName],
				   let presenting = view.nearestViewController
				{
					let presented = PopoverHostingController(rootView: popoverContent())
					presented.modalPresentationStyle = .popover
					presented.popoverPresentationController?.delegate = presented
					presented.isPresented = $isPresented

					let convertedFrame = presenting.view.convert(view.frame, from: view)

					presented.popoverPresentationController?.sourceView = presenting.view
					presented.popoverPresentationController?.sourceRect = convertedFrame

					presenting.present(presented, animated: true)
				}
			}
		}
	}
}

public extension View {
	/// **[PopoverContainer]** Declares an anchor to be used as a guide for presenting a popover.
	/// - Parameter name: The name of the anchor for the popover to originate from.
	func popoverAnchor(named name: String) -> some View {
		AnchorView { anchor in
			self.preference(key: PopoverAnchorNameKey.self, value: [name: anchor.uiView])
		}
	}

	/// **[PopoverContainer]** Use this modifier to attach a popover presentation to a `View`, originating from a given, previously declared anchor with `.popoverAnchor(named:)`
	/// - Parameters:
	///   - isPresented: A binding to the presentation. The popover will automatically reset this flag when dismissed.
	///   - anchorName: The name linking this popover to a previously-specified anchor in the hierarchy.
	///   - content: The content to be displayed inside the popover.
	func popoverContainer<Content>(isPresented: Binding<Bool>,
								   anchorName: String,
								   content: @escaping () -> Content) -> some View where Content: View
	{
		modifier(PopoverContainerModifier(isPresented: isPresented, anchorName: anchorName, popoverContent: content))
	}
}
