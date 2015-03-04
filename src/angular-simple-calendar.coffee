angular.module('500tech.calendar', []).directive 'calendar', ->
  restrict: 'E'
  scope:
    options: '=?'
    events: '=?'
  template: '''
            <div class="calendar">
              <div class="current-month">
                <div class="move-month prev-month" ng-click="prevMonth()">
                  <span ng-show="allowedPrevMonth()">&#x2039;</span>
                </div>
                <span>{{ selectedMonth }}</span>
                &nbsp;
                <span>{{ selectedYear }}</span>
                <div class="move-month next-month" ng-click="nextMonth()">
                  <span ng-show="allowedNextMonth()">&#x203a;</span>
                </div>
              </div>
              <div>
                <div ng-repeat="day in weekDays(options.dayNamesLength) track by $index" class="weekday">{{ day }}</div>
              </div>
              <div>
                <div ng-repeat="week in weeks track by $index" class="week">
                  <div class="day" 
                       ng-class="{default: isDefaultDate(date), event: date.event, disabled: date.disabled || !date}"
                       ng-repeat="date in week  track by $index"
                       ng-click="onClick(date)">
                    <div class="day-number">{{ date.day || '&nbsp;' }}</div>
                    <div class="event-title">{{ date.event.title || '&nbsp;' }}</div>
                  </div>
                </div>
              </div>
            </div>
            '''
  controller: [ "$scope", ($scope) ->
    MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    WEEKDAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

    $scope.options ?= {}
    $scope.options.dayNamesLength ?= 3

    $scope.onClick = (date) ->
      return if !date || date.disabled
      if date.event
        $scope.options.eventClick(date)
      else
        $scope.options.dateClick(date)

    if $scope.options.minDate
      $scope.options.minDate = new Date($scope.options.minDate)

    if $scope.options.maxDate
      $scope.options.maxDate = new Date($scope.options.maxDate)

    bindEvent = (date) ->
      return unless date || $scope.events
      for event in $scope.events
        event.date = new Date(event.date)
        date.event = event if date.year == event.date.getFullYear() && date.month == event.date.getMonth() && date.day == event.date.getDate()

    allowedDate = (date) ->
      return true unless $scope.options.minDate || $scope.options.maxDate
      currDate = new Date([date.year, date.month + 1, date.day])
      return false if $scope.options.minDate && currDate < $scope.options.minDate
      return false if $scope.options.maxDate && currDate > $scope.options.maxDate
      true

    $scope.allowedPrevMonth = ->
      return true unless $scope.options.minDate
      currMonth = MONTHS.indexOf($scope.selectedMonth)
      prevYear = if currMonth == 0 then ($scope.selectedYear - 1) else $scope.selectedYear
      prevMonth = if currMonth == 0 then 11 else (currMonth - 1)
      return false if prevYear < $scope.options.minDate.getFullYear()
      if prevYear == $scope.options.minDate.getFullYear()
        return false if prevMonth < $scope.options.minDate.getMonth()
      true

    $scope.allowedNextMonth = ->
      return true unless $scope.options.maxDate
      currMonth = MONTHS.indexOf($scope.selectedMonth)
      nextYear = if currMonth == 11 then ($scope.selectedYear + 1) else $scope.selectedYear
      nextMonth = if currMonth == 11 then 0 else (currMonth + 1)
      return false if nextYear > $scope.options.maxDate.getFullYear()
      if nextYear == $scope.options.maxDate.getFullYear()
        return false if nextMonth > $scope.options.maxDate.getMonth()
      true

    calculateWeeks = ->
      $scope.weeks = []
      week = null
      daysInCurrentMonth = new Date($scope.selectedYear, MONTHS.indexOf($scope.selectedMonth) + 1, 0).getDate()
      for day in [1..daysInCurrentMonth]
        dayNumber = new Date($scope.selectedYear, MONTHS.indexOf($scope.selectedMonth), day).getDay()
        week ?= [null, null, null, null, null, null, null]
        week[dayNumber] =
          year: $scope.selectedYear
          month: MONTHS.indexOf($scope.selectedMonth)
          day: day
        if allowedDate(week[dayNumber])
          bindEvent(week[dayNumber]) if $scope.events
        else
          week[dayNumber].disabled = true

        if dayNumber == 6 || day == daysInCurrentMonth
          $scope.weeks.push(week)
          week = undefined

    calculateSelectedDate = ->
      if $scope.options.defaultDate
        $scope.options._defaultDate = new Date($scope.options.defaultDate)
      else
        $scope.options._defaultDate = new Date()

      $scope.selectedYear  = $scope.options._defaultDate.getFullYear()
      $scope.selectedMonth = MONTHS[$scope.options._defaultDate.getMonth()]
      $scope.selectedDay   = $scope.options._defaultDate.getDate()
      calculateWeeks()

    $scope.weekDays = (size = 9) ->
      WEEKDAYS.map (name) -> name.slice(0, size)

    $scope.isDefaultDate = (date) ->
      return unless date
      date.year == $scope.options._defaultDate.getFullYear() &&
        date.month == $scope.options._defaultDate.getMonth() &&
        date.day == $scope.options._defaultDate.getDate()

    $scope.prevMonth = ->
      return unless $scope.allowedPrevMonth()
      currIndex = MONTHS.indexOf($scope.selectedMonth)
      if currIndex == 0
        $scope.selectedYear -= 1
        $scope.selectedMonth = MONTHS[11]
      else
        $scope.selectedMonth = MONTHS[currIndex - 1]
      calculateWeeks()

    $scope.nextMonth = ->
      return unless $scope.allowedNextMonth()
      currIndex = MONTHS.indexOf($scope.selectedMonth)
      if currIndex == 11
        $scope.selectedYear += 1
        $scope.selectedMonth = MONTHS[0]
      else
        $scope.selectedMonth = MONTHS[currIndex + 1]
      calculateWeeks()

    $scope.$watch 'options.defaultDate', ->
      calculateSelectedDate()

    $scope.$watch 'events', ->
      calculateWeeks() 
  ]