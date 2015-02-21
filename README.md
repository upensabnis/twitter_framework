# Twitter Data Collection Framework

February 2015

This is the start of a framework for accessing data from Twitter's
REST and Streaming APIs. It comes with several example applications
that demonstrate how to make use of the framework.

This framework was created by Prof. Ken Anderson of the Department of
Computer Science at the University of Colorado Boulder.

## Installation

To install the framework:

1. Download the archive.
2. cd into twitter_framework
3. bundle install
4. There is no step 4.

## Assumptions

The above installation instructions assume that you have Ruby 2.X.X
installed and that you also have Bundler installed and that the
`bundle` command is on your path.

## Property Files

Each of the included applications has a required command-line
argument `-p` (short for `--props`) which takes the name of a
file that contains a consumer key and user access token generated
by <https://dev.twitter.com/>. The format of the file is the
following:

```Javascript
{
  "consumer_key"    : "<consumer_key_goes_here>",
  "consumer_secret" : "<consumer_secret_goes_here>",
  "token"           : "<access_token_goes_here>",
  "token_secret"    : "<access_token_secret_goes_here>"
}
```

To get these values, head to <https://dev.twitter.com/> and click
on the link that says *Manage Your Apps*.


## Have Fun!!!!!!!!

You can now try out some of the command-line programs that come with
the framework such as get_tweets.rb or find_tweets.rb. Most of these
apps behave similarly. Invoke one with the `--help` flag to get
a feel for how they work.

If you have any questions, send them to Prof. Ken Anderson of the
Department of Computer Science at the University of Colorado Boulder.

## License

Copyright (c) 2015 Kenneth M. Anderson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files
(the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
