# Calendar-Event-Template-App
Allows the user to quickly create calendar events in many fewer taps than the Google Calendar, iOS, etc. client apps. Programmed in Swift 3 and designed in Sketch.  

The approach is founded on the idea that calendar event scheduling should be done with the event time being the last and most important consideration. Rather than finding a time, filling out event details, then realizing the event time doesn't work and having to start all over again, users should be able to see their schedule up until the time they click save.  

Slate Scheduler allows you to view your calendar as you create the event — giving you the option to view your schedule for any day and change the date/time of the event without having to cancel your scheduling.

### Technical Details
1. Uses a basic Markov model to predict event names, locations, etc.