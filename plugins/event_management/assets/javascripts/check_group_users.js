// グループ一括チェック.
// @note 何か機能的に、引数だけで使い回せたりしないものか・・・.
$(function(){
	  $("input:checkbox[@name^='groups_check']").click(function(){
		 var group_id = Number(this.id);
		 var is_group_cheked = this.checked;
		 var child_ids = CHECK_GROUP_CHILD_OFFSET + group_id;
		 var child_hash = "child_checks_" + child_ids;
		 var $checks = $("input[id=" + child_hash + "]");
		 var test = 0;
		 $checks.map( 
			function(index, el) {
				$(this).attr( "checked", is_group_cheked );
			}
		 ); 
	  });
	});  
