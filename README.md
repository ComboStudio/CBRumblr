# Rumblr - iOS App

Rumblr - entrance music for your office Sonos.

## Welcome

Welcome to the Rumblr iOS repo! If you've just stumbled across this repo, it might be worth noting that this is the front-end side of project called Rumblr.

Please note that you'll need a bit of a technical understanding to get this all set up - but there's a comprehensive step-by-step guide to doing so over on this blog.

## Things to note

* Due to the limitations of the Sonos API, you'll need to make sure you're running the server on the same network that your Sonos system is connected to. Setting this up on a Raspberry Pi would be a pretty sweet and discreet way of doing this - but if you're lazy, you can just run this from any computer that has Node installed and is connected to the Sonos' network. Works just fine.

* This doesn't support multiple Sonos systems particularly well. The way the script's written is simply to pick whichever the first Sonos the system comes across and use that (simply because we've only got one in our studio...!). If you have a Sonos IP you'd like to specifically connect to, you can set the environment variable SONOS_IP to the IP of the system. 

* The server logic itself is written in ES6 in the /lib folder. When *npm run build* is run, it'll run babel and compile the code to /build.

## Starting the server

Easy as pie - just download, open Terminal, navigate to the folder and run the following:

	npm install

	npm run build

	npm run prod

Now, if you're setting up the full experience, [head over here](https://github.com/ComboStudio/CBRumblr) and finish the rest of the setup for iOS!

## People who did this

We're a [tiny product studio called Combo](https://www.combostudio.co) from London who love making gnarly digital products just like this (or alternatively, absolutely nothing like this). 

Interested in working with us? Sweet, our mailboxes are wide open. Drop us a line on [sam@combostudio.co](mailto:sam@combostudio.co).

## License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.