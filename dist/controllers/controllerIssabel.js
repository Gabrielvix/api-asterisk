"use strict";var _search_recording=require("../service/search_recording");class ControllerIssabel{async AuthenticateAndDownload(a,b){try{await(0,_search_recording.authenticateAndDownloadRecording)(a,b);// res.setHeader('Content-Disposition', `attachment; filename=${data?.filename ? data?.filename : ''}`);
// res.setHeader('Content-Type', 'audio/wav');
// res.send(result);
}catch(a){console.error("Error:",a.message),b.status(500).json({error:a.message})}}}module.exports=new ControllerIssabel;