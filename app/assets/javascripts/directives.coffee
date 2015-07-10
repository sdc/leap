angular.module 'leapApp'

.directive 'leapViewsMenu', ($http,Topic,$rootScope) ->
  templateUrl: "/assets/views_menu.html"
  link: (scope) ->
    refresh = ->
      $http.get(Topic.urlBase() + '/timeline_views.json').success (data) ->
        scope.timeline_views = data
        scope.baseUrl = "#/#{Topic.get().topic_type}/#{Topic.get().mis_id}/"
    $rootScope.$on 'topicChanged', -> refresh() if Topic.get()
    refresh()

.directive 'leapTopBar', ($rootScope) ->
  restrict: "E"
  templateUrl: '/assets/top_bar.html'

.directive 'leapPersonHeader', ($http,Topic,$log,$document) ->
  restrict: "EA"
  templateUrl: '/assets/person_header.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.detailsPane='links'
    scope.$watch 'misId', ->
      $http.get("/people/#{scope.misId}.json",{cache: true}).success (data) ->
        scope.person = data
        $log.info "PersonHeader: I changed to #{scope.person.name}"
    $document.on 'scroll', ->
      scope.collapseTopicBar = $document.scrollTop() > 115
    scope.$watch 'collapseTopicBar', (newv,oldv) ->
      if newv && !oldv
        element.addClass("fixed")
        scope.oldTab = scope.detailsPane
        scope.detailsPane = "links"
      else if oldv && !newv
        element.removeClass("fixed")
        scope.detailsPane = scope.oldTab

.directive 'leapCourseHeader', ($http,Topic,$document) ->
  restrict: "EA"
  templateUrl: '/assets/course_header.html'
  scope:
    misId: '='
  link: (scope,element,attrs) ->
    scope.$watch 'misId', ->
      $http.get("/courses/#{scope.misId}.json").success (data) ->
        scope.course = data
    $document.on 'scroll', ->
      scope.collapseTopicBar = $document.scrollTop() > 200
    scope.$watch 'collapseTopicBar', (newv,oldv) ->
      if newv && !oldv
        element.addClass("fixed")
        scope.oldTab = scope.detailsPane
        scope.detailsPane = "links"
      else if oldv && !newv
        element.removeClass("fixed")
        scope.detailsPane = scope.oldTab

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

.directive 'leapPerson', ($http,$log,LeapEvent) ->
  templateUrl: '/assets/person.html'
  scope:
    misId: '=?'
    leapId: '=?'
    enrolment: '=?'
    person: '=?'
    flags: '@?'
  link: (scope,element,attrs) ->
    scope.flags = scope.flags == "flags"
    scope.$on "person_#{scope.misId}_updated", ->
      $log.info "Person #{scope.name}: I need to update myself"
      $http.get("/people/#{scope.misId}.json").success (data) ->
        scope.person = data
        $log.info "Person #{data.name}: I updated myself."
    scope.$watch 'misId', ->
      return unless scope.misId
      $http.get("/people/#{scope.misId}.json").success (data) -> scope.person = data
    scope.$watch 'leapId', ->
      return unless scope.leapId
      $http.get("/people/#{scope.leapId}.json?id_type=leap").success (data) -> scope.person = data

.directive 'leapPlpRow', ($http,Categories) ->
  templateUrl: '/assets/plp_row.html'
  scope:
    leapId: '='
    enrolment: '='
  link: (scope) ->
    scope.$watch 'leapId', ->
      return unless scope.leapId
      $http.get("/people/#{scope.leapId}.json?id_type=leap").success (data) -> scope.person = data
    scope.categories = [Categories.get(1),Categories.get(2),Categories.get(3)]

.directive 'leapTimelineDate', (Timeline) ->
  restrict: 'E'
  templateUrl: '/assets/timeline_date.html'
  link: (scope) ->
    scope.timelineDate = Timeline.getDate().toDate()
    scope.$watch "timelineDate", (newDate,oldDate) ->
      Timeline.setDate(newDate)
      Timeline.update()
    scope.nextWeek = ->
      scope.timelineDate = moment(scope.timelineDate).add(1,"week").toDate()
    scope.prevWeek = ->
      scope.timelineDate = moment(scope.timelineDate).subtract(1,"week").toDate()
    scope.today = ->
      scope.timelineDate = moment().toDate()
    
.directive 'leapTimelineEvent', (LeapEvent,$timeout) ->
  restrict: "E"
  templateUrl: '/assets/timeline_event.html'
  scope:
    leapEventId: '='
    showDate: '='
  link: (scope,element,attrs) ->
    scope.extended = false
    scope.update = LeapEvent.load(scope.leapEventId).then ->
      scope.event = LeapEvent.get()
      scope.category = LeapEvent.category()
      scope.style = scope.category?.styles.bg
      scope.mouseenter = -> scope.style = scope.category?.styles.bgHighlight
      scope.mouseleave = -> scope.style = scope.category?.styles.bg
      scope.delete = -> LeapEvent.delete(scope.leapEventId).then ->
        element = element.find("div")
        element.css("position:relative")
        element.css("opacity","0")
        $timeout (-> element.remove()), 500
      element.addClass(scope.event.eventableType)
    scope.clicked = -> scope.extended = !scope.extended
    scope.$on "cancelEventForm", -> scope.extended = false

