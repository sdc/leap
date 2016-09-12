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
if (isSilverlightInstalled() == false){
  $('a[href*="ebs4agent"]').click(function(){
    $(this).attr('readonly', 'readonly');
    alert('Please note that your browser currently is not compatible with SPARKE (EBS Reports); therefore if you would like to make use of the EBS link you will need to ensure you are using the Staff Pages with Internet Explorer (IE).\n\nWe are currently investigating compatibility for your browser with SPARKE for future developments.');
    return false;
  });
}