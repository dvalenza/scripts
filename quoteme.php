<?php
$words = "
BXSUB_272066
";

//echo $words;
foreach (preg_split("/((\r?\n)|(\r\n?))/",$words) as $word){
$word = explode('_',$word)[1];  //user for items like COMP_255750
echo '\''.$word.'\',';
//echo $word.',';
}
?>
