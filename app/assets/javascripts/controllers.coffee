angular.module 'leapApp'

.controller 'TimelineController', ($scope,$http,$routeParams,Topic,Timeline,$rootScope,$log,$interval,Categories) ->
  masonry = null
  Topic.set($routeParams.topic_id,$routeParams.topic_type).then ->
    Timeline.setView $routeParams.view_name || "home"
    #Topic.update()
    $rootScope.topic = Topic.get()
    #$interval Timeline.update, 4000
  $rootScope.$on "timelineUpdated", ->
    $scope.years = Timeline.years()
    $scope.events = Timeline.get()
    $scope.registers = Timeline.registers()
    $scope.view = Timeline.getView()
    $scope.date = Timeline.getDate()
    $scope.people = Timeline.people()
    $scope.statuses = Timeline.statuses()
    $scope.statusFilter = if _.contains($scope.statuses,'Active') then 'Active' else ''
    $scope.categories = [Categories.get(1),Categories.get(2),Categories.get(3)]
  $scope.$on "brickLoaded", (w) ->
    masonry?= new Masonry '.masonry-events',
      itemSelector: 'leap-brick'
      isInitLayout: false
    masonry.layout()
  $scope.setStatusFilter = (filter) -> $scope.statusFilter = (filter || '')

.controller 'SearchController', ($scope,$http,$location,$routeParams,Topic,Timeline) ->
  $scope.working = false
  $scope.filter = "people"
  $scope.search = -> $location.path("/search").search("q",$scope.q)
  $scope.doSearch = ->
    Topic.reset()
    return unless $routeParams.q
    $scope.working = true
    $http.get("/people/search.json?q=#{$routeParams.q}").success (data) ->
      $scope.people = data.people
      $scope.courses = data.courses
      $scope.filter = "courses" if data.people.length == 0
      $scope.working = false
  $scope.doSearch()
