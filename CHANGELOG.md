# Changelog

## 0.8.0 / 2018-08-28

### Breaking Changes

* Ensure child elements only parse direct child nodes when parsing anonymously
  ([#100](https://github.com/mvz/happymapper/pull/100))

### Improvements

* Improve documentation
  ([#99](https://github.com/mvz/happymapper/pull/99))

### Bug fixes

* Handle repeated camel-cased elements as `has_many` when parsing anonymously
  ([#101](https://github.com/mvz/happymapper/pull/101))
* Avoid creating extra elements named `text` when parsing anonymously
  ([#98](https://github.com/mvz/happymapper/pull/98))

## 0.7.0 / 2018-08-27

### Breaking Changes

* Remove constant `HappyMapper::DEFAULT_NS`
  ([#78](https://github.com/mvz/happymapper/pull/78))
* Drop support for Ruby 2.2 and below
  ([#80](https://github.com/mvz/happymapper/pull/80))

### Improvements

* Support Ruby 2.5
* Always sort namespaces. This adds support for JRuby.
  ([#84](https://github.com/mvz/happymapper/pull/84))

### Bug fixes

* Ensure `#to_xml` generates UTF-8 content
  ([#88](https://github.com/mvz/happymapper/pull/88))
* Handle namespaces for nested value elements when parsing anonymously
  ([#87](https://github.com/mvz/happymapper/pull/87))
* Handle attributes with a namespace that is different from the element
  namespace ([#87](https://github.com/mvz/happymapper/pull/87))
* Ensure camel-cased elements have content in anonymous parse
  ([#85](https://github.com/mvz/happymapper/pull/85))

## 0.6.0 / 2017-09-17

* Prevent parsing of empty string for Date, DateTime (wushugene)
* Rescue nil dates (sarsena)
* Preserve XML value (benoist)
* Restore `after_parse` callback support (codekitchen)
* Parse specific types before general types (Ivo Wever)
* Higher priority for namespace on element declarations (Ivo Wever)

## 0.5.9 / 2014-02-18

* Correctly output boolean element value 'false'  (confusion)

## 0.5.8 / 2013-10-12

* Allow child elements to remove their parent's namespacing (dcarneiro)
* `has_many` elements were returning nil because the tag name was being ignored (haarts)
* Subclassed happymapper classes are allowed to override elements (benoist)
* Attributes on elements with dashes will properly created methods (alex-klepa)
* 'Embedded' attributes break parsing when parent element is not present (geoffwa)

## 0.5.7 / 2012-10-29

## 0.5.6 / 2012-10-29

* Add possibility to give a configuration block to Nokogiri when parsing (DieboldInc).

## 0.5.5 / 2012-09-30

* Fix for Boolean attributes to ensure that they parse correctly (zrob)

## 0.5.4/ 2012-09-25

* the `#wrap` method allows you to better model xml content that is buried deep
  within the xml. This implementation addresses issues with calling `#to_xml`
  with content that was parsed from an xpath. (zrob)

* Parent HappyMapper classes may dictate the name of the tag for the child
  HappyMapper instances. (zrob)

## 0.5.3/ 2012-09-23

* String is the default type for parsed fields. (crv)
* Update the attributes of an existing HappyMapper instance with new XML (benoist)
