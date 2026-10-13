# prontogui-dart
Dart language library for programs to build user interfaces with ProntoGUI.

> **ProntoGUI 1.x** was the `dartlib` package at `github.com/prontogui/dartlib` (up to v1.0.2). It
> is no longer developed. 2.0 is the `prontogui` package in this repo and is not compatible with 1.x
> servers.

At present, this library only supports the client side of ProntoGUI communication channel.  It is imported by the App to handle communication and building/updating the primitive object model.

## Project Contents
This project consists of a sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and unit tests in `test/`.

## Design policies
* [Field setter policy](doc/FIELD-SETTERS.md) - every field set is sent, even when the value is unchanged, and why.

## To add a new primitive
* Add the source file for the primitive, following existing patterns.
* Update primitive_factory.dart
* Update prontogui.dart to export the new primitive.

---
##### *Copyright 2024-2026 ProntoGUI, LLC*
##### *ProntoGUI™ is a trademark of ProntoGUI, LLC*