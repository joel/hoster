# Hoster

[![Code Climate](https://codeclimate.com/github/joel/hoster.png)](https://codeclimate.com/github/joel/hoster)

[![Dependency Status](https://gemnasium.com/joel/hoster.png)](https://gemnasium.com/joel/hoster)

[![Build Status](https://travis-ci.org/joel/hoster.png?branch=master)](https://travis-ci.org/joel/hoster) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/hoster/badge.svg?branch=master)](https://coveralls.io/r/joel/hoster?branch=master)

Simple Sinatra app to respond to a Slack command, basically a Slackbot.

### Purpose

Just to define who have to host the next weekly meeting.

You can hit the command on whatever channel you have `/who_runs_meeting`

you can hit the command with key word like

`/who_runs_meeting list`
```
slackbot List :: Lukasz, AntoineQ, Joel, Steve, Krzysztof, Alexandra
Only you can see this message
```

You can remove you from the list
`/who_runs_meeting Joel`
```
slackbot The new hoster is **AntoineQ** and thank you ​_Joel_​
Only you can see this message
```

Or just lunch the command
```
`/who_runs_meeting`
slackbot The new hoster is **Alexandra**
Only you can see this message
```
