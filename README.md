# SwiftFoundationHelpers

A Swift package that includes an integrated collection of Swift Foundation extensions and related
custom abstractions.

## Overview

SwiftFoundationHelpers is a Swift package designed to complement Swift Foundation, Apple’s native
framework for building Swift apps and packages.  It simplifies everyday coding tasks by extending
key Foundation types such as String, Date, Array, and more.

This package focuses on providing practical, reusable extensions and abstractions that:

* Simplify common patterns in Swift Foundation.
* Extend Swift Foundation’s capabilities without overriding or replacing its native functionality.

By integrating SwiftFoundationHelpers into your project, you can reduce boilerplate code, improve
readability, and adopt reusable patterns tailored for modern Swift apps and packages.

## Features

🔧 **Extensions**

Enhance your Foundation types with powerful, reusable extensions.

* `Array`
  * `.removingDuplicates()`: Removes duplicate elements from the array while preserving the original
    order.
* `Date`
  * Computed variables
    * `.dayOfWeek`: Returns the day of the week for the date as an integer.
  * Methods
    * `.addingDays(_)`: Returns a new date by adding the specified number of days to the current date.
    * `.addingMonths(_)`: Returns a new date by adding the specified number of months to the current
      date.
    * `.addingSeconds(_)`: Returns a new date by adding the specified number of seconds to the
      current date.
    * `.isSameDay(as)`: Checks if two dates fall on the same calendar day.
    * `.formatted(_)`: Formats the date into a string using the specified format.
* `String`
  * Constants
    * `.dash`: A constant for a dash character.
    * `.empty`: A constant for an empty string.
    * `.newline`: A constant for a newline character.
    * `.space`: A constant for a single space character.
  * Computed variables
    * `.isEmptyOrWhitespace`: Checks if the string is empty or contains only whitespace characters.
    * `.isNumeric`: Checks if the string contains only numeric characters.
    * `.isNumeric`: Checks if the string contains only numeric characters.
    * `.isValidEmail`: Validates whether the string is a properly formatted email address.
    * `.isValidPassword`: Validates whether the string is a strong password.
    * `.isValidPhone`: Validates whether the string is a valid phone number.
    * `.reversedWords`: Reverses the order of words in the string.
    * `.trimmed`: Trims leading and trailing whitespace and newline characters from the string.
  * Methods
    * `.contains(_)`: Checks if the string contains the specified substring.
    * `.matches(regex)`: Checks if the string matches a given regular expression pattern.
* `URL`
  * `.addingQueryParameters()`: Adds or updates query parameters to the URL.
  * `.queryParameter(for)`: Retrieves the value of a query parameter from the URL.

## Installation

### Using Swift Package Manager (SPM)

To integrate SwiftFoundationHelpers into your project:

1. Open your project in **Xcode**.
2. Navigate to **File > Add Packages**.
3. Enter the URL for this repository:

   <https://github.com/yourusername/SwiftFoundationHelpers>

4. Select the latest version and add it to your target.

## Documentation

For detailed API documentation and more usage examples, visit the SwiftFoundHelpers documentation
section (pending).  For project documentation, refer to the files listed in the subsections that
follow.

### Community Health

* [Code of Conduct](CODE_OF_CONDUCT.md)
* [Contributing](CONTRIBUTING.md)

### Project

* [References](REFERENCES.md)

## Contributing

Contributions are welcome!  If you’d like to add a new feature, fix a bug, or improve the
documentation:

1. Fork this repository.
2. Create a new feature branch for your changes (`git checkout -b feature/feature-name`).
3. Commit your changes (`git commit -m "Add feature"`).
4. Push to your branch (`git push origin feature-name`).
5. Submit a pull request with a detailed description.

## License

SwiftFoundationHelpers is available under under the [MIT License](LICENSE).

## Acknowledgments

SwiftFoundationHelpers is inspired by common patterns in Swift development, aiming to reduce
boilerplate code and increase productivity.  Feedback and contributions are always appreciated!

Special thanks to the Swift Foundation community for fostering creativity and collaboration.
