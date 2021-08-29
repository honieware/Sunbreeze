accept_key = keyboard_check_pressed(ord("E"));

textbox_x = camera_get_view_x(view_camera[0]);
textbox_y = camera_get_view_y(view_camera[0]) + 100;

global.is_chatting = true;

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
		portrait_x_offset[p] = 70;
		
		// Character on the middle
		if speaker_side[p] == 0 {
			text_x_offset[p] = 8;
			portrait_x_offset[p] = 64;
		}
		
		// Character on the right
		if speaker_side[p] == -1 {
			text_x_offset[p] = 8;
			portrait_x_offset[p] = 128;
		}
		
		// No character (center textbox)
		if speaker_sprite[p] == noone {
			text_x_offset[p] = 22;
		}
		
		// Get X position for textbox
		text_x_offset[p] = 22;
		
		// NOTE: This is all mega big brain stuff I don't quite understand yet.
		// Modify with caution!
		// Setting individual characters and finding where the lines of text should break
		for (var c = 0; c < text_length[p]; c++) {
			
			var _char_pos = c + 1; // String arrays start at one
			
			// Store individual characters in the "char" array
			char[c, p] = string_char_at(text[p], _char_pos);
			
			// Get current width of the line
			var _txt_up_to_char = string_copy(text[p], 1, _char_pos);
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


if (typing_timer == 0) {

	// ---------- Creating the background ----------

	if background_spr[page] {
		var _bg_w = sprite_get_width(background_spr[page]);
		var _bg_h = sprite_get_height(background_spr[page]);
		var _bg_alpha = 0.5;
		var _v_w = camera_get_view_width(view_camera[0]) + _bg_w;
		var _v_h = camera_get_view_height(view_camera[0]) + _bg_h;
	
		for (var _bg_x = 0; _bg_x < _v_w; _bg_x++) {
			for (var _bg_y = 0; _bg_y < _v_h; _bg_y++) {
				draw_sprite_ext(background_spr[page], 0, _bg_x - background_offset, _bg_y - background_offset, 1, 1, 0, c_white, _bg_alpha);
				_bg_y += _bg_h - 1;
			}
			_bg_x += _bg_w - 1;
		}
	
		// Assumes background width and height are the same.
		// Currently can't be arsed to do it "properly".
		if (background_delay == 0) {
			background_delay = 5;
			if (background_offset != _bg_w) {
				background_offset++;
			} else {
				background_offset = 0;
			}
		} else {
			background_delay--;
		}
	}

	// ---------- Typing the text ----------
	if text_pause_timer <= 0 {
		if (draw_char < text_length[page]) { // If not the final character
			draw_char += text_spd;
			draw_char = clamp(draw_char, 0, text_length[page]); // draw_char can't be higher than these values
			var _check_char = string_char_at(text[page], draw_char);
			if _check_char == "?" || _check_char == "!" || _check_char == "," {  //inefficient lol
				text_pause_timer = text_pause_time;	
				if !audio_is_playing(snd[page]) && _check_char == "." {
					// Punctuation sound (bebebese)
				}
			} else {
				// Typing sound
				if snd_count < snd_delay {
					snd_count ++	
				} else {
					if _check_char == "." {
						snd_count = 0;
						audio_play_sound(animalese_beep, 8, false);
					} else if (snd[page] != noone) {
						snd_count = 0;
						audio_play_sound(snd[page], 8, false);
					} else if (asset_get_index("animalese_" + string_lower(_check_char))) {
						snd_count = 0;
						var _animalese_file = asset_get_index("animalese_" + string_lower(_check_char));
						audio_sound_pitch(_animalese_file, snd_pitch_multiplier[page]);
						audio_play_sound(_animalese_file, 8, false);
					}
				}
			}
		}
	} else {
		text_pause_timer--;	
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
				global.is_chatting = false;
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
		// When they're done talking, reset animation to first frame
		if draw_char == text_length[page] || (draw_char == "." || draw_char == "?" || draw_char == "!" || draw_char == ",") {
			image_index = 0;
		}
		var _speaker_x = textbox_x + portrait_x_offset[page];
		if speaker_side[page] == -1 {
			_speaker_x += sprite_width;
		}
	
		// Ease in

		if (old_speaker_name != name_string[page])  {
			curve_spd = 0;
		}
	
		curve_spd += 1/20;
		position = animcurve_channel_evaluate(curve_ease, curve_spd);
		var _ease_start = _speaker_x + 15;
		var _distance = _speaker_x - _ease_start
	
		draw_sprite_ext(sprite_index, image_index, _ease_start + (_distance * position), textbox_y + 9, 1, 1, 0, c_white, 0 + position);
	
		old_speaker_name = name_string[page];
	}

	sprite_set_offset(txtb_spr[page], 0, 0);
	
	// Draw the text bubble
	draw_sprite_ext(txtb_spr[page], txtb_img, _txtb_x, _txtb_y, textbox_width / txtb_spr_w, textbox_height / txtb_spr_h, 0, c_white, 1);

	// Simple sine-like movement
	float_number += 4;
	var _float_arrow = dsin(float_number);

	// Draw the "next dialogue" arrow
	if draw_char == text_length[page] && page != page_number - 1 {
		draw_sprite(spr_continue_arrow, 0, _txtb_x + (textbox_width / 2), (textbox_height + _txtb_y) - 5 + _float_arrow);
	}

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
				draw_sprite(spr_chatbox_point, 0, (option_x - _opt_width - _float_arrow) - 16, _txtb_y - _op_space * option_number + _op_space * op)	
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
	
		// -------- Special stuff! --------
		// Wavy text
		var _float_y = 0;
		if float_text[c, page] == true {
			float_dir[c, page] += -6;
			_float_y = dsin(float_dir[c, page]) // Returns between a positive and negative one based on a circle's rotation
		}
		// Shake text
		var _shake_x = 0;
		var _shake_y = 0;
		if shake_text[c, page] == true {
			shake_timer[c, page]--;
			if shake_timer[c, page] <= 0 {
				shake_timer[c, page] = irandom_range(4, 8);
				shake_dir[c, page] = irandom(360);
			}
			if shake_timer[c, page] <= 2 {
				_shake_x = lengthdir_x(1, shake_dir[c, page]);
				_shake_y = lengthdir_y(1, shake_dir[c, page]);
			}
		}
		// Draw text
		draw_text_color(char_x[c, page] + _shake_x, char_y[c, page] + _float_y + _shake_y, char[c, page], col_1[c, page], col_2[c, page], col_3[c, page], col_4[c, page], 1);
	}
}

