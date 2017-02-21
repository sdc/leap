// I've separated this out with vanilla so we can use this cross application
// It's better than alert() for both user experience and browser compatibility
// Not using constants for ie support - JB

var NOTIFY_TYPES = {
    success: {
        clss: "success",
        dismissible: true
    },
    
    info: {
        clss: "info",
        dismissible: false
    },
    
    error: {
        clss: "danger",
        dismissible: true
    },
    
    warning: {
        clss: "warning",
        dismissible: true
    }
}

var DISMISS_BUTTON = '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>';

function notify(text, type) 
{
    if (!NOTIFY_TYPES.hasOwnProperty(type)) {
        console.log("Unknown type " + type);
        return false;
    }
    
    var notification = document.createElement("div");
    notification.className = 'alert alert-' + NOTIFY_TYPES[type]['clss'];

    if (NOTIFY_TYPES[type]['dismissible']) {
        notification.className += " alert-dismissible";
        notification.innerHTML = DISMISS_BUTTON;
    }
    
    notification.innerHTML += text;
    document.body.insertBefore(notification, document.body.firstChild);
    window.scrollTo(0, 0);
}
