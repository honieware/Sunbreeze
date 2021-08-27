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
		
		// Get X position for textbox
		text_x_offset[p] = 24;
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
var _txtb_x = textbox_x + 24;
var _txtb_y = textbox_y;

txtb_img += txtb_img_spd;
txtb_spr_w = sprite_get_width(txtb_spr);
txtb_spr_h = sprite_get_height(txtb_spr);

// Draw the text bubble
draw_sprite_ext(txtb_spr, txtb_img, _txtb_x, _txtb_y, textbox_width / txtb_spr_w, textbox_height / txtb_spr_h, 0, c_white, 1);

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
		draw_sprite_ext(_opt_spr, txtb_img, 288, _txtb_y + 16, _opt_width / _opt_spr_w, _opt_height / _opt_spr_h, 0, c_white, 1)
	}

	for (var op = 0; op < option_number; op++) {
		// TODO: Draw a proper option box (9-slice)
		//var _o_w = string_width(option[op]) + _op_bord*2;
		//var _opt_width = array_length(option) * string_height(option[op]) + _op_bord*2 + _op_box_bord*2;
		//draw_sprite_ext(spr_optionbox, txtb_img, _txtb_x + 16, _txtb_y - _op_space * option_number + _op_space * op, _o_w / txtb_spr_w, (_op_space - 1) / txtb_spr_h, 0, c_white, 1);

		// Draw the option's text
		draw_text((288 - _opt_width) + _op_box_bord,  _txtb_y - _op_space * option_number + _op_space * op + 2, option[op]);
	
		// Draw the arrow
		if option_pos == op {
			draw_sprite(spr_chatbox_point, 0, (288 - _opt_width) - 16, _txtb_y - _op_space * option_number + _op_space * op)	
		}		
	}
}

// Draw the namebox bubble
/*
nmeb_spr = spr_namebox;
nmeb_spr_w = sprite_get_width(nmeb_spr);
nmeb_spr_h = sprite_get_height(nmeb_spr);
show_debug_message(nmeb_spr_w);
show_debug_message(nmeb_spr_h);
draw_sprite_ext(nmeb_spr, txtb_img, _txtb_x, _txtb_y - 12, nmeb_width / nmeb_spr_w, nmeb_height / nmeb_spr_h, 0, c_red, 1);
*/

// Draw the actual text
// String "arrays" start at 1. Stupid, I know
var _drawtext = string_copy(text[page], 1, draw_char);
draw_text_ext(_txtb_x + border, _txtb_y + border, _drawtext, line_sep, line_width);