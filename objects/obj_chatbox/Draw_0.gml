accept_key = keyboard_check_pressed(vk_space);

textbox_x = camera_get_view_x(view_camera[0]);
textbox_y = camera_get_view_y(view_camera[0]) + 100;

// ---------- Setup ----------
if setup == false {
	
	setup = true;
	
	draw_set_font(global.font_main);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	
	// Loop through the pages
	for (var p = 0; p < page_number; p++) {
		
		// Find how many characters are in each page
		// and store that number in the "text_length" array
		text_length[p] = string_length(text[p]);
		
		// Character on the left
		text_x_offset[p] = 80;
		portrait_x_offset[p] = 8;

		// Character on the right
		if speaker_side[p] == -1 {
			text_x_offset[p] = 8;
			portrait_x_offset[p] = 216;
		}
		
		// No character (center textbox)
		if speaker_sprite[p] == noone {
			text_x_offset[p] = 24;
		}
		
		// Get X position for textbox
		text_x_offset[p] = 24;
		
		// NOTE: This is all mega big brain stuff I don't quite understand yet.
		// Modify with caution!
		// Setting individual characters and finding where the lines of text should break
		for (var c = 0; c < text_length[p]; c++) {
			
			var _char_pos = c + 1; // String arrays start at one
			
			// Store individual characters in the "char" array
			char[c, p] = string_char_at(text[p], _char_pos);
			
			// Get current width of the line
			var _txt_up_to_char = string_copy(text[p], 1, _char_pos);
			show_debug_message("First CHAR")
			show_debug_message("C: " + string(c))
			show_debug_message("P: " + string(p))
			var _current_txt_w = string_width(_txt_up_to_char) - string_width(char[c, p]);
			
			// Get the last free space
			if (char[c, p] == " ") {
				last_free_space = _char_pos + 1;
			}
			
			// Get the line breaks
			if _current_txt_w - line_break_offset[p] > line_width {
				line_break_pos[line_break_num[p], p] = last_free_space;
				line_break_num[p]++;
				var _txt_up_to_last_space = string_copy(text[p], 1, last_free_space);
				var _last_free_space_string = string_char_at(text[p], last_free_space);
				line_break_offset[p] = string_width(_txt_up_to_last_space) - string_width(_last_free_space_string);
			}
		}
		
		// Getting each characters' coordinates
		for (var c = 0; c < text_length[p]; c++) {
			
			var _char_pos = c + 1;
			
			// Probably wrong?
			var _txt_x = textbox_x + text_x_offset[p] + border * 2;
			var _txt_y = textbox_y + border;
			
			// Get current width of the line
			var _txt_up_to_char = string_copy(text[p], 1, _char_pos);
			show_debug_message("Second CHAR")
			show_debug_message("C: " + string(c))
			show_debug_message("P: " + string(p))
			show_debug_message("Char: " + string(char[c, p]))
			var _current_txt_w = string_width(_txt_up_to_char) - string_width(char[c, p]);
			var _txt_line = 0;
			
			// Compensate for string breaks
			for (var lb = 0; lb < line_break_num[p]; lb++) {
				// If the current looping character is after a line break
				if (_char_pos >= line_break_pos[lb, p]) {
					var _str_copy = string_copy(text[p], line_break_pos[lb, p], _char_pos - line_break_pos[lb, p]);
					_current_txt_w = string_width(_str_copy);
					
					// Record the "line" this character should be on
					_txt_line = lb+1; // +1 since lb starts at 0
				}
			}
			
			// Add to the X and Y coordinates based on the new info
			char_x[c, p] = _txt_x + _current_txt_w;
			char_y[c, p] = _txt_y + _txt_line * line_sep;
		}
	}
}

// ---------- Typing the text ----------
if (draw_char < text_length[page]) { // If not the final character
	draw_char += text_spd;
	draw_char = clamp(draw_char, 0, text_length[page]); // draw_char can't be higher than these values
}

// ---------- Flip through pages ----------
if (accept_key) {
	
	// If the typing is done
	if (draw_char == text_length[page]) {
		
		// Go to the next page
		if (page < page_number - 1) {
			page++;
			draw_char = 0;
		} else {
			// Link text for options
			if option_number > 0 {
				create_textbox(option_link_id[option_pos]);	
			}
			
			// Destroy textbox
			instance_destroy();	
		}
	} else {
		
		// Fill out (skip) text
		draw_char = text_length[page];
		
	}
	
}

// ---------- Draw the window ----------
var _txtb_x = textbox_x + 38;
var _txtb_y = textbox_y;

txtb_img += txtb_img_spd;

