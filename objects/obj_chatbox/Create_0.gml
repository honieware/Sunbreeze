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
text[0] = "This is just some example text to see how well this wraps.";
text[1] = "WHEN THE EXAMPLE IS TEXT!";
text[2] = "Epic gamers commiting acts of epic Gaming.";
text[3] = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn't commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune. If you have a problem and no one else can help, and if you can find them, maybe you can hire the A-team.";
text_length[0] = string_length(text[0]);
draw_char = 0; // How many of the characters are currently being drawn
text_spd = 1;

setup = false;