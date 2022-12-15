function eimzaLib() {


    var host = "https://localhost";
    var port1 = '10281';
    var port2 = '10282';
    var port3 = '10283';
    var port4 = '58676';

    var baseUrl = host + ':' + port1 + '/';

    var service = {
        isSigningServiceWorking: isSigningServiceWorking,
        readCertificates: readCertificates,
        signDocuments: signDocuments,
        signLocalFiles: signLocalFiles,
        verifyEdoc: verifyEdoc,
        getProgress: getProgress,
        checkEdoc: checkEdoc
    };

    return service;

    //////////////////////////////////


    function isSigningServiceWorking() {
        var deferred = $.Deferred();
        var tryout = 1;
        getVersion(deferred, tryout);

        return deferred.promise();
    }

    function getVersion(dfd, tryout) {
        $.ajax({
            url: baseUrl + 'api/sign/version',
            type: 'get',
            success: function (data) {
                if (data.productNumber === '54ca98f4-91c1-4e9a-9b3b-f28ed6f4b996') {
                    dfd.resolve();
                }
                else {
                    dfd.reject();
                }
            },
            error: function (err) {
                if (tryout === 1) {
                    tryout = tryout + 1;
                    baseUrl = host + ':' + port2 + '/';
                    getVersion(dfd, tryout);
                }
                else if (tryout === 2) {
                    tryout = tryout + 1;
                    baseUrl = host + ':' + port3 + '/';
                    getVersion(dfd, tryout);
                }
                else {
                    dfd.reject();
                }

            }
        });
    }

    /**
     * Reads certificates from the smart card first.
     * If exist, then read the corresponding certificates from Windows Certificate Store which has private key.
     * If failed to get the certificates from the Smart Card or the Store, then error with errorDetils will return.
     *
     * @return {object} if success then return error code = 0. Otherwise error code > 0 and error detials already localized.
     *      {
     *          {array} certificates:   [
     *                                      {
     *                                          {string} serialNumber
     *                                          {string} subject
     *                                      }
     *                                  ]
     *
     *          {number} errorCode
     *          {string} errorDetails
     *      }
     */
    function readCertificates() {
        var promise = $.get(baseUrl + 'api/sign/certificates');
        return promise;
    }

    /**
     * This method receive the file from web service by it fileId. Create Edoc file, and sign the edoc.
     * The web service will pop up a pin view in order to sign the document.
     * This method must be executed after 'readCertificates' method!! Otherwise it will raise exception.
     * Only signle signing process can be executed at the same time. For this reason, if this method will be executed again during signing process,
     * the method will return errorCode = 6 ( Digital Signature is in Process).
     * During the signing process, the status of the signing process will be updated and will be reachable via 'getProgress' method (see documentation).
     *
     * @param {string} certSerialNumber - serial number of authentication certificate which will sign the document
     * @param {string} wsUrl - url of the web service where the online imza will get the file for signing process.
     * @param {string} fileId - the id of the file which will be passed to the web service in order to receive the correct file for the signing process.
     *
     * @return {object} if success then return error code = 0. Otherwise error code > 0 and error detials already localized.
     *      {
     *          {object} edocFile:{
     *                                {string} fileID     - the original file id which was passed to sign document
     *                                {string} fileName   - auto generated file name with .edoc extension
     *                                {byte[]} rawData    - file content as byte[].
     *                            }
     *
     *          {number} errorCode
     *          {string} errorDetails
     *      }
     */
    function signDocuments(certSerialNumber, wsUrl, fileId) {
        var data = {
            certificateSerialNumber: certSerialNumber,
            url: wsUrl,
            fileIDs: [fileId]
        };
        var promise = $.post(baseUrl + 'api/sign/remotely', data);
        return promise;
    }

    /** NOTE: NOT READY YET, DON'T USE
     * The method receives the temporary url links to specific file in the local system amd file's name
     * (because from browser there is no way to determine the full path of the file via javascript and <input type="file" />).
     * The service will download the files, sign them and return Edoc file if the process finished successfully.
     *
     * @param {string} edocDest - valid destination path (in local system) where singed Edoc will be saved to
     * @param {string} files - array of files which will be signed. Every file has to contain file temporary url and file name
     *                          (because from browser there is no way to determine the full path of the file via javascript and <input type="file" />).
     *                          [
     *                              {
     *                                  {string} url - temporary url of local file
     *                                  {string} name - the name of the file
     *                              }
     *                          ]
     *
     *
     * @return {object} if success then return error code = 0. Otherwise error code > 0 and error detials already localized.
     *      {
     *          {string} edocFileName - Successfully signed edoc full path
     *
     *          {number} errorCode
     *          {string} errorDetails
     *      }
     */

    //var ajax=function(){
    //    try{
    //      var xml       =new XMLHttpRequest();
    //      var args      =arguments;
    //      var context   =this;
    //      var multipart ="";

    //      xml.open(args[0].method,args[0].url,true);

    //      if(args[0].method.search(/post/i)!=-1){
    //        var boundary=Math.random().toString().substr(2);
    //        xml.setRequestHeader("content-type",
    //                    "multipart/form-data; charset=utf-8; boundary=" + boundary);
    //        for(var key in args[0].data){
    //          multipart += "--" + boundary
    //                     + "\r\nContent-Disposition: form-data; name=" + key
    //                     + "\r\nContent-type: application/octet-stream"
    //                     + "\r\n\r\n" + args[0].data[key] + "\r\n";
    //        }
    //        multipart += "--"+boundary+"--\r\n";
    //      }

    //      xml.onreadystatechange=function(){
    //        try{
    //          if(xml.readyState==4){
    //            context.txt=xml.responseText;
    //            context.xml=xml.responseXML;
    //            args[0].callback();
    //          }
    //        }
    //        catch(e){}
    //      }

    //      xml.send(multipart);
    //    }
    //    catch(e){}
    //  }

    function signLocalFiles(formData) {

        //var promise = $.post('http://localhost:10281/api/sign/localy', data);
        //console.log(formData.entries());
        //var json = JSON.stringify({ input: formData.entries() });
        //console.log(formData);

        // var promise = $.ajax({
        //     type: "POST",
        //     url: baseUrl + "api/sign/localy",
        //     data: formData,
        //     processData: false,
        //     contentType: false,
        //     cache: false,
        //     timeout: 600000
        // });
        // return promise;

        return $.ajax({
            type: "POST",
            url: baseUrl + "api/sign/localy",
            contentType: false,
            processData: false,
            data: formData,
            success: function (result) {
                console.log(result);
            },
            error: function (xhr, status, p3, p4) {
                var err = "Error " + " " + status + " " + p3 + " " + p4;
                if (xhr.responseText && xhr.responseText[0] === "{")
                    err = JSON.parse(xhr.responseText).Message;
                console.log(err);
            }
        });
    }

    /**
     * During the signing process, the process will update the status.
     * The status is reachable via this 'getProgress' method.
     * The method returns the percentage and the state in which the signing process at.
     *
     * @return {object} if success then return error code = 0. Otherwise error code > 0 and error detials already localized.
     *      {
     *          {object} progress:{
     *                                {number} percentage   - the % of digital signature process
     *                                {string} state        - localized text which reprecent in which step the signing process is at that moment.
     *                                {bool}   status       - signing process failed (false) / otherwise (true)
     *                            }
     *
     *          {number} errorCode
     *          {string} errorDetails
     *      }
     */
    function getProgress() {
        var promise = $.get(baseUrl + 'api/sign/status');
        return promise;
    }

    /**
     * Load the edoc from local system and verifies it.
     * Returns verification result xml which represents all the validations and their statuses.
     * The edoc file has to exist in the specified 'edocFilePath', otherwise the mehtod will return error.
     *
     * @param {string} edocFilePath - the full path of edoc file which will be verified
     *
     * @return {object} if success then return error code = 0. Otherwise error code > 0 and error detials already localized.
     *      {
     *          {string} validationResultXml - one xml string which contains all the verifications and their failing reasons if exist.
     *
     *          {number} errorCode
     *          {string} errorDetails
     *      }
     */
    function verifyEdoc(edocFilePath) {
        var data = {
            edocFilePath: edocFilePath
        };

        var promise = $.post(baseUrl + 'api/sign/verify', data);
        return promise;
    }

    //function checkEdoc(edocFile) {
    //    alert();
    //    var promise = $.post(baseUrl + 'api/sign/checkedoc', edocFile);
    //    console.log('gelen data' + promise);
    //    return promise;
    //}

    function checkEdoc(rowData, fileName) {
        var data = {
            rawData: rowData,
            fileName: fileName
        };

        return $.ajax({
            type: "POST",
            url: baseUrl + "api/sign/checkedoc",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify(data),
            success: function (result) {
                console.log(result);
            },
            error: function (xhr, status, p3, p4) {
                var err = "Error " + " " + status + " " + p3 + " " + p4;
                if (xhr.responseText && xhr.responseText[0] === "{")
                    err = JSON.parse(xhr.responseText).Message;
                console.log(err);
            }
        });
    }
}
