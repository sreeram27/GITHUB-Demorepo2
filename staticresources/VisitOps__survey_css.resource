@charset "utf-8";
/* CSS Document */
body{ font-size:75%;}
.fl{ float:left}
.fr{ float:right}
.cBoth{ clear:both}
.txtLeft{ text-align:left;}
.txtRight{ text-align:right;}
.txtCenter{ text-align:center;}
.txtBold{ font-weight:bold;}
.txtItalic{ font-style:italic;}
.rightContent a{ color:#155fbe!important; text-decoration:underline;}
.rightContent{ 
	width:100%;
	font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif; 
	font-size:1.250em;
	line-height:18px; 
	color:#2a2d33; 
	padding:28px 0 0 0;
}

.row{display:inline-block; width:100%;}
.colmedium, .colgeneric{ float:left; width:20%; padding-right:7%;}
.colsmall{ float:left; width:10%; padding-right:2%;}
.label{ padding-bottom:10px;}
.field{ padding-bottom:15px;}
.btnfld{ padding-top:5px;}
/*input[type=button]{ font-size:0.917em;}*/

.rightContent select, .rightContent input[type=text], .rightContent textarea{ width:100%; border:1px solid #bdbdbd; height:35px; color:#2a2d33; }
.rightContent input[type=text], .rightContent textarea{ width:92%; padding:0 4%;}
.rightContent textarea{ height:100px; resize:none;}

.btnsDiv{}
.visitSearch .colmedium{ padding-right:2%;}
.visitSearch .field{ padding-bottom:26px;}
.rightContent .readOnly{ background-color:#dbdbdb; color:#87888a;}
.calenderField{ background:url(../images/calenderIcon.png) no-repeat 98% center;}
.searchField{ background:url(../images/searchIcon.png) no-repeat 98% center;}

.ui-widget-content a{color:#155fbe; text-decoration:underline;}
.lftAlign{ margin-left:-65px;}
.lftAlign .field{ padding-top:9px;}
.divTable{ margin-bottom:20px;}
.heading{ color:#f88721; margin-bottom:20px;}

.divTable table{ width:100%; border-collapse: collapse; border:1px solid #f6a963; font-size:0.8em;}
.divTable table td { border-bottom:1px solid #f6a963; padding:5px 0;}
.divTable table th{ color:#FFFFFF; font-weight:normal; background-color:#cc6600; text-align:left; padding:5px 0;}

.divTable table tr td:first-child, .divTable table tr th:first-child{ padding-left:5px;}

.VisitViewForm{ margin:32px 0;}
.VisitViewForm h3{
	background-color:#f8b600;
	color:#000;	
	font-size:1.083em;
	padding:12px 2%;
	display:inline-block;
	width:96%;
	margin-bottom:10px;
}
.visitViewContent{ padding:25px 10px;}
.paginationDiv{ margin-top:15px; overflow:auto;}
.btmSpace{ margin-bottom:40px;}
.colsearch{float:left; width:30%; padding-right:3%;}
.popupTable { border:1px solid #bdbdbd;  margin:25px 0;}
.popupTable table{ width:100%; border-collapse: collapse; font-size:0.8em;}
.popupTable table td { border-bottom:1px solid #ffffff; padding:8px 0;}
.popupTable table th{ color:#FFFFFF; font-weight:normal; background-color:#888887; text-align:left; padding:8px 0; border-bottom:1px solid #ffffff;}
.popupTable table tr td:first-child, .popupTable table tr th:first-child{ padding-left:5px;}

.oddRow{ background-color:#e5e5e5;}
.evenRow{ background-color:#dbdbdb;}

tr.newAddedRow td{ background-color:#fdca9d;}

/**************** Popup Box Styles****************/
.popupBox { 
    display:none; /* Hide the DIV */
    position:fixed;     
    _position:absolute; /* hack for internet explorer 6 */
    height:350px;  
    width:60%;
	overflow:auto;
    background:#FFFFFF;  
    left: 20%;
    top: 15%;
    z-index:100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
    margin-left: 15px;  
    border:1px solid #c5c7c8;      
    padding:27px;  
    -moz-box-shadow: 0 0 5px #dadada;
    -webkit-box-shadow: 0 0 5px #dadada;
    box-shadow: 0 0 5px #dadada;    
	font-size:1.083em;
	color:#292c35;
}
.popupBox input[type=text], .popupBox textarea{ border:1px solid #a2a1a1;}

.radioBoxContainer{ margin-top:18px;}

#NewAcPopup{ width:40%; height:450px;}
.popUpHeading{ color:#cc6600; border-bottom:1px solid #cc6600; padding-bottom:5px; margin-bottom:25px;}
#NewOpportunityPopup { margin-top:23px;}
#NewOpportunityPopup .popUpHeading { margin-bottom:23px;}
#NewAcPopup .colmedium{ width:40%;}
.popupBox .colmerge{ width:87%; float:left; padding-right:7%;}
#NewAcPopup .btnsDiv, #AccountPopupNewAddedRow .btnsDiv, .spacing{ margin-bottom:27px;}
.btmspace{ margin-bottom:5px;}
.popupBox table{ border:none;}
.popupBox .btnsDiv{ margin-bottom:20px;}
.popupBox .colmedium { width:30%;}
.popupBox .colgeneric { width:20%;}
.popupBox .columnRight { text-align:right; float:right;}
.popupSubHeading{ 
	color:#888887;  
	border-bottom: 1px solid #888887;
    font-size: 15px;
    margin-top: 15px;
    padding-bottom: 5px;
	font-weight:bold;
}

#createNewAccountDiv{ display:none; margin:25px 0 0 0;}

#createNewAccountDiv, #AccountDetailsNewRow, #AddObjectivePopup, #AddLogisticPopup, #ContactOpportPopup, #createNewContactDiv, #AttendeeDetailsNewRow, #strategyCallDiv, #attendeesNtAssociatdDiv{ display:none;}

#AddObjectivePopupOpp, #AddObjectivePopupAcc{ width:35%; height:auto; left: 30%; top:25%;}

#ContactOpportPopup .radioBoxContainer{ padding-left:100px;}
.reqField{ border-left: 3px solid red !important;}

/********* radio button*************/
.rightContent input[type=radio]{ width:auto!important;}

.rightContent .radiokboxDiv{
	float:left;
	padding:2px 0 0 0; 
	margin-right:30px;
}
.rightContent input[type=radio].css-radiobox {
 position: absolute; 
  overflow: hidden; 
  clip: rect(0 0 0 0); 
  height:1px; 
  width:1px; 
  margin:-1px; 
  padding:0;
  border:0;
}

.rightContent input[type=radio].css-radiobox + label.css-radiolabel {
  padding-left:22px;
  height:13px; 
  display:inline-block;
  line-height:13px;
  background-repeat:no-repeat;
  background-position: 0 0;
  vertical-align:middle;
  cursor:pointer;
}

.rightContent input[type=radio].css-radiobox:checked + label.css-radiolabel {
  background-position: 0 -16px;
}

.rightContent .css-radiolabel{
  background-image:url(../images/radiobox_img.png);
}

/*************** customised checkbox *****************/
.rightContent input[type=checkbox]{ width:auto!important;}

.rightContent .checkboxDiv{
	float:left;
	padding:2px 0 0 0; 
	margin-right:30px;
}
.rightContent input[type=checkbox].css-checkbox {
 position: absolute; 
  overflow: hidden; 
  clip: rect(0 0 0 0); 
  height:1px; 
  width:1px; 
  margin:-1px; 
  padding:0;
  border:0;
}

.rightContent input[type=checkbox].css-checkbox + label.css-label {
  padding-left:25px;
  height:13px; 
  display:inline-block;
  line-height:13px;
  background-repeat:no-repeat;
  background-position: 0 0;
  vertical-align:middle;
  cursor:pointer;
  font-size:13px;
  font-weight:bold;
}

.rightContent input[type=checkbox].css-checkbox:checked + label.css-label {
  background-position: 0 -15px;
}

.rightContent .css-label{
  background-image:url(../images/checkbox_img.png);
}

.message{ margin:4px 0!important;}
.datePicker select{ height:auto; width:auto;}
.rightContent .btn{ font-weight:normal!important;}
.labelfld{ width:130px; text-align:right; padding-right:5px; float:left; font-size:1.1em;}
.inputWrap{ padding-top:40px; float:left;}
.roomSearchDiv{ padding:10px 0;}
.roomSearchDiv .row { margin-bottom: 5px;}
.roomSearchDiv input[type=text]{ width:145px; padding:0; padding-left:5px;}
.roomSearchDiv select{ width:153px;}
.roomAvailTxt, .roomBookedTxt{ font-weight:bold; font-size:1.1em; padding-bottom:5px;}
.roomAvailTxt{ color:green;}
.roomBookedTxt{ color:#F6531A;}
.addObjectiveAccBtn{ width:120px;}

/********* tooltip **************/

[data-tooltip] {
	position: relative;
	z-index: 2;
	cursor: pointer;
}

/* Hide the tooltip content by default */
[data-tooltip]:before,
[data-tooltip]:after {
  visibility: hidden;
	-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
	filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=0);
	opacity: 0;
	pointer-events: none;
}

/* Position tooltip above the element */
[data-tooltip]:before {
	position: absolute;
	bottom: 150%;
	left: 50%;
	margin-bottom: 5px;
	margin-left: -80px;
	padding: 7px;
	width: 160px;
	-webkit-border-radius: 3px;
	-moz-border-radius:    3px;
	border-radius:         3px;
	background-color: #000;
	background-color: hsla(0, 0%, 20%, 0.9);
	color: #fff;
	content: attr(data-tooltip);
	text-align: center;
	font-size: 14px;
	line-height: 1.2;
}

/* Triangle hack to make tooltip look like a speech bubble */
[data-tooltip]:after {
	position: absolute;
	bottom: 150%;
	left: 50%;
	margin-left: -5px;
	width: 0;
	border-top: 5px solid #000;
	border-top: 5px solid hsla(0, 0%, 20%, 0.9);
	border-right: 5px solid transparent;
	border-left: 5px solid transparent;
	content: " ";
	font-size: 0;
	line-height: 0;
}

/* Show tooltip content on hover */
[data-tooltip]:hover:before,
[data-tooltip]:hover:after {
	visibility: visible;
	-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=100)";
		filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=100);
	opacity: 1;
}

/************ pagination ****************/

ul.pagination {
margin: 4px 0;
padding: 0px;
height: 100%;
overflow: hidden;
list-style-type: none;
}

ul.pagination li {
float: left;
margin: 0px;
padding: 0px;
margin-left: 5px;
}

ul.pagination li:first-child {
margin-left: 0px;
}

ul.pagination li a {
display: block;
color: #424242!important;
text-decoration: none;
border: solid 1px #B6B6B6;
padding: 6px 9px 6px 9px;
border-radius:3px;
background: #efefef; /* Old browsers */
	background: -moz-linear-gradient(top, #efefef 0%, #bbbbbb 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#efefef), color-stop(100%,#bbbbbb)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #efefef 0%,#bbbbbb 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #efefef 0%,#bbbbbb 100%); /* Opera11.10+ */
	background: -ms-linear-gradient(top, #efefef 0%,#bbbbbb 100%); /* IE10+ */
	background: linear-gradient(top, #efefef 0%,#bbbbbb 100%); /* W3C */
}

ul.pagination li a:hover {
	text-decoration: none;
	background:#969494;
	background: #bbbbbb; /* Old browsers */
	background: -moz-linear-gradient(top, #bbbbbb 0%, #efefef 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#bbbbbb), color-stop(100%,#efefef)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #bbbbbb 0%,#efefef 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #bbbbbb 0%,#efefef 100%); /* Opera11.10+ */
	background: -ms-linear-gradient(top, #bbbbbb 0%,#efefef 100%); /* IE10+ */
	background: linear-gradient(top, #bbbbbb 0%,#efefef 100%); /* W3C */
}

ul.pagination li a.current {
	background: #174579;
	color: #ffffff!important;
	border-color: #174579;
	background:#4F4F4F;
	cursor: default;
}

ul.pagination li a.disabled {
	cursor: default;
	background:none;
	color: #424242!important;	
}
.btnCenter{ text-align:center;} 
.btnCenter .btn{ margin-right:0.5%;}
/*********** agenda css ****************/

.mainContent{ width:95%;}
.midCol{ float:left; width:46%; margin-right:8%;}
.largeCol{ float:left; width:46%;}
.sectionHeading{ border-bottom:1px solid #f2a331; padding-bottom:6px; margin:40px 0 25px 0;}
.timeIcon{ 
	background:url(../images/sprite.png) no-repeat -2px -2px;
	width:19px; 
	height:19px; 
	display:inline-block;
	margin-right:12px;
	float:left;
}
.locationIcon{ 
	background:url(../images/sprite.png) no-repeat -68px -2px;
	width:13px; 
	height:19px; 
	display:inline-block;
	margin-right:12px;
	float:left;
}
.activityIcon{ 
	background:url(../images/sprite.png) no-repeat -24px -2px;
	width:20px; 
	height:19px; 
	display:inline-block;
	margin-right:12px;
	float:left;
}
.cateringIcon{
	background:url(../images/sprite.png) no-repeat -46px -2px;
	width:19px; 
	height:19px; 
	display:inline-block;
	margin-right:12px;
	float:left;
}
.objectiveIcon{
	background:url(../images/sprite.png) no-repeat -84px -2px;
	width:17px; 
	height:14px; 
	display:inline-block;
	margin:3px 12px 0 0;
	float:left;
}
.presenterIcon{
	background:url(../images/sprite.png) no-repeat -104px -2px;
	width:16px; 
	height:20px; 
	display:inline-block;
	margin-right:12px;
	float:left;
}
.midCol input[type=text]{ width:40%; padding:0 2%;}
.midCol select{ width:44.2%; margin-right:5%;}
.largeCol input[type=text]{ width:35%; margin-right:5%;  padding:0 2%;}
.largeCol select{ width:39.8%; margin-right:5%;}

.largeCol .colmedium { width:40%;}
.largeCol .colmedium input[type=text], .largeCol .colmedium select { width:100%;}
.rightContent .largeCol textarea { height:82px;}
.rightContent .largeCol textarea.midtextarea{ width:60%; height:50px;}
.rightContent .midCol textarea.largetextarea{ height:147px;}
.agenda .mainContent .divTable{ margin-top:35px;}
.presenterTb table td { width:16%;}
.presenterTb input[type=text]{ width:55%; height:25px; float:left;}
.divTable.presenterTb input[type="checkbox"]{ margin-top: 8px;}
.leftContent{ float:left; width:17%; margin-right:1%; padding:2%;}
.leftContent .btnsDiv{ margin-bottom:20px;}
.leftContent .label{ font-weight:bold;}
.leftContent select{ width:100%; border:1px solid #bdbdbd; height:35px; color:#797979; }
.agendaHeading{
	background-color: #f8b600;
    color: #000;
	font-size:1.083em;
	padding:12px 2%;
	display:inline-block;
	width:92%;
	margin-top:15px;
}
.subheading{
	background-color:#ef7800;
	padding:5px;
	color:#ffffff;	
	font-size:1em;
	margin: 5px 0;
	display:block;
}

.calendarViewDiv{ float:left;width:75%;height:100%; padding:2% 0;}
.multipleOption{ border:1px solid #bdbdbd; color:#797979; padding:5%;}
.multipleOption ul{ list-style:none; margin:0; padding:0;}
.multipleOption ul li{ list-style:none; margin-bottom:5px;}
.multipleOption ul li:last-child{margin-bottom:0;}


/**************** survey CSS *********************/
.screenHeading{ color:#4d4d4d; font-size:1.3em; border-bottom:1px solid #c9c9c9; padding-bottom:8px; margin-bottom:18px; font-family:Gotham, "Helvetica Neue", Helvetica, Arial, sans-serif;}
.msgText{ color:#f2a331; font-size:16px;}
.surveyDetails{ margin-top:20px; width:30%; margin-bottom:40px;}
.surveyDetails .row{ border-bottom:1px solid #d8d8d8; padding:10px 0;}
.surveyDetails .row:last-child{border-bottom:none;}
.labelText{ float:left; padding-left:5px; color:#4d4d4d; margin-right:5%; width:42%;}
.fieldText{ float:left; color:#898989;}
.surveyQuestions{ margin:0; padding:0; padding-left:10px;}

.surveyQuestions li{ margin-bottom:28px;}
.rowDiv{ margin-bottom:18px;}
.questions{ margin-bottom:25px; font-weight:600;}
.surveyQuestions select{ width:20%;}
.surveyQuestions textarea, .sessionContent textarea{ width:35%; padding:0.5%; font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif;}
.surveyQuestions .txtItalic{ padding-bottom:10px;}

.ratings{ width:60%;}
.ratingTxt{ color:#a8a8a8; font-size:0.8em; padding-top:5px; float:left;}
.likelyDiv{ float:left;  padding-left:1%;}
.ntlikelyDiv{ float:right; padding-right:40.5%;}
.likelyIcon{
	background:url(../images/smiley.png) no-repeat 0 0;
	width:26px; 
	height:26px; 
	display:inline-block;
	margin-right:12px;
	float:left;
}
.ntlikelyIcon{
	background:url(../images/smiley.png) no-repeat -30px 0;
	width:26px; 
	height:26px; 
	display:inline-block;
	margin-left:12px;
	float:left;
}
.ratingCount{ margin-top:15px;} 
.ratingCount span{ display:inline-block; width:5%; text-align:center;}
.ratingCount input[type=radio]{ padding:0; margin:0;}
.btnBorder{ border-bottom:1px solid #c0c0c0; padding:2px 0;}

.agSession{ margin-top:35px;}
.agendaSessionDiv{ background-color:#fcedd6; padding:1% 2%; margin-bottom:40px;}
.noBorder{ border:none;}
.sessionHeading{ background-color:#f2a331; color:#FFFFFF; padding:5px 2%; font-weight:bold;}
.sessionContent{ padding:2% 15% 2% 2%; overflow:hidden;}
.sessionContent .questions{  margin-bottom:15px;  font-weight:normal!important;}
.sessionContent select{ width:20%;}
.sessionContent textarea{ width:85%; }