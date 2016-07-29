angular.module('500tech.simple-calendar', []).directive 'simpleCalendar', ->
  {
    restrict: 'E'
    scope:
      options: '=?'
      events: '=?'
    template: '<div class="calendar">' + '<div class="current-month">' + '<div class="move-month prev-month" ng-click="prevMonth()">' + '<span ng-show="allowedPrevMonth()">&#x2039;</span>' + '</div>' + '<div class="wrap"><span>{{ selectedMonth }}</span>' + '&nbsp;' + '<span>{{ selectedYear }}</span></div>' + '<div class="move-month next-month" ng-click="nextMonth()">' + '<span ng-show="allowedNextMonth()">&#x203a;</span>' + '</div>' + '</div>' + '<div>' + '<div ng-repeat="day in weekDays(options.dayNamesLength) track by $index" class="weekday">{{ day }}</div>' + '</div>' + '<div>' + '<div ng-repeat="week in weeks track by $index" class="week">' + '<div class="day"' + 'ng-class="{default: isDefaultDate(date), event: date.event, disabled: date.disabled || !date}"' + 'ng-repeat="date in week  track by $index"' + 'ng-click="onClick(date)">' + '<div class="day-number">{{ date.day || "&nbsp;" }}</div>' + '<div class="event-title">{{ date.event.title || "&nbsp;" }}</div>' + ' </div>' + '</div>' + '</div>' + '</div>'
    controller: [
      '$scope'
      ($scope) ->
        MONTHS = [
          'Janeiro'
          'Fevereiro'
          'Março'
          'Abril'
          'Maio'
          'Junho'
          'Julho'
          'Agosto'
          'Setembro'
          'Outubro'
          'Novembro'
          'Dezembro'
        ]
        WEEKDAYS = [
          'Domingo'
          'Segunda-feira'
          'Terça-feira'
          'Quarta-feira'
          'Quinta-feira'
          'Sexta-feira'
          'Sábado'
        ]
        calculateSelectedDate = undefined
        calculateWeeks = undefined
        allowedDate = undefined
        bindEvent = undefined
        $scope.options = $scope.options or {}
        $scope.options.dayNamesLength = $scope.options.dayNamesLength or 1

        $scope.onClick = (date) ->
          if !date or date.disabled
            return
          if date.event
            $scope.options.eventClick date
          else
            $scope.options.dateClick date
          return

        if $scope.options.minDate
          $scope.options.minDate = new Date($scope.options.minDate)
        if $scope.options.maxDate
          $scope.options.maxDate = new Date($scope.options.maxDate)

        bindEvent = (date) ->
          if !date or !$scope.events
            return
          $scope.events.forEach (event) ->
            event.date = new Date(event.date)
            if date.year == event.date.getFullYear() and date.month == event.date.getMonth() and date.day == event.date.getDate()
              date.event = event
            return
          return

        allowedDate = (date) ->
          if !$scope.options.minDate and !$scope.options.maxDate
            return true
          currDate = new Date(date.year, date.month, date.day)
          if $scope.options.minDate and currDate < $scope.options.minDate
            return false
          if $scope.options.maxDate and currDate > $scope.options.maxDate
            return false
          true

        $scope.allowedPrevMonth = ->
          prevYear = null
          prevMonth = null
          if !$scope.options.minDate
            return true
          currMonth = MONTHS.indexOf($scope.selectedMonth)
          if currMonth == 0
            prevYear = $scope.selectedYear - 1
          else
            prevYear = $scope.selectedYear
          if currMonth == 0
            prevMonth = 11
          else
            prevMonth = currMonth - 1
          if prevYear < $scope.options.minDate.getFullYear()
            return false
          if prevYear == $scope.options.minDate.getFullYear()
            if prevMonth < $scope.options.minDate.getMonth()
              return false
          true

        $scope.allowedNextMonth = ->
          nextYear = null
          nextMonth = null
          if !$scope.options.maxDate
            return true
          currMonth = MONTHS.indexOf($scope.selectedMonth)
          if currMonth == 11
            nextYear = $scope.selectedYear + 1
          else
            nextYear = $scope.selectedYear
          if currMonth == 11
            nextMonth = 0
          else
            nextMonth = currMonth + 1
          if nextYear > $scope.options.maxDate.getFullYear()
            return false
          if nextYear == $scope.options.maxDate.getFullYear()
            if nextMonth > $scope.options.maxDate.getMonth()
              return false
          true

        calculateWeeks = ->
          $scope.weeks = []
          week = null
          daysInCurrentMonth = new Date($scope.selectedYear, MONTHS.indexOf($scope.selectedMonth) + 1, 0).getDate()
          day = 1
          while day < daysInCurrentMonth + 1
            dayNumber = new Date($scope.selectedYear, MONTHS.indexOf($scope.selectedMonth), day).getDay()
            week = week or [
              null
              null
              null
              null
              null
              null
              null
            ]
            week[dayNumber] =
              year: $scope.selectedYear
              month: MONTHS.indexOf($scope.selectedMonth)
              day: day
            if allowedDate(week[dayNumber])
              if $scope.events
                bindEvent week[dayNumber]
            else
              week[dayNumber].disabled = true
            if dayNumber == 6 or day == daysInCurrentMonth
              $scope.weeks.push week
              week = undefined
            day += 1
          return

        calculateSelectedDate = ->
          if $scope.options.defaultDate
            $scope.options._defaultDate = new Date($scope.options.defaultDate)
          else
            $scope.options._defaultDate = new Date
          $scope.selectedYear = $scope.options._defaultDate.getFullYear()
          $scope.selectedMonth = MONTHS[$scope.options._defaultDate.getMonth()]
          $scope.selectedDay = $scope.options._defaultDate.getDate()
          calculateWeeks()
          return

        $scope.weekDays = (size) ->
          WEEKDAYS.map (name) ->
            name.slice 0, size

        $scope.isDefaultDate = (date) ->
          if !date
            return
          date.year == $scope.options._defaultDate.getFullYear() and date.month == $scope.options._defaultDate.getMonth() and date.day == $scope.options._defaultDate.getDate()

        $scope.prevMonth = ->
          if !$scope.allowedPrevMonth()
            return
          currIndex = MONTHS.indexOf($scope.selectedMonth)
          if currIndex == 0
            $scope.selectedYear -= 1
            $scope.selectedMonth = MONTHS[11]
          else
            $scope.selectedMonth = MONTHS[currIndex - 1]
          calculateWeeks()
          return

        $scope.nextMonth = ->
          if !$scope.allowedNextMonth()
            return
          currIndex = MONTHS.indexOf($scope.selectedMonth)
          if currIndex == 11
            $scope.selectedYear += 1
            $scope.selectedMonth = MONTHS[0]
          else
            $scope.selectedMonth = MONTHS[currIndex + 1]
          calculateWeeks()
          return

        $scope.$watch 'options.defaultDate', ->
          calculateSelectedDate()
          return
        $scope.$watch 'events', ->
          calculateWeeks()
          return
        return
    ]
  }

# ---
# generated by js2coffee 2.2.0
