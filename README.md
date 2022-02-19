# USA Ultimate Match Report Scraper

This is an app that's usable on MacOS to verbally announce the score of a
match on usaultimate.org.

## Requirements

You must have ruby installed and the bundler gem. On MacOS you should have
ruby installed by default.

To install bundler, open up the Terminal application, `cd` into the directory
where you pulled down this git repo, and run `gem install bundler`. Then run
`bundle` on your command line.

## Usage

Go to usaultimate.org and find the match report for the game you want to
announce.  The URL is going to be something like `https://play.usaultimate.org/teams/events/match_report/?EventGameId=x82YxjYwOv6YuWgp%2b6uUQMVBe9Lv9TgMXVvBEjHIqnA%3d`.

Copy that URL from your browser location bar, then run the following from your
command line:

`ruby ./scrape-it match --url "<<PASTE YOUR URL IN HERE>>"`

Note that the double quotes are required in the command line.
