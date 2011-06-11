/*! encryptionHelpers 
*
* A javascript file containing helper methods relating to encryption
*/
var encryptionHelpers ={

	unencrypt:function(encryptedText) {
	  return GibberishAES.dec(encryptedText,localStorage.pwd);
        },
	
	unencryptAll:function(encryptedArray) {
	var unencryptedArray=new Array(); 
	for(var i=0; i < encryptedArray.length; i++){
		unencryptedArray[i]=GibberishAES.dec(encryptedArray[i],localStorage.pwd);
	}
	return unencryptedArray;
   }


	
}
