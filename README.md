# Hoster

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
