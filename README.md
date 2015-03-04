# angular-simple-calendar

Simple customizable AngularJS calendar with no dependencies. Supports simple events (only date and title).


## Install

Install via bower:

```bash
bower install --save angular-simple-calendar
```

Add to index.html:

```html
<link rel="stylesheet" href="bower_components/angular-simple-calendar/dist/angular-simple-calendar.css">
<script type="text/javascript" src="bower_components/angular-simple-calendar/dist/angular-simple-calendar.js"></script>
```

Inject ``'500tech.simple-calendar'`` into your main module:

```javascript
angular.module('App', [
  // ... other dependencies
  '500tech.simple-calendar'
])
```

## Usage

Add ``<simple-calendar events="events" options="calendarOptions"></simple-calendar>`` directive to your html file.

Simple calendar takes a few options:

```javascript
app.controller('UsersIndexController', ['$scope', function($scope) {
  // ... code omitted ...
  // Dates can be passed as strings or Date objects 
  $scope.calendarOptions = {
    defaultDate: "2016-10-10",
    minDate: new Date(),
    maxDate: new Date([2020, 12, 31]),
    dayNamesLength: 1, // How to display weekdays (1 for "M", 2 for "Mo", 3 for "Mon"; 9 will show full day names; default is 1)
    eventClick: $scope.eventClick,
    dateClick: $scope.dateClick
  };
  
  $scope.events = [
      {title: 'NY', date: new Date([2015, 12, 31])},
      {title: 'ID', date: new Date([2015, 6, 4])}
    ];
}]);
```

## Events

You can pass two functions in options: eventClick and/or dateClick.

If clicked date has an event on it, eventClick will fire, otherwise will dateClick.

Both functions can get an object with data about clicked date:

```javascript
{
  year: 2014,
  month: 0, // Regular JS month number, starts with 0 for January
  day: 23,
  event: { // event will only be added for dates that have an event.
    title: "Some event",
    date: [Date Object]
  }
}
```


## Customization

Simple calendar is very easy to customize via css:

```scss
simple-calendar {
  * {
    user-select: none;
  }
  
  .calendar{
    padding: 0;
    border: 1px solid #dddddd;
    background-color: #fff;
  }
  
  .move-month { cursor: pointer; }
  .prev-month { float: left; }
  .next-month { float: right; }
  
  .current-month {
    width: 100%;
    text-align: center;
    padding: 20px 8px;
  }
  
  .week {
    height: 30px;
    
    .day:last-child {
      border-right: none;
    }
  }
  
  .weekday { text-align: center; }
  
  .weekday, .day {
    display: inline-block;
    width: calc(100% / 7);
  }
  
  .day {
    height: 30px;
    padding: 2px;
    border: 1px solid #dddddd;
    border-bottom: none;
    border-left: none;
    overflow: hidden;

    &:hover { cursor: pointer; }
    &.default { background-color: lightblue; }
    &.event { background-color: #fdf3ea; }

    &.disabled {
      cursor: default;
      color: silver;
      background-color: white;
    }
  }
}
```

## License

MIT Licensed

Copyright (c) 2014, [500Tech](http://500tech.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sub-license, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