txtb_spr_w = sprite_get_width(txtb_spr[page]);
txtb_spr_h = sprite_get_height(txtb_spr[page]);

// Draw the speaker
if speaker_sprite[page] != noone {
	sprite_index = speaker_sprite[page];
	var _speaker_x = textbox_x + portrait_x_offset[page];
	if speaker_side[page] == -1 {
		_speaker_x += sprite_width;
	}
	//draw_sprite_ext(txtb_spr[page], txtb_img, textbox_x + portrait_x_offset[page], textbox_y, sprite_width / txtb_spr_w, sprite_height / txtb_spr_h, 0, c_white, 1);
	draw_sprite_ext(sprite_index, image_index, _speaker_x, textbox_y, speaker_side[page], 1, 0, c_white, 1);
}

// Draw the text bubble
draw_sprite_ext(txtb_spr[page], txtb_img, _txtb_x, _txtb_y, textbox_width / txtb_spr_w, textbox_height / txtb_spr_h, 0, c_white, 1);

// ---------- Options ----------
if draw_char == text_length[page] && page == page_number - 1 {
	
	// Option selection
	option_pos += keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
	option_pos = clamp(option_pos, 0, option_number - 1);
	
	// Draw the options
	var _op_space = 15;
	var _op_bord = 5;
	var _op_box_bord = 10;
	
	var _opt_spr = spr_optionbox;
	var _opt_width = 150;
	var _opt_height = 40;
	
	// Draw the option bubble
	var _longest_op_width = 0;
	var _longest_op_height = 0;
	
	// Get the longest element in an array
	for (var op2 = 0; op2 < array_length(option); op2++) {
		if (string_width(option[op2]) > _longest_op_width) {
			_longest_op_width = string_width(option[op2]);
		}
		if (string_height(option[op2]) > _longest_op_height) {
			_longest_op_height = string_height(option[op2]);
		}
	}

	var _opt_width = _longest_op_width + _op_box_bord*2;
	var _opt_height = array_length(option) * _longest_op_height + _op_bord*2 + _op_box_bord*2;
		
	var _opt_spr_w = sprite_get_width(_opt_spr);
	var _opt_spr_h = sprite_get_height(_opt_spr);
	
	if option_number > 0 {
		draw_sprite_ext(_opt_spr, txtb_img, option_x, _txtb_y + 16, _opt_width / _opt_spr_w, _opt_height / _opt_spr_h, 0, c_white, 1)
	}

	for (var op = 0; op < option_number; op++) {
		
		var _o_w = string_width(option[op]) + _op_bord*2;
		var _opt_spr_w = sprite_get_width(spr_selectbox);
		
		// Draw the selected box, arrow
		if option_pos == op {
			draw_sprite_ext(spr_selectbox, txtb_img, (option_x - _opt_width) + _op_box_bord - 5, _txtb_y - _op_space * option_number + _op_space * op + 5, _o_w / _opt_spr_w, 1, 0, c_white, 1);
			draw_sprite(spr_chatbox_point, 0, (option_x - _opt_width) - 16, _txtb_y - _op_space * option_number + _op_space * op)	
		}	
		
		// Draw the option's text
		draw_text((option_x - _opt_width) + _op_box_bord,  _txtb_y - _op_space * option_number + _op_space * op + 2, option[op]);	
	}
}

// Name box
nmeb_spr = spr_namebox;
nmeb_spr_w = sprite_get_width(nmeb_spr);
nmeb_spr_h = sprite_get_height(nmeb_spr);
name_spacing = 4;
name_str_w = string_width(name_string[page]) + name_spacing * 2

if name_string[page] != noone {
	// Draw the namebox bubble
	draw_sprite_ext(nmeb_spr, txtb_img, _txtb_x + 40, _txtb_y, name_str_w / nmeb_spr_w, nmeb_height / nmeb_spr_h, 0, name_textbox_color[page], 1);

	// Draw the namebox's text
	draw_set_halign(fa_center);
	draw_set_color(name_color[page]);
	draw_text_ext(_txtb_x + 42, _txtb_y - 6, name_string[page], line_sep, line_width);
	draw_set_halign(fa_left);
	draw_set_color(text_def_color);
}

// Draw the actual text
// String "arrays" start at 1. Stupid, I know

for (var c = 0; c < draw_char; c++) {
	// The text
	draw_text(char_x[c, page], char_y[c, page], char[c, page]);
}

// - OLD WAY OF DRAWING TEXT -
//var _drawtext = string_copy(text[page], 1, draw_char);
//draw_text_ext(_txtb_x + border, _txtb_y + border, _drawtext, line_sep, line_width);