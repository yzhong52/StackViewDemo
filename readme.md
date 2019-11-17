# UIStackView Demo

This is a demo app for [UIStackView: distribution vs alignment 📚](https://medium.com/@yzhong.cs/uistackview-distribution-vs-alignment-146b9612e24c).

* It shows show the stack view looks like with the different settings of `distribution` and `alignment`.
* Things are organized in a `UICollectionView` which scroll both vertically and horizontally.
* Some tricks are use to add background color to the `UIStackView`, adding dashed borders to subviews, etc. 
* While running the application, it will capture snapshots of the stack view and save them on the my Desktop :P if `shouldSnapshot` is set to `true`.
* For simplicity, everything is under one file `ViewController.swift`.

![](screenshot.jpg)
