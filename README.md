# Rumblr - iOS App

Rumblr - entrance music for your office Sonos.

## Welcome

Welcome to the Rumblr iOS repo! If you've just stumbled across this repo, it might be worth noting that this is the front-end side of project called Rumblr.

Please note that you'll need a bit of a technical understanding to get this all set up - but there's a comprehensive step-by-step guide to doing so over on this blog.

## Getting started

First, make sure Cocoapods is installed, navigate to the directory in the Terminal and enter:

	pod install

Once the associated Pods are installed, you're going to want to make a couple of file adjustments.

## A couple of notes before setting up

* **The server needs to be running on the same network as the client device AND the Sonos for this to work!** Yeah, it's far from ideal, but the Sonos bits require a bit of tunnel-y magic I haven't got round to trying yet. Would love to see any implementation of this, however!

* For more information about the inner workings of the beacons, I've written some comments in the **BRELocationManager.swift** file. If you're keen to learn how to range and monitor beacons, I'd suggest flicking through some of my waffle over there.

### 1. Setting up for your own Beacons

The app works by detecting beacons specified in the beacons.json file. It's a fairly straightforward file structure to follow - you can add as many/few regions as you like. 

The beacons.json template that's included follows our setup - two beacons within a single region (sharing a common UUID). To get started, go ahead and edit the beacons.json file to fit your own setup (regions/beacons).

**Note:** If you have multiple regions (read: beacons with multiple UUIDs), you'll need to create a region for every one of those beacons!

### 2. Setting up for your server

To get this working properly, you'll need to set up a server to run on the local network. The server files are available **[over at this repo](https://github.com/ComboStudio/CBRumblrAPI)**. 

Once your server's up and running, grab the IP for the host machine, open **BREConstants.swift** and change the **BREServerRoot** URL to whatever that IP is. 

**And that's it. Happy studio entering!**

## People who did this

We're a [tiny product studio called Combo](https://www.combostudio.co) from London who love making gnarly digital products just like this (or alternatively, absolutely nothing like this). 

Interested in working with us? Sweet, our mailboxes are wide open. Drop us a line on [sam@combostudio.co](mailto:sam@combostudio.co).

## License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.