# AnglePicker (WIP)

An angle picker implementation with circle slider appearance written in plain SwiftUI.

Strongly inspired by ColorPicker - https://github.com/hendriku/ColorPicker - by Hendrik Ulbrich

## Usage

Add this repository as a Swift Package Dependency to your project. You find the option in Xcode unter "File > Swift Packages > Add Package Dependency...". Paste the HTTPS reference to this repo and you're done!

After importing the module: Simply use the `AnglePicker` structure which is a regular SwiftUI `View`.

```
import SwiftUI
import AnglePicker

struct ContentView : View {

    @State var angle: Double = 0.0

    var body: some View {
        VStack {
            Text("Angle: \(angle))")
            AnglePicker(angle: $angle, startFrom: 90)
                .frame(width: 100, height: 100, alignment: .center)
        }
    }

}

```

The circle slider will take all the space it can get unless you frame it to a custom size. You are also able to specify the `startFrom` angle to subtract.

## License

You can use this software under the terms and conditions of the MIT License.

Jacopo Mangiavacchi © 2019
