# Swift Style Guide


## Background

This is the style guide for the Swift programming language. You can find more about the language in the [Swift Language Reference](https://www.swift.org/documentation/tspl/). If you are not clear about how something should be done and it's not especially mentioned here, it's general good practice to follow the style used by Apple.


## Legacy Code

There is some existing legacy code where the style is clearly a bit different. In those files the style already used there should be continued to be used. Don't reorganize or reformat those files according to this style guide. The lack of documentation around it is generally a sign, that something is legacy code.
Of course use this style guide for all new files and methods and existing files and methods, which seem to follow this style guide.


## Language

US English should be used.

```swift
let color = "red"
```


## Documentation

The code should be documented following the [DocC](https://www.swift.org/documentation/docc/) documentation format. See the next point for an example.

When they are needed, comments should be used to explain **why** a particular piece of code does something. Any comments that are used must be kept up-to-date or deleted.
Block comments should generally be avoided, as code should be as self-documenting as possible, with only the need for intermittent, few-line explanations.


## Code Organization

Order imports alphabetically. Leave one free line after the imports.

Use structures instead of classes where possible.

Use extensions for conform to protocols. Leave three free lines between the original and each extension.

Properties and methods should be private by default and only allow more access, if actually necessary.

Use up to one free line inside properties, initalizers and methods to structure the code inside there.

## Sections

Use `// MARK: ` to categorize parts in functional sections and leave one free line below it. To separate extensions use `// MARK: -` without a free line below.

Leave always three free lines between sections.
The order of the sections is always as follows:
- Properties
- Initializers
- Methods

Leave always two lines between the items in a section.

In the properties section the order is always as follows:
- Static properties
- SwiftUI environment properties (`@Environment`)
- SwiftUI binding properties (`@Binding`)
- SwiftUI state properties (`@State`)
- All other properties
Properties other than SwiftUI environment properties should always declare their type.

In the methods section the order is always as follows:
- Static methods
- All other methods


```swift
import A
import B

/// The example for the Swift Style guide
struct Example {
    // MARK: Properties
    
    /// The text needed for the example
    static let text: String = "Some text"
    
    
    /// The number needed for the example
    let number: Int = 1
    
    
    
    // MARK: Initialization
    
    /// Initalize the example with a given text
    /// - Parameter text: The text
    init(with text: String) {
        self.text = text
    }
    
    
    
    // MARK: Methods
    
    /// This adds an exclamation mark to some text
    /// - Parameter text: The text
    /// - Returns: The text with an exclamation mark at the end
    func addExclamationMark(to text: String) -> String {
        // Printing text for some manual debugging
        print(text)
        
        return text + "!"
    }
}



// MARK: - `SomeProtocol`
extension Example: SomeProtocol {
    // MARK: Methods
    
    /// Conform to some protocol
    func conform() {
        // Actually do something
    }
}
```


## Spacing

Indent using 4 spaces. Never indent with tabs.
On empty lines there should be whitespace to the indentation level on which the actual code on the lines before and after starts.
Method braces and other braces (`if`/`else`/`switch`/`while` etc.) always open on the same line as the statement but close on a new line.

```swift
if user.isHappy {
    //Do something
} else {
    //Do something else
}
```


## Naming

Long, descriptive method and variable names are good.
Variables and methods should be camel-cased. Don't use underscores.
If possible, booleans should be named in a way indicating that they are a boolean like starting with `is`, `has`, `should` etc.

```swift
var descriptionOfThing: String? = nil

var isHappy: Bool = true
```


## Brevity

Don't use semicolons. Don't use parentheses around conditionals.
Other than with properties use type inferred context where it's possible.
Only use `self.` where it is absolutely necessary.

```swift
color = .red
```


## Optionals

Use Optionals to indicate a value is missing. So for example return `nil` instead of `""` in a method, which might return a text, or `nil` instead of `0` in a method, which might return a number.


## Conditionals

Conditional bodies should always use braces even when a conditional body could be written without braces (e.g., it is one line only) to prevent errors.
Combine multiple conditions with a comma when possible.

```swift
if !isError, hasHappened {
    return success;
}
```


### Ternary Operator

The Ternary operator, `( ? : )` , should only be used when it increases clarity or code neatness. A single condition is usually all that should be evaluated. Evaluating multiple conditions is usually more understandable as an `if` statement. There might be exceptions in SwiftUI. In general, the best use of the ternary operator is during assignment of a variable and deciding which value to use.

Non-boolean variables should be compared against something, and parentheses are added for improved readability. If the variable being compared is a boolean type, then no parentheses are needed.

```swift
var result = isSmall ? 0 : 10
```


## SwiftUI

Always leave one free line between different objects.

### Modifiers

Modifiers in Swift UI should always be either at the same indentation level as the object they are attached to, if the object has a closure, or one level intended, if the object doesn't have an enclosure.
We would like the behaviour to be consistent in both cases, but the automatic formatter doesn't allow this at the moment.

There should be no free lines between modifiers.

```swift
Button {
    someAction()
} label: {
    Text("Title")
}
.font(.headline)

Text("Title")
    .font(.headline)
```

## Automatic formatting
Xcode includes an automatic formatter, which can help with adhering to most of our rules. It can be invoked in Xcode via the menubar under `Editor`/`Structure`/`Format file with 'swift-format'`.