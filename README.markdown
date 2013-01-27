# Shinobi-RangeSelector.git

This iOS app is a demonstration of how to create a range selector by linking
2 [Shinobi](http://www.shinobicontrols.com/) charts, similar to that demonstrated
in the 'impress' chart in [ShinobiPlay](https://itunes.apple.com/gb/app/shinobiplay/id545634307).

The project is accompanied by a series of blog posts, the first of which is available
at [http://sammyd.github.com/blog/2013/01/11/building-a-range-selector-with-shinobi-charts-part-i-linking-2-charts/].

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

## Questions

Feel free to hit me up with any questions - on GitHub or
[@iwantmyrealname](http://twitter.com/iwantmyrealname/) on twitter. The good folks
at Shinobi (of which I am one) will be happy to help where they can as well.

(C) Sam Davies, January 2013