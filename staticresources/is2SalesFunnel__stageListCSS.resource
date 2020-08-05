ul#ISConfigureStageList {
  padding-left: 0px;
}

@keyframes open_flash {
  0%   {border-color: #FFC23E; background-color: #FFF6E0;}
  100% {border-color: #e3e3e3; background-color: #FAFAFA;}
}

@-webkit-keyframes open_flash {
  0%   {border-color: #FFC23E; background-color: #FFF6E0;}
  100% {border-color: #e3e3e3; background-color: #FAFAFA;}
}

@keyframes closed_won_flash {
  0%   {border-color: #8981CF; background-color: #EFE8FF;}
  100% {border-color: #ffffff; background-color: #FAFAFA;}
}

@-webkit-keyframes closed_won_flash {
  0%   {border-color: #8981CF; background-color: #EFE8FF;}
  100% {border-color: #ffffff; background-color: #FAFAFA;}
}

@keyframes closed_lost_flash {
  0%   {border-color: #84E2CD; background-color: #E1F5EC;}
  100% {border-color: #ffffff; background-color: #FAFAFA;}
}

@-webkit-keyframes closed_lost_flash {
  0%   {border-color: #84E2CD; background-color: #E1F5EC;}
  100% {border-color: #ffffff; background-color: #FAFAFA;}
}

.open_flash {
  animation: open_flash 3s;
  -webkit-animation: open_flash 3s;
}

.closed_won_flash {
  animation: closed_won_flash 3s;
  -webkit-animation: closed_won_flash 3s;
}

.closed_lost_flash {
  animation: closed_lost_flash 3s;
  -webkit-animation: closed_lost_flash 3s;
}

#ISConfigureStageList {
  height: 400px;
  overflow-y: auto;
}

#ISConfigureStageList li {
  margin-left: 0px;
  clear: both;
  list-style-type: none;
  background-color: #fafafa;
  border: 1px solid #e3e3e3;
  min-height: 23px;
}

#ISConfigureSTageList .placeholder {
  background-color: #fff;
  border: 0px;
}

#ISConfigureStageList .stage_name {
  width: 350px;
  float: left;
  font-size: 14px;
  line-height: 22px;
}

#ISConfigureStageList .is_enabled {
  float: left;
}

#ISConfigureStageList .stage_type_wrap {
  float: right;
}

#ISConfigureStageList .stage_button {
  line-height: 21px;
  background: #EEE;
  border: 1px solid #CCC;
  border-radius: 2px;
  -webkit-border-radius: 2px;
  -moz-border-radius: 2px;
  box-shadow: inset 1px 1px 0px #f4f4f4, inset -1px -1px 0px #f4f4f4;
  color: #333;
  cursor: pointer;
  display: inline-block;
  font-size: 11px;
  font-weight: normal;
  margin: 0 0 4px 5px;
  padding: 0 6px;
  text-decoration: none;
  white-space: nowrap; 
}

#ISConfigureStageList .stage_button:hover {
  -webkit-transition: background-color 0.1s ease-in;
  -moz-transition: background-color 0.1s ease-in;
  transition: background-color 0.1s ease-in;
  background: #E4E4E4;
  box-shadow: none;
  cursor: pointer;
}

#ISConfigureStageList .stage_button.selected.open {
  -webkit-transition: background-color 0.1s ease-in;
  -moz-transition: background-color 0.1s ease-in;
  transition: background-color 0.1s ease-in;
  background: #FFC23E;
  border-color: #AF8519;
  box-shadow: inset 0px 1px 0px #FFF;
  color: #292304 !important;
  text-shadow: 0px 1px 0px #FFF;
}

#ISConfigureStageList .stage_button.selected.closed_won {
  -webkit-transition: background-color 0.1s ease-in;
  -moz-transition: background-color 0.1s ease-in;
  transition: background-color 0.1s ease-in;
  background: #9E97DA;
  border-color: #4C3BCA;
  box-shadow: inset 0px 1px 0px #FFF;
  color: #0B0520 !important;
  text-shadow: 0px 1px 0px rgba(255,255,255,.4);
}

#ISConfigureStageList .stage_button.selected.closed_lost {
  -webkit-transition: background-color 0.1s ease-in;
  -moz-transition: background-color 0.1s ease-in;
  transition: background-color 0.1s ease-in;
  background: #84E2CD;
  border-color: #2fa9c0;
  box-shadow: inset 0px 1px 0px #FFF;
  color: #202928 !important;
  text-shadow: 0px 1px 0px rgba(255,255,255,.4);
}

#ISConfigureStageList .type_header {
  font-weight: bold;
  font-size: 16px;
  margin: 8px 0px;
}

#ISConfigureStageList .stage_type {
  float: left;
  text-align: center;
}

#ISConfigureStageList .empty_type {
  font-style: italic;
  margin-left: 6px;
  color: #787878;
}

#error_msg {
  width: 100%;
  text-align: right;
  font-weight: bold;
  color: #EE3B3B;
}

.send_button {
  -webkit-transition: opacity .4s ease-in-out;
  -moz-transition: opacity .4s ease-in-out;
  display: block;
  height: 25px;
  line-height: 12px;
  margin: 10px 0 0 6px;
}

.send_button.reset {
  color: #FFF;
  text-shadow: 0px 1px #902E2E; 
  background: #e96955;
  background-color: #e96955;
  background-image: -webkit-gradient(linear, center top, center bottom, from(#e96955), to(#E92E2E));
  background-image: -moz-linear-gradient(top, #e96955 33%, #E92E2E);
  box-shadow: inset 0px 1px 0px #FF9E9E, 0px 1px 0px #EEE;
  border: 1px solid #BB4C4C;
  border-bottom-color: #921515;
  float: left;
  opacity: 1 !important;
}

.send_button.reset:active {
  background-image: -webkit-gradient(linear, center top, center bottom, from(#E92E2E), to(#EB6565));
  background-image: -moz-linear-gradient(top, #E92E2E 33%, #EB6565);
}

.send_button.submit:active {
  background-image: -webkit-gradient(linear, center top, center bottom, from(#4bad20), to(#66c33c));
  background-image: -moz-linear-gradient(top, #4bad20 33%, #66c33c);
} 

.send_button.submit {
  color: #FFF;
  text-shadow: 0px 1px #4b902e; 
  background: #66c33c;
  background-color: #66c33c;
  background-image: -webkit-gradient(linear, center top, center bottom, from(#66c33c), to(#4bad20));
  background-image: -moz-linear-gradient(top, #66c33c 33%, #4bad20);
  box-shadow: inset 0px 1px 0px #97e474, 0px 1px 0px #EEE;
  border: 1px solid #52a42d;
  border-bottom-color: #3b9215;
  float: right; 
}

.send_button.send_cancel {
  color: #000;
  float: right; 
}