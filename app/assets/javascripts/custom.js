function isSilverlightInstalled(){
 var isSilverlightInstalled = false;
    try{
     //check on IE
     try{
         var slControl = new ActiveXObject('AgControl.AgControl');
         isSilverlightInstalled = true;
     }
     catch (e){
         //either not installed or not IE. Check Firefox
         if ( navigator.plugins["Silverlight Plug-In"] ){
             isSilverlightInstalled = true;
         }
     }
 }
 catch (e){
     //we don’t want to leak exceptions. However, you may want
     //to add exception tracking code here.
 }
 return isSilverlightInstalled;
}
;
window.onload = function() {
    if (isSilverlightInstalled() == false){
      var ebs = document.getElementsByClassName('slchk');
      var no_silverlight_msg = 'Please note that your browser currently is not compatible with SPARKE (EBS Reports); therefore if you would like to make use of the EBS link you will need to ensure you are using Leap with Internet Explorer (IE).\n\nWe are currently investigating compatibility for your browser with SPARKE for future developments.';
        for (var i = 0; i < ebs.length; ++i) {
            ebs[i].setAttribute('readonly', 'readonly');
            ebs[i].onclick=function(){
              alert(no_silverlight_msg);
              return false;
            }
        }
    }
}
;

/**
 * Ruby already truncates aspirations > 255 characters
 * 
 * This script prevents users from entering more than 255 in the first place 
 * and counts down from 255 to 0
 *
 */
$(function(){
	$(window).load(function() {
		var max = 255;
		$('#aspiration_aspiration').on('keypress keyup', function(e){
			var chars_remaining = 255 - $('#aspiration_aspiration').val().length;
			if (chars_remaining >= 0) {
				$('#chars').html(chars_remaining);
			}           
			if (this.value.length == max) {
					e.preventDefault();
			} else if (this.value.length > max) {
					this.value = this.value.substring(0, max);
			}
		});
	});
});