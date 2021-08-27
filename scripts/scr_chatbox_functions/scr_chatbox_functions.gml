function scr_set_defaults_for_text() {
	line_break_pos[0, page_number] = 999; // Stores where in the text should the text move to the next line
	line_break_num[page_number] = 0;
	line_break_offset[page_number] = 0;
	
	txtb_spr[page_number] = spr_chatbox;
	speaker_sprite[page_number] = noone;
	speaker_side[page_number] = -1; // Left: 1, Center: 0, Right: -1
	
	name_string[page_number] = noone;
	name_color[page_number] = $ffffff;
	name_textbox_color[page_number] = $666666;
}

/// @param text
/// @param [character]
function scr_text(_text){

	scr_set_defaults_for_text();
	text[page_number] = _text;
	
	// Get character info
	if argument_count > 1 {
		switch(argument[1]) {
			case "Rover":
				speaker_sprite[page_number] = spr_rover_neutral;
				name_string[page_number] = "Rover";
				name_textbox_color[page_number] = $d36356;
				break;
			case "Player":
				name_string[page_number] = "Player";
				name_textbox_color[page_number] = $0a337a;
				break;
			case "Alex":
				speaker_sprite[page_number] = spr_alex_yiikposting;
				name_string[page_number] = "Alex";
				name_textbox_color[page_number] = $0a337a;
				break;
			case "???":
				name_string[page_number] = "???";
				break;
		}
	}
		
	page_number++;

}

/// @param option
/// @param link_id
function scr_option(_option, _link_id) {
	option[option_number] = _option;
	option_link_id[option_number] = _link_id;
	option_number++;
}

/// @param text_id
function create_textbox(_text_id) {
	with (instance_create_depth(0, 0, -9999, obj_chatbox)) {
		scr_game_script(_text_id);
	}
} 