.directive 'leapBrick', (LeapEvent) ->
  restrict: "E"
  templateUrl: '/assets/timeline_brick.html'
  scope:
    leapEventId: '='
    showDate: '='
  link: (scope,element,attrs) ->
    scope.extended = false
    LeapEvent.load(scope.leapEventId).then ->
      scope.event = LeapEvent.get()
      scope.category = LeapEvent.category()
      scope.$emit "brickLoaded" unless scope.event.template
    scope.clicked = -> scope.extended = !scope.extended
    scope.$on "cancelEventForm", -> scope.extended = false
    scope.$on "$includeContentLoaded", -> scope.$emit "brickLoaded"

.directive 'leapRegisterEvent', ->
  restrict: "E"
  templateUrl: "/assets/register_event.html"
  link: (scope,element) ->
    edMom = moment(scope.event.timetable_start)
    sodMom = angular.copy(edMom)
    top = edMom.diff(sodMom.startOf('day').add(8,'hours'),'minutes')
    length = moment(scope.event.timetable_end).diff(edMom,'minutes')
    element.css("top", (top + 36) + "px")
    element.find('article').css("height", length + "px")
    element.addClass scope.event.status

.directive 'leapTimetableEvent', (LeapEvent) ->
  restrict: "E"
  templateUrl: '/assets/timetable_event.html'
  scope:
    leapEventId: '='
    showDate: '='
  link: (scope,element,attrs) ->
    LeapEvent.load(scope.leapEventId).then ->
      scope.event = LeapEvent.get()
      scope.category = LeapEvent.category()
      edMom = moment(scope.event.eventDate)
      sodMom = angular.copy(edMom)
      top = edMom.diff(sodMom.startOf('day').add(8,'hours'),'minutes')
      length = moment(scope.event.timetable.endDate).diff(edMom,'minutes')
      element.css("top", (top + 36) + "px")
      element.css("background: " + scope.category.color) if scope.category
      element.find('article').css("height", length + "px")

.directive 'leapChildEvent', (LeapEvent) ->
  restrict: "E"
  templateUrl: '/assets/child_event.html'
  scope:
    leapEventId: '='
  link: (scope) ->
    LeapEvent.load(scope.leapEventId).then ->
      scope.event = LeapEvent.get()
      scope.category = LeapEvent.category()

.directive 'leapTimelineControls', (Timeline,$rootScope,Categories) ->
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
    scope.$on "categorySet", (_e,id) ->
      scope.category = Categories.get(id)
    $rootScope.$on "timelineUpdated", ->
      view = Timeline.getView()
      view.showButton = view.controls.length > 0

.directive 'leapEventForm', ($http,Topic,Timeline,Categories,LeapEvent) ->
  scope:
    templateUrl: '='
    eventType: '='
    parentId: '='
    initCategory: '='
    leapEventId: '='
    action: '@'
  templateUrl: '/assets/event_form.html'
  link: (scope) ->
    scope.newEvent = {}
    if scope.action == "update"
      LeapEvent.load(scope.leapEventId,true).then (ev) -> scope.newEvent = ev
    scope.categories = Categories.getAll()
    scope.cancelForm = -> scope.$emit("cancelEventForm")
    scope.createEvent = ->
      toPost = {eventable_type: scope.eventType }
      toPost[scope.eventType] = scope.newEvent
      if scope.action == "create" or not scope.action?
        $http.post(Topic.urlBase() + "/events.json",toPost).success (data) ->
          Timeline.update()
          scope.$emit("cancelEventForm")
        .error (data) -> scope.errors = data
      else if scope.action == "update"
        $http.put(Topic.urlBase() + "/events/" + scope.leapEventId + ".json",toPost).success (data) ->
          scope.$emit("updateEvent")
          scope.$emit("cancelEventForm")
        .error (data) -> scope.errors = data
    scope.$watch "newEvent.category_id", (n,o) ->
      if n?
        scope.$emit "categorySet", n
        scope.category = Categories.get(n)
    scope.$watch "parentId", (n,o) -> scope.newEvent.parent_id = n
    scope.$watch "initCategory", (cid) -> scope.newEvent.category_id = cid

.directive 'leapTile', ($http,Topic) ->
  restrict: "E"
  templateUrl: '/assets/tile.html'
  scope:
    leapEventId: '='
  link: (scope,element,attrs) ->
    $http.get("#{Topic.urlBase()}/events/#{scope.leapEventId}.json").success (data) ->
      scope.event = data
      scope.eventDate = new Date(scope.event.eventDate)
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
