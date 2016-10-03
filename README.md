# Hoster

[![Code Climate](https://codeclimate.com/github/joel/hoster.png)](https://codeclimate.com/github/joel/hoster)

[![Dependency Status](https://gemnasium.com/joel/hoster.png)](https://gemnasium.com/joel/hoster)

[![Build Status](https://travis-ci.org/joel/hoster.png?branch=master)](https://travis-ci.org/joel/hoster) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/github/joel/hoster/badge.svg?branch=master)](https://coveralls.io/github/joel/hoster?branch=master)

Simple Sinatra app to respond to a Slack command, basically a Slackbot.

### Purpose

Just to define who have to host the next weekly meeting.

You can hit the command `/meeting` on whatever channel

you can hit the command with key words like `help get list reset left`

### Help

`/meeting help`

`No public message`

**Private Message:**

```
HELP:
/meeting help
/meeting get dry
/meeting who
/meeting list
/meeting reset
/meeting left
/meeting add <T_1_WEEK = 604800, T_2_WEEKS = 1209600, T_3_WEEKS = 1814400>
/meeting blacklist
```

### List

`/meeting list`

`No public message`

**Private Message:** `List :: Alexandra, Joel, Krzysztof, Lukasz, Steve`

### Get

You can ask who host the next meeting
`/meeting get`

**Public Message:** `**Alexandra** will host the next meeting`

**Private Message:** `Leftovers => Joel, Krzysztof, Lukasz, Steve`

### Get dry

when you hit `get` command the new host will be push on blacklist for 3 weeks and he/she can't host meeting during this period of time. so if you want to play without incidence you can add argument `dry`

You can ask who host the next meeting

`/meeting get dry`

**Public Message:** `**Alexandra** will host the next meeting`

**Private Message:** `Leftovers => Alexandra, Joel, Krzysztof, Lukasz, Steve`

You can ask who can be chosen for the next meeting, this mean people available on the random choose.

### Left

`/meeting left`

`No public message`

**Private Message:** `Leftovers => Joel, Krzysztof, Lukasz`

In case you can reset the blacklist

### Reset

`/meeting reset`

`No public message`

**Private Message:** `RESET, white list was cleaned!`

### Add

Time could be :
* 1 WEEK  => 604800
* 2 WEEKS => 1209600
* 3 WEEKS => 1814400

`/meeting add <host name for blacklist> <optional time, default: T_3_WEEKS = 1814400>`

`No public message`

**Private Message:** `**<host name for blacklist>** was put in blacklist, Leftovers => Joel, Krzysztof, Lukasz, Steve`

### Blacklist

`/meeting blacklist`

`No public message`

**Private Message:**

```
Leftovers:
Alexandra => 20 days, 23 hours, 58 minutes and 13 seconds (time left to remove it from Blacklist)
```

or `Nobody was blacklisted`

### Who

`/meeting who`

`No public message`

**Private Message:**

```
Current Host => Joel
```
