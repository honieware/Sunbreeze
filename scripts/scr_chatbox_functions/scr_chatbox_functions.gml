function scr_set_defaults_for_text() {
	line_break_pos[0, page_number] = 999; // Stores where in the text should the text move to the next line
	line_break_num[page_number] = 0;
	line_break_offset[page_number] = 0;
}

/// @param text
function scr_text(_text){
	scr_set_defaults_for_text();
	text[page_number] = _text;
	page_number++;
}

/// @param option
/// @param link_id
function scr_option(_option, _link_id) {
	option[option_number] = _option;
	option_link_id[option_number] = _link_id;
	option_number++;
}

/// @param name
/// @param text_color
/// @param box_color
function scr_name(_name, _text_color, _box_color) {
	name_string = _name;
	name_color = _text_color;
	name_textbox_color = _box_color;
}

/// @param text_id
function create_textbox(_text_id) {
	with (instance_create_depth(0, 0, -9999, obj_chatbox)) {
		scr_game_script(_text_id);
	}
} 