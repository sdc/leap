angular.module 'leapApp', ['ngRoute','ngSanitize']

.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/timeline/:view_name/:person_id',
      controller: "timelineEventsController"
      templateUrl: "/assets/timeline.html"
    .when '/tiles/:view_name/:person_id',
      controller: "timelineEventsController"
      templateUrl: "/assets/tiles.html"
    .when '/search/:q',
      controller: 'searchController',
      templateUrl: '/assets/search.html'
  ])

.run ($http,$rootScope) ->
  $http.get("/people/user.json").success (data) ->
    $rootScope.user = data

.controller 'timelineEventsController', ($scope,$http,$routeParams,$rootScope,Topic) ->
  $scope.update_count = 0
  $scope.getEvent = (id) ->
    $scope.update_count++
    $rootScope.topic.updating = "btn-success"
    $http.get "/people/#{$routeParams.person_id}/events/#{id}.json"
      .success (data) ->
        $scope.events[i] = data for e,i in $scope.events when e.id == id
        $rootScope.topic.updating = false unless --$scope.update_count

  $scope.updateEvents = ->
    $scope.getEvent(d.id) for d in $scope.events

  $scope.getEvents = ->
    date = $scope.events[$scope.events.length-1].event_date if $scope.events.length > 1
    $http.get("/people/#{$routeParams.person_id}/views/#{$routeParams.view_name}.json#{ "?date=#{date}" if date}").success (data) ->
      $scope.events = $scope.events.concat(data)
      $scope.updateEvents()
      #$interval $scope.updateEvents, 15000

  Topic.set $routeParams.person_id
  $scope.events = []
  $scope.getEvents()
  $scope.$on "updated_topic", -> $scope.updateEvents()

.controller 'viewsController', ($scope,$http) ->
  $scope.getViews = ->
    $http.get('/views.json').success (data) ->
      $scope.views = data
  $scope.getViews()

.controller 'moodleCoursesController', ($scope,$http,$rootScope) ->
  $scope.getCourses = (mis_id) ->
    $http.get("/people/#{mis_id}/moodle_courses.json").success (data) ->
      $scope.courses = data
  $rootScope.$watch "user", (user) -> $scope.getCourses(user.mis_id)

.controller 'searchController', ($scope,$http,$location,$routeParams) ->
  $scope.working = false
  $scope.search = ->
    $location.path("/search/#{$scope.q}")

  $scope.gotoPerson = (mis_id) ->
    $location.path("/timeline/#{mis_id}")

  $scope.doSearch = ->
    $scope.working = true
    $http.get("/people/search.json?q=#{$routeParams.q}").success (data) ->
      $scope.people = data
      $scope.working = false
  $scope.doSearch()

.controller 'topicController', ($scope,$rootScope,Topic) ->
  $scope.update = -> Topic.update()

.factory 'Topic', ($http,$rootScope) ->
  $rootScope.$watch "user", (user) -> $rootScope.topic = user
  set:
    (mis_id) ->
      $http.get("/people/#{mis_id}.json").success (data) ->
        $rootScope.topic = data
  update: ->
    if $rootScope.topic
      $rootScope.topic.updating = "btn-warning"
      $http.get("/people/#{$rootScope.topic.mis_id}.json?refresh=true").success (data) ->
        $rootScope.topic = data
        $rootScope.$broadcast("updated_topic")

.filter 'iconUrl', ->
  (input) ->
    if /^http/.test(input) then input else "/assets/#{input}"

.filter 'leap-date', ->
  (input)
    
