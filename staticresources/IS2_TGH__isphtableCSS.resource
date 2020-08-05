div#blist
{
    clear:both
}

table.blist
{
    display:table;
    color:#454545;
    table-layout:fixed;
    border-spacing:0;
    margin:10px 0 0;
    padding:0;
    width:100%;
    display:inline-table;
    font-size: 110%;
}

table.blist a
{
    color:#148cb2
}

table.blist tr.tableHeader th
{
    box-shadow:inset 0 1px 0 0 #FFF;
    background-color:#DADADA;
    background:-ms-linear-gradient(top,#f4f4f4 0%,#dadada 100%);
    background-repeat:repeat-x;
    background-image:-moz-linear-gradient(top,#F4F4F4 48%,#DADADA);
    background-image:-webkit-gradient(linear,left bottom,left top,color-stop(0,#DADADA),color-stop(1,#F4F4F4));
    border-bottom:1px solid #BBB;
    border-top:1px solid #DDD;
    color:#444;
    padding:8px 8px 7px 8px;
    text-shadow:0 1px 1px #FFF;
    text-align:right;
    white-space: normal;
}

table.blist tr.tableHeader th.first
{
    -webkit-border-top-left-radius:3px;
    -moz-border-radius-topleft:3px;
    border-left:1px solid #CCC;
    border-top-left-radius:3px;
    padding-left:8px;
    text-align:left
}

table.blist tr.tableHeader th.default.first a {
    text-align: left;
}

table.blist tr.tableHeader th.last
{
    -webkit-border-top-right-radius:3px;
    -moz-border-radius-topright:3px;
    border-right:1px solid #CCC;
    border-top-right-radius:3px;
    padding-right:8px;
    text-align:right
}

table.blist tr.tableHeader th a
{
    color:#444!important;
    display:table-cell;
    text-align:right;
    display:inline-table;
    width: 100%;
}

table.blist tr.tableHeader th a:hover
{
    color:#888
}

table.blist td,table.blist th
{
    cursor:default;
    width:auto
}

table.blist td
{
    border-bottom:1px solid #EEE;
    color:#454545;
    margin:0;
    padding:8px 5px 8px 3px;
    text-align:right;
    font-weight:500;
}

table.blist td.first
{
    border-left:1px none #CCC;
    padding-left:8px;
    text-align:left
}

table.blist td.last
{
    border-right:1px none #CCC;
    padding-right:8px;
    text-align:right
}

table.blist .even
{
    background-color:#FFF
}

table.blist .odd
{
    background-color:#F8F8F8
}

table.blist .even.first.excluded td
{
    color:#aaa
}

table.blist .excluded_warning_img
{
    display:none;
    height:15px;
    width:15px
}

table.blist .excluded_warning_img.visible
{
    -webkit-transition:all .2s ease-in-out;
    -moz-transition:all .2s ease-in-out;
    -ms-transition:all .2s ease-in-out;
    transition:all .2s ease-in-out;
    display:inline-block;
    margin-left:7px;
    opacity:.8;
    vertical-align:bottom
}

table.blist .excluded_warning_img.visible:hover
{
    cursor:pointer;
    opacity:1
}