// @param character_id
function scr_character_settings(_character_id){
	switch (_character_id) {
		case "Rover":
			scr_name("Rover", $ffffff, $d36356);
			break;
		case "Player":
			scr_name("Player", $ffffff, $0a337a);
			break;
		case "???":
			scr_name("???", $ffffff, $666666);
			break;
	}
}