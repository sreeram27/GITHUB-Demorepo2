ul#ISConfigureStageList
{
    padding: 0px 40px 0px 40px;
    margin-bottom: 20px;
}

#ISConfigureStageList
{
    height:auto;
    max-height:500px;
    overflow-y:auto;
    -webkit-column-count:2;
    -moz-column-count:2;
    column-count:2;
}

#ISConfigureStageList li
{
    display:table;
    clear:both;
    list-style-type:none;
    background-color:#f1f1f1;
    border:1px solid #e3e3e3;
    min-height:23px;
    margin:0px 15px 10px 0px
}

#ISConfigureStageList .is_enabled
{
    width:auto;
    float:left;
    padding-top: 2px;
}

#ISConfigureStageList .stage_name
{
    width:auto;
    float:left;
    font-size:14px;
    font-weight:700;
    line-height:22px;
    padding-right:5px
}

#button-grid
{
    border-top: medium solid #B6B6B6;
    background-color: #DADADA;
    height: 40px;
    width: auto;
    padding: 0px 10px 10px 10px;
}

.send_button
{
    -webkit-transition:opacity .4s ease-in-out;
    -moz-transition:opacity .4s ease-in-out;
    font-family: "Helvetica Neue", Arial, Helvetica;
    font-size: 12px;
    font-weight: bold;
    margin: 5px;
    max-width: 200px;
    padding: 5px 10px 3px 10px;
}

.send_button.reset
{
    color:#FFF;
    text-shadow:0 1px #902E2E;
    background:#e96955;
    background-color:#e96955;
    background-image:-webkit-gradient(linear,center top,center bottom,from(#e96955),to(#E92E2E));
    background-image:-moz-linear-gradient(top,#e96955 33%,#E92E2E);
    box-shadow:inset 0 1px 0 #FF9E9E,0 1px 0 #EEE;
    border:1px solid #BB4C4C;
    border-bottom-color:#921515;
    float:left;
    opacity:1
}

.send_button.reset:active
{
    background-image:-webkit-gradient(linear,center top,center bottom,from(#E92E2E),to(#EB6565));
    background-image:-moz-linear-gradient(top,#E92E2E 33%,#EB6565)
}

.send_button.submit:active
{
    background-image:-webkit-gradient(linear,center top,center bottom,from(#00B3E9),to(#0260EE));
    background-image:-moz-linear-gradient(top,#00B3E9 33%,#0260EE)
}

.send_button.submit
{
    background: #0154D1;
    background-color: #0154D1;
    background-image: -webkit-gradient(linear, center top, center bottom, from(#0154D1), to(#003C96));
    background-image: -moz-linear-gradient(top, #0154D1 33%, #46a51c);
    box-shadow: inset 0px 1px 0px #97e474, 0px 1px 1px #EEE;
    border: 1px solid #003C96;
    border-bottom-color: #003C96;
    color: #FFF;
    float: right;
    text-shadow: 0px 1px #206003;
}