# SGauge

[![CI Status](https://img.shields.io/travis/luiswdy/SGauge.svg?style=flat)](https://travis-ci.org/luiswdy/SGauge)
[![Version](https://img.shields.io/cocoapods/v/SGauge.svg?style=flat)](http://cocoapods.org/pods/SGauge)
[![License](https://img.shields.io/cocoapods/l/SGauge.svg?style=flat)](http://cocoapods.org/pods/SGauge)
[![Platform](https://img.shields.io/cocoapods/p/SGauge.svg?style=flat)](http://cocoapods.org/pods/SGauge)
![language](https://img.shields.io/badge/Language-%20Swift%20-orange.svg)

## Example

To run the example project, run `pod try SGauge`.

## Requirements

-iOS SDK **9.0** or **later**

## Installation

SGauge is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SGauge"
```

## How to use
1. Add an UIView from 'Object Library' of 'Utilities'

	<img src="https://raw.githubusercontent.com/luiswdy/SGauge/master/Images/step_1_1.png">


	<img src="https://raw.githubusercontent.com/luiswdy/SGauge/master/Images/step_1_2.png">


2. Click the view you've just added and set the both class and module of the view to 'SGauge'. You shall see the gauge then.

	<img src="https://raw.githubusercontent.com/luiswdy/SGauge/master/Images/step_2.png">


3. Customize gauge's appearance through Attribute Inspector


	<img src="https://raw.githubusercontent.com/luiswdy/SGauge/master/Images/step_2.png">


4. Declare a property of type SGauge with @IBOutlet qualifier in your view controller. For instance:
	```
	@IBOutlet var gauge: SGauge!
	```
5. To move the needle, simply assign a value to the gauge. For instance:
	```
	gauge.value = CGFloat(50)
	```

## Customizable attributes

* Max Value: The maximum value expressible for the gauge (Default: 100).
* Min Value: The minimum value expressible for the gauge (Default: 0).
* Arc Color: The color of the arc of the gauge (Default: clear).
* Arc Outline Color: The color of the outline of the arc (Default: black).
* Needle Color: The color of the gauge's needle (Default: red).
* Arc Width: The thickness of the arc (Default: 20).
* Arc Outline Width: The thickness of the arc's outline (Default: 1).
* Needle Width: The thickness of the needle (Default: 1).
* Graduation Unit: The inteval between graduation marks, denoted by value (Default: 10).
* Graduation Length: The length of graduation marks (Default: 10).
* Additional Needle Length: You may change needle length by adjusting this value (Default: 0).
* Animation Duration: The duration of needle's rotation when the gauge's value changed (Default: 0.1 sec).


## Author

Luis Wu, lunarseawu@gmail.com

## License

SGauge is available under the MIT license. See the LICENSE file for more info.
