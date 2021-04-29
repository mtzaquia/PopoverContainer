# PopoverContainer

A simple `SwiftUI` view modifier to empower the usage of popovers on the iPhone.

## Usage

```swift
struct ContentView: View {
	
	...

	@State var presentingFirstPopover = false
	@State var presentingSecondPopover = false

	var body: some View {
		NavigationView {
			
			...
			
			Button(action: {
				presentingFirstPopover.toggle()
			}) {
				Text("First popover")
			}
			.popoverAnchor(named: "first")
			
			...
			
			.navigationBarItems(trailing:
			  Button(action: {
				  presentingSecondPopover.toggle()
				}) {
				  Label("Second popover", systemImage: "ellipsis")
					  .labelStyle(IconOnlyLabelStyle())
					}
					.popoverAnchor(named: "second")
			)
		}
		.popoverContainer(isPresented: $presentingFirstPopover, anchorName: "first") {
			Text("First popover is here!")
		}
		.popoverContainer(isPresented: $presentingSecondPopover, anchorName: "second") {
			Text("Second popover is here!")
		}
	}
  
  ...
  
}
```
