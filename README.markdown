# ShinobiCharts RangeSelector (Objective-C)

This iOS app is a demonstration of how to create a range selector by linking
2 [Shinobi](http://www.shinobicontrols.com/) charts, similar to that demonstrated
in the 'impress' chart in [ShinobiPlay](https://itunes.apple.com/gb/app/shinobiplay/id545634307).

![Screenshot](screenshot.png?raw=true)

The project is accompanied by a series of blog posts, the first of which is available [here](http://www.shinobicontrols.com/blog/posts/2013/02/20/building-a-range-selector-with-shinobicharts-part-i/).

Although the code is not ready to reuse straight out of the box, I have attempted
to write it in such a way that the majority of it is self-contained and generic
enough that you will be able to find what you need should you want to implement
a similar control in your own iOS apps.

## Getting Started

In order to get started with the project you'll need a license for Shinobi
charts, which are available at their website. You can get yourself a 30-day
trial so that you can give them a test drive - just head on over to [shinobicontrols.com]
to sign up.

Simply drag `ShinobiCharts.embeddedframework` from the finder (once you've unzipped it)
into Xcode's 'frameworks' group and it'll sort out all the header and linker
paths for you. The 'Getting Started Guide' provided with the zip will give further
details.

If you've signed up for a trial, you'll receive a license key in your inbox. In
order to get this project to run you'll have to add the license key to the
source code. To do this, simply edit the appropriate line in `ShinobiLicense.m`:

```
+ (NSString *)getShinobiLicenseKey
{
    //return @"YOUR CODE HERE";
}
```

The code is currently reading the license from a private plist, so you can use that
as an alternative should you want to. Follow the instructions in the comments of that
method to discover what to do.

Contributing
------------

We'd love to see your contributions to this project - please go ahead and fork it and send us a pull request when you're done! Or if you have a new project you think we should include here, email info@shinobicontrols.com to tell us about it.

License
-------

The [Apache License, Version 2.0](license.txt) applies to everything in this repository, and will apply to any user contributions.
