.tabs {
  background: #F8F8F8 !important;
  border-top: 1px solid #EEE;
  border-bottom: 1px solid #CCC;
  box-shadow: inset -1px -1px 5px #eeeeee;
  clear: both;
  height: 26px;
  min-width: 500px;
  width: 100%; }

.tabs ul {
  font-weight: bold;
  border-bottom: 0px solid #F8F8F8;
  border-top: 1px solid #FFF;
  border-right: 1px solid #FFF;
  float: left;
  list-style-type: none;
  margin: 0 0 0 15px;
  padding: 0px 0px 0px 0px; }

.tabs ul li {
  border-left: 1px solid #FFF;
  display: block;
  margin-left: 0;
  padding-left: 0;
  float: left; }

.tabs ul li:first-child {
  border-left: 1px solid #F8F8F8; }

.tabs ul li a {
  -webkit-transition: all .2s ease-in-out;
  -moz-transition: all .2s ease-in-out;
  -ms-transition: all .2s ease-in-out;
  transition: all .2s ease-in-out;
  background-color: #EEE;
  border-top: 3px solid #DDD;
  color: #888 !important;
  display: block;
  font-size: 12px;
  line-height: 15px;
  min-width: 60px;
  margin: -2px 0 0 0;
  padding: 4px 15px;
  text-align: center;
  text-decoration: none;
  text-shadow: 0px 1px 0px #FFFFFF; }

.tabs ul a:hover, .tabs ul a.hover {
  -webkit-transition: all .2s ease-out;
  -moz-transition: all .2s ease-out;
  transition: all .2s ease-out;
  color: #454545;
  border-top: 3px solid #AAA;
  text-decoration: none !important; }

.tabs li a.selected_tab {
  -webkit-transition: none;
  -moz-transition: none;
  -ms-transition: none;
  transition: none;
  background-color: #fff;
  border-top: 3px solid #00b3e9;
  border-bottom: 1px solid #fff;
  border-left: 1px solid #CCC;
  border-right: 1px solid #CCC;
  color: #454545 !important;
  cursor: default;
  margin-bottom: -3px;
  padding-bottom: 5px; }

.tabs li a.selected_tab {
  padding-bottom: 6px; }