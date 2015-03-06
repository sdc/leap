app = angular.module 'leapApp', ['ngSanitize']

app.controller 'timelineEventsController', ($scope,$http) ->
  $scope.getEvents = (url) ->
    $http.get(url).success (data) ->
      $scope.events = data
      $scope.getEvent(d.id) for d in data

  $scope.getEvent = (id) ->
    $http.get(eventUrl(id)).success (data) ->
      $scope.events[i] = data for e,i in $scope.events when e.id == id

  #$scope.pretty_title = (title) ->
  #  switch title.constructor.name
  #    when "String" then title
  #    when "Array" then "<div>#{title[0]}</div><div>#{title[1]}</div>"
  #    else "plop"

eventUrl = (id) ->
  "/events/#{id}.json"
