# SMIFF Music - Social Media Interface For Music

The idea is simple, people send a tweet then the SMIFF Music app makes music. Only the music is written, modified and interacted with by many people over the web. Hopefully producing an unending and infinitely modifiable, constantly developing and organic piece of music where all are involved.

It is primarily controlled via a set of terminal-style commands which are designed to get the information required to create and modify music in as 'plain-english' a way as possible.

SMIFF is currently at version 0.1, in which users can define drums and melodies. 

Components:

* Ruby on Rails app - serves data on the current content of the music, and the web audio player. 
* Web-audio player - using the web audio api, this will produce the sound spontaneously on the client computer.

There is an end-game plan to allow users to send the terminal-style messages which control SMIFF via twitter, allowing users to change the SMIFF music from anywhere.

## Dependencies

* Ruby 2.1.1
* rails 4.1.0
* mysql, or another database

I recommend working with rvm, the version manager, to ring-fence the ruby you are using for SMIFF from other ruby projects.

## Installation 

This is the installation process for a local instance.

* `git clone git@github.com:AJFaraday/smiff_music.git`
* `cd smiff_music`
* `bundle install`
* modify /config/database.yml if necessary (the repo version is for mysql with an unprotected root user, it is not secure)
* `rake db:setup`
* `rails s`
* point your browser to localhost:3000

## Documentation

When the app is running you can select 'help' in the header to see the formatted, indexed help docs for using SMIFF. 

It is also available as an amalgamated .md file in `/docs/help/help.md` or in github at [https://github.com/AJFaraday/smiff\_music/blob/master/docs/help/help.md](https://github.com/AJFaraday/smiff_music/blob/master/docs/help/help.md)

There are some technical docs for developers in /docs/technical


