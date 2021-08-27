depth = -999999;

// Textbox related variables
textbox_width = 244;
textbox_height = 69; // nice
border = 16; // Border between the chatbox and the letters
line_sep = 15; // Separation between lines (vertical)
line_width = textbox_width - border*2;
txtb_spr = spr_chatbox;
txtb_img = 0;
txtb_img_spd = 0;

// Text related variables
page = 0; // Text page :)
page_number = 0;
text[0] = "";
text_length[0] = string_length(text[0]);
draw_char = 0; // How many of the characters are currently being drawn
text_spd = 1;
draw_set_color($5b7481);

// Options
option[0] = "";
option_link_id[0] = -1; // To check for the link after replying to the option
option_pos = 0; // For scrolling through positions
option_number = 0;

setup = false;