// Decrease waiting timer
if (typing_timer != 0) {
	typing_timer--;


	// ---------- Draw the window ----------
	var _txtb_x = textbox_x + 38;
	var _txtb_y = textbox_y;

	txtb_img += txtb_img_spd;

	txtb_spr_w = sprite_get_width(txtb_spr[page]);
	txtb_spr_h = sprite_get_height(txtb_spr[page]);

	// Draw the speaker
	/*
	if speaker_sprite[page] != noone {
		sprite_index = speaker_sprite[page];
		// When they're done talking, reset animation to first frame
		if draw_char == text_length[page] || (draw_char == "." || draw_char == "?" || draw_char == "!" || draw_char == ",") {
			image_index = 0;
		}
		var _speaker_x = textbox_x + portrait_x_offset[page];
		if speaker_side[page] == -1 {
			_speaker_x += sprite_width;
		}
	
		// Ease in

		if (old_speaker_name != name_string[page])  {
			curve_spd = 0;
		}
	
		curve_spd += 1/20;
		position = animcurve_channel_evaluate(curve_ease, curve_spd);
		var _ease_start = _speaker_x + 15;
		var _distance = _speaker_x - _ease_start
	
		draw_sprite_ext(sprite_index, image_index, _ease_start + (_distance * position), textbox_y + 9, 1, 1, 0, c_white, 0 + position);
	
		old_speaker_name = name_string[page];
	}
	*/

	// Draw the text bubble
	
	sprite_set_offset(txtb_spr[page], txtb_spr_w / 2, txtb_spr_h / 2);
	
	var _stretchh = (ease_out_back(typing_timer, txtb_spr_w, 10, 12));
	var _stretchv = (ease_out_back(typing_timer, txtb_spr_h, 10, 12));
	
	show_debug_message("Horizontal width: " + string(_stretchh));
	show_debug_message("Vertical width: " + string(_stretchv));
	
	//	draw_sprite_ext(txtb_spr[page], txtb_img, _txtb_x, _txtb_y, textbox_width / txtb_spr_w, textbox_height / txtb_spr_h, 0, c_white, 1);
	draw_sprite_ext(txtb_spr[page], txtb_img, _txtb_x + txtb_spr_w / 2, _txtb_y + txtb_spr_h / 2, _stretchh / txtb_spr_w, _stretchv / txtb_spr_h, 0, c_white, 1);
}