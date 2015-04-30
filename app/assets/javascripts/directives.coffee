angular.module 'leapApp'

.directive 'leapViewsMenu', ($http,Topic,$rootScope) ->
  restrict: "E"
  templateUrl: "/assets/views_menu.html"
  link: (scope) ->
    refresh = ->
      $http.get(Topic.urlBase() + '/timeline_views.json').success (data) ->
        scope.timeline_views = data
        scope.baseUrl = "#/#{Topic.get().topic_type}/#{Topic.get().mis_id}/"
    $rootScope.$on 'topicChanged', -> refresh()
    refresh()

.directive 'leapTopicHeader', ($rootScope,Topic,$log,$document) ->
  restrict: "EA"
  templateUrl: '/assets/topic_header.html'
  link: (scope, element) ->
    $rootScope.$on 'topicUpdated', ->
      scope.topic = Topic.get()
      $log.info "TopicHeader: I saw the topic (#{scope.topic.name}) update"
      scope.$broadcast "person_#{scope.topic.id}_updated"
    $rootScope.$on 'topicChanged', ->
      scope.topic = Topic.get()
      $log.info "TopicHeader: I saw the topic change to #{scope.topic.name}"
    $document.on 'scroll', ->
      scope.collapseTopicBar = $document.scrollTop() > (element.find('header').prop('offsetHeight') - 24)

.directive 'leapTopBar', ($rootScope) ->
  restrict: "E"
  templateUrl: '/assets/top_bar.html'

.directive 'leapPersonHeader', ($http,Topic,$log) ->
  restrict: "EA"
  templateUrl: '/assets/person_header.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.detailsPane='contacts'
    scope.refresh = -> Topic.update()
    scope.$watch 'misId', ->
      $http.get("/people/#{scope.misId}.json",{cache: true}).success (data) ->
        scope.person = data
        $log.info "PersonHeader: I changed to #{scope.person.name}"

.directive 'leapCourseHeader', ($http,Topic) ->
  restrict: "EA"
  templateUrl: '/assets/course_header.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.$watch 'misId', ->
      $http.get("/courses/#{scope.misId}.json").success (data) ->
        scope.course = data

.directive 'leapCourse', ($http,$rootScope,Topic) ->
  restrict: "E"
  templateUrl: '/assets/course.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.$watch 'misId', ->
      return unless scope.misId
      $http.get("/courses/#{scope.misId}.json").success (data) ->
        scope.course = data

.directive 'leapPerson', ($http,$log) ->
  restrict: "EA"
  templateUrl: '/assets/person.html'
  scope:
    misId: '='
    flags: '@'
  link: (scope,element,attrs) ->
    scope.flags = scope.flags=="flags"
    scope.$on "person_#{scope.misId}_updated", ->
      $log.info "Person #{scope.name}: I need to update myself"
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data
        $log.info "Person #{data.name}: I updated myself."
    scope.$watch 'misId', ->
      return unless scope.misId
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data

.directive 'leapTimelineEvent', ($http,Topic) ->
  restrict: "E"
  templateUrl: '/assets/timeline_event.html'
  scope:
    leapEventId: '='
    showDate: '='
  link: (scope,element,attrs) ->
    $http.get("#{Topic.urlBase()}/events/#{scope.leapEventId}.json").success (data) ->
      scope.event = data
      scope.eventDate = new Date(scope.event.eventDate)
      scope.showTime = !(scope.eventDate.getHours() == scope.eventDate.getMinutes() == scope.eventDate.getSeconds() == 0)
      scope.showPerson = Topic.get().topic_type != "person"

.directive 'leapTimelineControls', (Timeline,$rootScope) ->
  restrict: "E"
  templateUrl: '/assets/timeline_controls.html'
  link: (scope,element) ->
    scope.popupControls = ->
      scope.view.showControls = true
      scope.view.showButton = false
      (element.find('textarea')[0] || element.find('input')[0]).focus()
    scope.$on "cancelEventForm", ->
      scope.view.showControls = false
      scope.view.showButton = true
    $rootScope.$on "timelineUpdated", ->
      view = Timeline.getView()
      view.showButton = view.controls.length > 0

.directive 'leapEventForm', ($http,Topic,Timeline) ->
  restrict: "E"
  scope:
    templateUrl: '='
    eventType: '='
  templateUrl: '/assets/event_form.html'
  link: (scope) ->
    scope.newEvent = {}
    scope.cancelForm = -> scope.$emit("cancelEventForm")
    scope.createEvent = ->
      toPost = {eventable_type: scope.eventType }
      toPost[scope.eventType] = scope.newEvent
      $http.post(Topic.urlBase() + "/events.json",toPost).success (data) ->
        Timeline.update()
        scope.$emit("cancelEventForm")

.directive 'leapTile', ($http,Topic) ->
  restrict: "E"
  templateUrl: '/assets/tile.html'
  scope:
    leapEventId: '='
  link: (scope,element,attrs) ->
    $http.get("#{Topic.urlBase()}/events/#{scope.leapEventId}.json").success (data) ->
      scope.event = data
      scope.eventDate = new Date(scope.event.eventDate)
      scope.showTime = !(scope.eventDate.getHours() == scope.eventDate.getMinutes() == scope.eventDate.getSeconds() == 0)
      scope.showPerson = Topic.get().topic_type != "person"

.directive 'autoActive', ($location) ->
  restrict: 'A',
  scope: false,
  link: (scope, element) ->
    setActive = ->
      path = $location.path()
      angular.forEach element.find('li'), (li) ->
        anchor = li.querySelector('a')
        if (anchor.href.match('#' + path + '(?=\\?|$)'))
          angular.element(li).addClass('active')
        else
          angular.element(li).removeClass('active')
    scope.$on '$locationChangeSuccess', setActive
    setActive()
