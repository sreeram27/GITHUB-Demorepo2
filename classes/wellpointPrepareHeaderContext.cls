public with sharing class wellpointPrepareHeaderContext {
  public static wellpointComEsbContext.ContextType prepareHeaderContextObject() 
   {
     wellpointComEsbContext.ContextType headerctx = new wellpointComEsbContext.ContextType();
     wellpointComEsbContext.Security_element security = new wellpointComEsbContext.Security_element();
     wellpointComEsbContext.UsernameTokenType usernameToken = new wellpointComEsbContext.UsernameTokenType();
     
     wellpointComEsbContext.CtxProps_element ctxProps = new wellpointComEsbContext.CtxProps_element();
     wellpointComEsbContext.PropertyType[] property = new wellpointComEsbContext.PropertyType[1];
     ctxProps.Property = property;
     property[0] = new wellpointComEsbContext.PropertyType();
     property[0].name = 'ContextProp';
     property[0].name = 'ContextPropValue';
     ctxProps.Property = property;
     headerctx.Security = security;
     headerctx.CtxProps = ctxProps;
     headerctx.domainName = 'Salesfoece';
     headerctx.srvcName = 'UtilityService';
     headerctx.srvcVersion= '1.01';
     headerctx.operName ='SubmitFIRSTQuote';
     headerctx.operVersion= '1.1';
     headerctx.senderApp = 'SFDC';
     headerctx.clientReqId = 'REQ1.1';
     headerctx.transId = 'TRN2.1';
     headerctx.esbReqId = 'ESTREQID1.2';
     headerctx.msgTyp='MSG1.1';
     security.UsernameToken = usernameToken; 
    usernameToken.username = 'SFD1USER';
    usernameToken.password = 'UNKNOWN';
    usernameToken.passwordType = 'CLEARTEXT';
    return headerctx;
  }
}